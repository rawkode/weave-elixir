defmodule Weave.Loaders.File do
  use Weave.Loader

  @moduledoc """
  This loader will attempt to consume files located within a configured directory. The directory must be cofigured as:

  ```elixir
  config :weave, file_directory: "/some/path"
  ```

  With the above configuration, any files in `/some/path` will be sent to the handler. Please note, the filenames will be "sanitized" before being sent to the handler.

  This means "/some/path/my_DB_password" will become "my_db_password"
  """

  @spec load_configuration() :: :ok
  def load_configuration() do
    with file_directory when file_directory !== :weave_no_directory <- Application.get_env(:weave, :file_directory, :weave_no_directory),
      handler           when handler !== :weave_no_handler <- Application.get_env(:weave, :handler, :weave_no_handler),
      file_directory    <- String.trim_trailing(file_directory, "/"),
      true              <- File.exists?(file_directory),
      {:ok, files}      <- File.ls(file_directory)
    do
      Logger.debug fn -> "Found configuration parameters: #{inspect files}" end
      Enum.each(files, fn (file_name) ->
        load_configuration(file_directory, file_name, handler)
      end)
    else
      :weave_no_directory -> Logger.warn fn -> "Tried to load configuration, but {:weave, :file_directory} hasn't been configured" end
      :weave_no_handler -> Logger.warn fn -> "Tried to load configuration, but {:weave, :handler} hasn't been configured" end
      false -> Logger.warn fn -> "Tried to load configuration from '#{Application.get_env(:weave, :file_directory)}', but directory doesn't exist." end
    end

    :ok
  end

  @spec load_configuration(binary(), binary(), atom()) :: :ok
  defp load_configuration(file_directory, file_name, handler) do
    configuration = "#{file_directory}/#{file_name}"
                    |> File.read!()
                    |> String.trim()

    apply_configuration(file_name, configuration, handler)
  end
end
