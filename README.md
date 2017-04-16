# Weave

## A JIT configuration loader for Elixir

### About

This library makes it possible to load configuration, especially secrets, from disk (Ala Docker Swarm / Kubernetes) on start-up.

### Installation

```elixir
def deps do
  [{:weave, "~> 0.0.1"}]
end
```

### Configuration

```elixir
config :weave,
  file_directory: "path/to/secrets"
  handler: Your.Handler
```

### Handler

Your handler should be prepared to handle the files, based on their name, within your `file_directory`.

`handle_configuration/2` should return a tuple with the `:app` to set the key value pair on.

Weave will handle merging, so try not to worry about that :smile:

```elixir
defmodule Your.Handler do
  def handle_configuration("some_file_name", value) do
    {:app, :key, value}
  end
end
```

### Contributing

#### Running Tests with Docker

```shell
$ docker-compose run --rm elixir
```

#### Next Steps

- Add tests for `merge/2`
- Load configuration from environment variables
- Auto-wiring so a handler isn't needed. Contents of file would be `{:app, :key, :value}`
