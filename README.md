# Weave

[![Hex.pm](https://img.shields.io/hexpm/v/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/l/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/dw/weave.svg)](https://hex.pm/packages/weave)
[![Build Status](https://travis-ci.org/GT8Online/weave.svg?branch=master)](https://travis-ci.org/GT8Online/weave)
[![Coverage Status](https://coveralls.io/repos/github/GT8Online/weave/badge.svg?branch=master)](https://coveralls.io/github/GT8Online/weave?branch=master)


## A JIT configuration loader for Elixir

### About

This library makes it possible to load configuration, especially secrets, from disk (Ala Docker Swarm / Kubernetes) on start-up.

### Installation

```elixir
def deps do
  [{:weave, "~> 1.0.0"}]
end
```

### Configuration

```elixir
config :weave,
  file_directory: "path/to/secrets" # Only needed when using the File loader
  environment_prefix: "MYAPP_"      # Only needed when using the Environment loader
  handler: Your.Handler             # Always needed :smile:
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

### Loading Configuration

You'll need to add the following to your `start` function, before to prepare your supervisor:

```elixir
Weave.Loaders.File.load_configuration()
Weave.Loaders.Environment.load_configuration()
```

### Logging

Weave **may** log sensitive information at the `debug` level, stick to `info` in production.

### Contributing

#### Running Tests with Docker

```shell
$ docker-compose run --rm elixir
```

#### Next Steps

- [x] Add tests for `merge/2`
- [x] Load configuration from environment variables
- [ ] Documentation
- [ ] Add `:loaders` to specify, through config, which loaders to run and provide a single entrypoint `Weave.load_configuration/0`
- [ ] Auto-wiring so a handler isn't needed. Contents of file would be `{:app, :key, :value}`

#### Thanks

Thanks for @sasa1977, @bitwalker and @OvermindDL1 for their advice on putting this together
