defmodule Weave.Loader do
  @moduledoc """
  This behaviour should be implemented by all loaders. This will be handled for you with:

  ```elixir
  use Weave.Loader
  ```
  """

  @callback load_configuration() :: any

  defmacro __using__(_) do
    quote do
      require Logger

      @behaviour Weave.Loader

      @spec apply_configuration(String.t(), String.t(), atom()) :: :ok
      defp apply_configuration(name, contents, handler) do
        try do
          name
          |> sanitize()
          |> handler.handle_configuration(contents)
          |> configure()
        rescue
          error in [UndefinedFunctionError, FunctionClauseError] ->
            Logger.info fn -> inspect(error) end
            handle_configuration(name, contents)
        end

        :ok
      end

      # We're transforming this to a List, as I believe we'll
      # eventually enforce all handle_configuration/1's return List
      @spec configure({atom(), atom(), any()}) :: :ok
      defp configure({app, key, value}) do
        configure([{app, key, value}])
      end

      @spec configure([{atom(), atom(), any()}]) :: :ok | []
      defp configure([{app, key, value} | tail]) do
        Application.put_env(app, key, merge(Application.get_env(app, key), value))
        Logger.debug fn -> "Configuration for #{app}:#{key} loaded: #{inspect Application.get_env(app, key)}" end

        configure(tail)
      end

      defp configure([]) do
        :ok
      end

      @spec merge(any(), any()) :: List.t() | Map.t() | String.t()
      defp merge(nil, new) when is_list(new) do
        merge([], new)
      end

      defp merge(old, new) when is_list(new) do
        if Keyword.keyword?(new) do
          Logger.debug fn -> "Merging keywords: #{inspect old} and #{inspect new}" end
          Keyword.merge(old, new)
        else
          Logger.debug fn -> "Merging lists #{inspect old} and #{inspect new}" end
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

      @spec handle_configuration(String.t(), String.t()) :: :ok

      defp handle_configuration(parameter_name, "{:auto," <> configuration) do
        {{app, key, value}, []} = Code.eval_string(~s/{#{configuration}/)

        Application.put_env(app, key, merge(Application.get_env(app, key), value))

        :ok
      end

      defp handle_configuration(file_name, configuration) do
        Logger.warn fn -> "External configuration (#{file_name}) provided, but not loaded" end
        Logger.debug fn -> "configuration value for ignored '#{file_name}' is '#{configuration}'" end

        :ok
      end

      @spec sanitize(Sting.t()) :: String.t()
      defp sanitize(name) do
        String.downcase(name)
      end
    end
  end
end
