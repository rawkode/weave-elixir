defmodule Weave.Loaders.File do
  use Weave.Loader

  def load_configuration() do
    with file_directory <- Application.get_env(:weave, :file_directory, :weave_no_directory),
      handler           <- Application.get_env(:weave, :handler, :weave_no_handler),
      file_directory    <- String.trim_trailing(file_directory, "/"),
      true              <- File.exists?(file_directory),
      {:ok, files}      <- File.ls(file_directory)
    do
      Logger.debug("Found configuration parameters: #{inspect files}")
      Enum.each(files, fn (file_name) ->
        load_configuration(file_directory, file_name, handler)
      end)
    else
      :weave_no_directory -> Logger.warn("Tried to load configuration, but {:weave, :file_directory} hasn't been configured")
      :weave_no_handler -> Logger.warn("Tried to load configuration, but {:weave, :handler} hasn't been configured")
      false -> Logger.warn("Tried to load configuration from '#{Application.get_env(:weave, :file_directory)}', but directory doesn't exist.")
    end
  end

  defp load_configuration(file_directory, file_name, handler) do
    configuration = "#{file_directory}/#{file_name}"
             |> File.read!()
             |> String.trim()

    apply_configuration(String.downcase(file_name), configuration, handler)
  end
end
