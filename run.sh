#!/bin/sh

set -e

cd ./shorten
mix deps.get
mix local.rebar --force
mix deps.compile

rm -f tmp/pids/server.pid
mix phx.server