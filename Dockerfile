FROM elixir:latest

RUN apt-get update && apt-get install --yes inotify-tools
RUN mix local.hex --force
RUN mix archive.install hex phx_new --force

WORKDIR /app
RUN ls

EXPOSE 4000
CMD ["./run.sh"]
