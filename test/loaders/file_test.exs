defmodule Test.Feature.Loaders.File do
  use Cabbage.Feature, file: "loaders/file.feature"

  import_steps Test.Feature.Steps.Shared
  import_steps Test.Feature.Steps.File
end
