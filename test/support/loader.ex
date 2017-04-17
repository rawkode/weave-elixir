defmodule Test.Weave.Loaders.Test do
  use Weave.Loader

  def load_configuration() do
    :ok
  end

  def test_merge(current_config, new_config) do
    merge(current_config, new_config)
  end
end
