FROM elixir:1.10-alpine as build

ADD ./analyzer /elixir/analyzer
ADD ./file_collector /elixir/file_collector

WORKDIR /elixir/analyzer

RUN export MIX_ENV=prod && \
    rm -rf _build && \
    mix local.hex --force && \
    mix deps.get && \
    RELEASE_NODE=analyzer@analyzer mix release

WORKDIR /elixir/file_collector

RUN export MIX_ENV=prod && \
    rm -rf _build && \
    mix local.hex --force && \
    mix deps.get && \
    mix release


FROM erlang:23-alpine as stage

RUN apk add inotify-tools

COPY --from=build /elixir/analyzer/_build/prod/rel/analyzer /analyzer
COPY --from=build /elixir/file_collector/_build/prod/rel/file_collector /file_collector
