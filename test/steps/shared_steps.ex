defmodule Test.Feature.Steps.Shared do
  use Cabbage.Feature

  defgiven ~r/^I have configured Weave with a handler$/, _vars, state do
    Application.put_env(:weave, :handler, Test.Weave.Handler)
    {:ok, state}
  end
end
