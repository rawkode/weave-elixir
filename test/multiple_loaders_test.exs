defmodule Test.Feature.MultipleLoaders do
  use Cabbage.Feature, file: "multiple_loaders.feature"

  import_steps Test.Feature.Steps.Shared
  import_steps Test.Feature.Steps.Environment
  import_steps Test.Feature.Steps.File

  defand ~r/^I have configured Weave to use multiple loaders$/, _vars, _state do
    Application.put_env(:weave, :loaders, [
      Weave.Loaders.File,
      Weave.Loaders.Environment
    ])

    {:ok, %{}}
  end

  defwhen ~r/^I run Weave.configure$/, _vars, state do
    Weave.configure()

    {:ok, state}
  end

  defthen ~r/^my application should be configured by both loaders$/, _vars, _state do
    assert Application.get_env(:weave, :database_host) == "my-database-host.com"
    assert Application.get_env(:weave, :cookie_secret, "") == "I am super Secur3"
  end
end
