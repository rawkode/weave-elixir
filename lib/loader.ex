defmodule Weave.Loader do
  @callback load_configuration() :: any

  defmacro __using__(_) do
    quote do
      require Logger

      @behaviour Weave.Loader

      defp apply_configuration(name, contents, handler) do
        try do
          {app, key, value} = name
          |> sanitize
          |> handler.handle_configuration(contents)
          Application.put_env(app, key, merge(Application.get_env(app, key), value))
          Logger.debug("Configuration for #{app}:#{key} loaded: #{inspect Application.get_env(app, key)}")
        rescue
          error in [UndefinedFunctionError, FunctionClauseError] ->
            Logger.info(inspect error)
            handle_configuration(name, contents)
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
          new ++ old
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


      defp sanitize(name) do
        String.downcase(name)
      end
    end
  end
end
