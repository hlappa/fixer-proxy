# FixerProxy

This is done with Elixir + Phoenix framework. The framework itself is tear down from templating, DB etc. Just bare HTTP server running.

## Up and running

Following tools are required

- Docker
- Docker-compose

In order to run the application locally, make sure you fill in your Fixer.io API key to `.env`. After that you can execute:

```
$ docker-compose run
```

Now you have development environment up and running with code hot-reloading!

In case you add dependencies you can always rebuild the image:

```
$ docker-compose build

or

$ docker-compose run --build

or without cache

$ docker-compose build --no-cache
```
