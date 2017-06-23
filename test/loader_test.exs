defmodule Test.Weave.Loader do
  use ExUnit.Case

  test "It can merge Lists" do
    current_config = ["database.com", "6666"]

    assert ["username", "password", "database.com", "6666"] = Test.Weave.Loaders.Test.test_merge(current_config, ["username", "password"])
  end

  test "It can merge Keyword Lists" do
    current_config = [host: "www.database.com"]

    assert [host: "www.database.com", port: 6666] = Test.Weave.Loaders.Test.test_merge(current_config, [port: 6666])
  end

  test "It can merge Maps" do
    current_config = %{host: "www.database.com"}

    assert %{host: "www.database.com", port: 6666} = Test.Weave.Loaders.Test.test_merge(current_config, %{port: 6666})
  end

  test "It can merge binaries" do
    current_config = "www.database.com"

    assert "new.database.com" = Test.Weave.Loaders.Test.test_merge(current_config, "new.database.com")
  end

  test "It can sanitize key names to lower-case" do
    assert "lower_cased" = Test.Weave.Loaders.Test.test_sanitize("LOWER_CASED")
    assert "lower_cased" = Test.Weave.Loaders.Test.test_sanitize("lOWEr_CAsED")
  end

  test "It can detect :auto wiring configuration types" do
    assert :ok = Test.Weave.Loaders.Test.test_handle_configuration("my_app_password", ~s/{:auto, :my_app, :password, "password"}/)

    assert Application.get_env(:my_app, :password) == "password"
  end
end
