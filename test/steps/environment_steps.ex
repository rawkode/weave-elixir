defmodule Test.Feature.Steps.Environment do
  use Cabbage.Feature

  defand ~r/^I have configured Weave's Environment loader to load environment variables with prefix "(?<environment_prefix>[^"]+)"$/, %{environment_prefix: environment_prefix}, state do
    Application.put_env(:weave, :environment_prefix, environment_prefix)
    {:ok, Map.merge(state, %{environment_prefix: environment_prefix})}
  end

  defand ~r/^the following environment variables exist$/, %{table: variables}, state = %{environment_prefix: environment_prefix} do
    Enum.each(variables, fn(%{key: key, value: value}) ->
      System.put_env("#{environment_prefix}#{key}", value)
    end)
    {:ok, Map.merge(state, %{expected_configuration: variables})}
  end

  defwhen ~r/^I run Weave's Environment loader$/, _vars, state do
    Weave.Loaders.Environment.load_configuration()
    {:ok, state}
  end

  defthen ~r/^my application should be configured$/, _vars, %{expected_configuration: expected_configuration} do
    Enum.each(expected_configuration, fn(%{key: key, value: value}) ->
       assert Application.get_env(:weave, String.to_atom(key)) == value
    end)
    {:ok, %{}}
  end
end
