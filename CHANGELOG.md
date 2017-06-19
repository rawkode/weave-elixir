# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.0] - 2017-06-19
### BREAKING CHANGE
- All "keys" are now lower-cased before being passed to a handler. This means environment variables, such as `MY_APP_PASSWORD` will require a handler of `handle_configuration("password")`, rather than the old `handle_configuration("PASSWORD")`

### Added
- "Handler Free" configuration. Setting the contents of your environment variable, or file, to "{:auto, :app, :key, value}" will not require a `handle_configuration/2` definition in your handler.
- Improved the documentation
- Added typespec's
- Cleaned up ebert warnings
