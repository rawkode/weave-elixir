defmodule Test.Feature.Loaders.Environment do
  use Cabbage.Feature, file: "loaders/environment.feature"

  import_steps Test.Feature.Steps.Shared
  import_steps Test.Feature.Steps.Environment
end
