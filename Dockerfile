FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /opt/app

COPY mix.* ./

CMD mix deps.get && mix phx.server
