defmodule Test.Weave.Handler do
  @moduledoc false

  def handle_configuration("multi", value) do
    [
      {:weave, :one, value},
      {:weave, :two, value}
    ]
  end

  def handle_configuration(key, value) do
    {:weave, String.to_atom(key), value}
  end
end
