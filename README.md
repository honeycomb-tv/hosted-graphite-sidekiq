[![Circle CI](https://circleci.com/gh/honeycomb-tv/hosted-graphite-sidekiq.svg?style=shield)](https://circleci.com/gh/honeycomb-tv/hosted-graphite-sidekiq)

# Hosted Graphite Sidekiq

A tiny background process that collects Sidekiq queue stats and reports them to HostedGraphite.


## Purpose

The main reason for using this solution (instead of doing this on an enqueue/perform callback) is trying to avoid race conditions.
Especially when a lot of jobs are enqueued asynchronously there's no guarantee that they will get reported in sequence. This can, of course
be solved by using a mutex, but it might impact the performance.

This solution on the other hand doesn't have those problems because it simply takes a snapshot of the queue lengths at a given time.


## Running

### Locally

In order to run this on a local machine you need to create `.env` file with all the settings (use `.env.example` as an example) and then run:

```bash
$ bin/run
```

### On the server

You might wanna consider using environment variables when deploying this to the server, allowing for easier configuration using your deployment tool of choice.


## Options

Here is the list of options you can configure:

- `HGS_ENV` — execution environment (development, test, production, etc.). Defaults to `developemnt`. HostedGraphite is disabled for `development` and `test` environments.
- `HGS_INTERVAL` — specifies an interval in seconds at which stats are collected. Defaults to 15.
- `HGS_REDIS_URL` — connection endpoint for your redis server. Must be prefixed with `redis://`. Defaults to `redis://localhost:6379`
- `HGS_HOSTED_GRAPHITE_API_KEY` — HostedGraphite API key for sending metrics.
