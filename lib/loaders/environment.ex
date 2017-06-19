defmodule Weave.Loaders.Environment do
  use Weave.Loader

  @moduledoc """
  This loader will utilise the available environment variables to provide configuration. A prefix must be specified in the configuration:

  ```elixir
  config :weave, environment_prefix: "MY_APP_"
  ```

  With the above configuration, any environment variables that begin with `MY_APP_` will be sent to the handler. Please note, these will be "sanitized" before being sent to the handler.

  This means "MY_APP_NAME" will become "name"
  """

  @spec load_configuration() :: :ok
  def load_configuration() do
    with {:ok, environment_prefix}  <- Application.fetch_env(:weave, :environment_prefix),
      {:ok, handler}                <- Application.fetch_env(:weave, :handler),
      environment_variables         <- System.get_env()
    do
      Enum.filter_map(environment_variables,
        fn({key, value}) -> String.starts_with?(key, environment_prefix) end,
        fn({key, value}) ->
          apply_configuration(String.trim_leading(key, environment_prefix), value, handler)
        end)
    else
      :error -> Logger.warn fn -> "Tried to load configuration, but :weave hasn't been configured properly. Check :environment_prefix and :handler" end
    end

    :ok
  end
end
