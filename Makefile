clean:
	@docker-compose down -v

deps:
	@docker-compose run --rm elixir deps.get

test:
	@docker-compose run --rm elixir test

analyse:
	@docker-compose run --rm -e MIX_ENV=dev elixir dialyzer

.PHONY: test deps
