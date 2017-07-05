defmodule Weave do
  def configure() do
    Application.get_env(:weave, :loaders)
    |> Enum.map(fn(loader) ->
      loader.load_configuration()
    end)
  end
end
