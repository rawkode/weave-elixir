defmodule Weave.Loaders.Environment do
  use Weave.Loader

  def load_configuration() do
    with {:ok, environment_prefix}  <- Application.fetch_env(:weave, :environment_prefix),
      {:ok, handler}                <- Application.fetch_env(:weave, :handler),
      environment_variables         <- System.get_env()
    do
      environment_variables
      |> Enum.filter_map(
        fn({key, value}) -> String.starts_with?(key, environment_prefix) end,
        fn({key, value}) ->
          apply_configuration(String.downcase(String.trim_leading(key, environment_prefix)), value, handler)
        end)
    else
      :error -> Logger.warn("Tried to load configuration, but :weave hasn't been configured properly. Check :environment_prefix and :handler")
    end
  end
end
