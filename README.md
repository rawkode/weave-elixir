# Weave

[![Hex.pm](https://img.shields.io/hexpm/v/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/l/weave.svg)](https://hex.pm/packages/weave)
[![Hex.pm](https://img.shields.io/hexpm/dw/weave.svg)](https://hex.pm/packages/weave)
[![Build Status](https://travis-ci.org/GT8Online/weave.svg?branch=master)](https://travis-ci.org/GT8Online/weave)
[![codecov](https://codecov.io/gh/GT8Online/weave/branch/master/graph/badge.svg)](https://codecov.io/gh/GT8Online/weave)

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

Your handler is responsible for taking these environment variables, and/or files, and injecting their values into configuration.

`handle_configuration/2` should return a tuple with the `:app` to set the key value pair on.

Weave will handle merging, so try not to worry about that :smile:

#### Example

Lets assume:

* We are using the environment and file loaders
* We have the `environment_prefix` configured as `MY_APP_`
* We have an environment variable called `MY_APP_NAME`
* We have a file in configured secrets directory called `db_password`

Before being passed to your handler:

* All file-names and environment variables are lower-cased
* Environment variables have the prefix stripped

```elixir
defmodule Your.Handler do
  def handle_configuration("name", value) do
    {:app, :name, value}
  end

  def handle_configuration("db_password", value) do
    {:app, :password, value}
  end
end
```

### Loading Configuration

You'll need to add the following to your `start` function, before you prepare your supervisor:

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
- [x] Documentation
