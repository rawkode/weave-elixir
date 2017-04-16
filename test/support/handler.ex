defmodule Test.Weave.Handler do
  def handle_configuration("database_host", database_host) do
    {:weave, :database_host, database_host}
  end

  def handle_configuration("database_password", database_password) do
    {:weave, :database_password, database_password}
  end
end
