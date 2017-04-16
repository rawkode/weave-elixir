defmodule Weave.Loader.File do
  require Logger

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

    try do
      {app, key, value} = handler.handle_configuration(file_name, configuration)
      Application.put_env(app, key, merge(Application.get_env(app, key), value))
      Logger.debug("Configuration for #{app}:#{key} loaded: #{inspect Application.get_env(app, key)}")
    rescue
      error in UndefinedFunctionError ->
        Logger.info("#{inspect error}")
        handle_configuration(file_name, configuration)
    end
  end

  defp merge(nil, new) when is_list(new) do
    merge([], new)
  end

  defp merge(old, new) when is_list(new) do
    if Keyword.keyword?(new) do
      Logger.debug("Merging keywords: #{inspect old} and #{inspect new}")
      Keyword.merge(old, new)
    else
      Logger.debug("Merging lists #{inspect old} and #{inspect new}")
      old ++ new
    end
  end

  defp merge(nil, new) when is_map(new) do
    merge(%{}, new)
  end

  defp merge(old, new) when is_map(new) do
    Map.merge(old, new)
  end

  defp merge(old, new) when is_binary(new) do
    new
  end

  defp handle_configuration(file_name, configuration) do
    Logger.warn("External configuration (#{file_name}) provided, but not loaded")
    Logger.debug("configuration value for ignored '#{file_name}' is '#{configuration}'")
  end
end
