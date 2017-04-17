defmodule Test.Feature.Loaders.Environment do
  use Cabbage.Feature, file: "loaders/environment.feature"

  defgiven ~r/^I have configured weave to load environment variables with prefix "(?<environment_prefix>[^"]+)"$/, %{environment_prefix: environment_prefix}, _state do
    Application.put_env(:weave, :environment_prefix, environment_prefix)
    {:ok, %{environment_prefix: environment_prefix}}
  end

  defand ~r/^I have provided the configuration handler$/, _vars, state do
    Application.put_env(:weave, :handler, Test.Weave.Handler)
    {:ok, state}
  end

  defand ~r/^the following environment variables exist$/, %{table: variables}, state = %{environment_prefix: environment_prefix} do
    Enum.each(variables, fn(%{key: key, value: value}) ->
      System.put_env("#{environment_prefix}#{key}", value)
    end)
    {:ok, Map.merge(state, %{expected_configuration: variables})}
  end

  defwhen ~r/^I run the Weave file loader$/, _vars, state do
    Weave.Loaders.Environment.load_configuration()
    {:ok, state}
  end

  defthen ~r/^my application should be configured$/, _vars, %{environment_prefix: environment_prefix, expected_configuration: expected_configuration} do
    expected_configuration
    |> Enum.each(fn(%{key: key, value: value}) ->
       assert Application.get_env(:weave, String.to_atom(key)) == value
    end)
    {:ok, %{}}
  end
end
