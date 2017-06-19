defmodule Test.Feature.Loaders.File do
  use Cabbage.Feature, file: "loaders/file.feature"

  defgiven ~r/^I have configured weave to load configuration from "(?<file_directory>[^"]+)"$/, %{file_directory: file_directory}, _state do
    Application.put_env(:weave, :file_directory, file_directory)
    {:ok, %{file_directory: file_directory}}
  end

  defand ~r/^I have provided the configuration handler$/, _vars, state do
    Application.put_env(:weave, :handler, Test.Weave.Handler)
    {:ok, state}
  end

  defand ~r/^the directory exists$/, _vars, state = %{file_directory: file_directory} do
    File.mkdir_p(file_directory)
    {:ok, state}
  end

  defand ~r/^the following files exist there$/, %{table: files}, state = %{file_directory: file_directory} do
    Enum.each(files, fn(%{file_name: file_name, contents: contents}) ->
      File.write!("#{file_directory}/#{file_name}", contents)
    end)
    {:ok, Map.merge(state, %{expected_configuration: files})}
  end

  defwhen ~r/^I run the Weave file loader$/, _vars, state do
    Weave.Loaders.File.load_configuration()

    {:ok, state}
  end

  defthen ~r/^my application should be configured$/, _vars, %{file_directory: file_directory, expected_configuration: expected_configuration} do
    File.rm_rf(file_directory)

    Enum.each(expected_configuration, fn(%{file_name: key, contents: value}) ->
      assert Application.get_env(:weave, String.to_atom(key)) == value
    end)
    {:ok, %{}}
  end
end
