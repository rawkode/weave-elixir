defmodule Test.Weave.Loaders.Test do
  use Weave.Loader

  @moduledoc false

  def load_configuration() do
    :ok
  end

  def test_merge(current_config, new_config) do
    merge(current_config, new_config)
  end

  def test_sanitize(key) do
    sanitize(key)
  end
end
