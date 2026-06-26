# Letterboxd Trakt Sync

Script to sync your Letterboxd watched films, ratings and watchlist to your Trakt account.

> NOTE: For watched/rated films, diary entries are synced with full watch dates. Ratings without diary entries are also synced via the `sync_ratings` option. Sync is Letterboxd → Trakt only (no Trakt → Letterboxd).

## Config

- To obtain values for `trakt_client_id` and `trakt_client_secret`, [create a Trakt application](https://trakt.tv/oauth/applications) with the following values:
  - Name: letterboxd-trakt-sync
  - Redirect URI: `urn:ietf:wg:oauth:2.0:oob`
  - Enable the /scrobble permission.
- Leave the internal values as null, these will be populated by the script.

## Usage (Manual)

- Install the requirements: `pip install -r requirements.txt`
- Run the script: `python letterboxd_trakt/main.py`
- This will generate a template config at `config.yml`, you need to [fill in the values](#config).

## Setup (Docker)

### cli

```sh
docker run --rm \
    --name letterboxd-trakt-sync \
    -e RUN_ON_START=true \
    -v /<host_folder_config>:/config \
    ghcr.io/daveblx/letterboxd-trakt-sync:latest
```

### compose

```yml
services:
  letterboxd-trakt-sync:
    container_name: letterboxd-trakt-sync
    image: ghcr.io/daveblx/letterboxd-trakt-sync:latest
    environment:
      - RUN_ON_START=true
    volumes:
      - /<host_folder_config>:/config
```

#### Initial run

- On initial run a default config will be created in the `/config` directory. You then need to [fill in the values](#config).

- After you have filled out your config, restart the container.

- You will then need to view the docker logs to access the code required to authorise the Trakt application. (You will also need to do this whenever you add new accounts to your config). e.g.
  - `docker logs letterboxd-trakt-sync`
  - `> Your user code is: A84F9B0D, please navigate to https://trakt.tv/activate to authenticate`

### Optional environment variables

- `SCHEDULED`: runs on a schedule. default is `true` in docker, `false` otherwise.
  - `RUN_ON_START`: set to `true` to run the script immediately on container start.
  - `CRON_SCHEDULE`: sets the cron schedule for running the script (default: `"0 * * * *"` - every hour)

### Config options

| Option | Default | Description |
|---|---|---|
| `sync_diary` | `true` | Sync Letterboxd diary entries (watches + ratings) to Trakt |
| `sync_watchlist` | `true` | Sync Letterboxd watchlist to Trakt |
| `sync_ratings` | `true` | Sync all Letterboxd ratings to Trakt, including films rated without a diary entry |
