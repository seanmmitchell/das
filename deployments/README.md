## Compose Templates

Use Docker Compose v2. Run commands from the chosen template's `compose` directory.
Copy `.env.example` to `.env` and fill in the appropriate values before starting:

```sh
docker compose config --quiet
docker compose up -d
```

Each template has a distinct default project name. To run multiple instances of
one template, set a unique `COMPOSE_PROJECT_NAME` in each instance's `.env`, or
pass `-p my-instance` to **every** Compose command for that instance. Also change
any published host ports that would conflict; project names do not isolate ports.

### Existing deployments

Earlier versions defaulted to the project name `compose`. Changing the project
name also changes the named volumes selected by Compose, so an existing site may
appear empty even though its original data still exists.

Before updating an existing deployment, back up its database and persistent
files, record its project and volume names (`docker compose ls` and
`docker volume ls`), and use its existing project name for all subsequent commands.
For an existing project named `compose`, add `COMPOSE_PROJECT_NAME=compose` to its
`.env` or use `docker compose -p compose ...`. This preserves its existing volume
selection. Keep only that existing deployment on the legacy name; give new
deployments unique names. To move existing data to a new project name, back it up
and restore it into the new project's volumes before switching traffic.

## Troubleshooting

Inspect the configuration, container status, and recent logs first:

```sh
docker compose config --quiet
docker compose ps -a
docker compose logs --tail=100
```

To restart services, run `docker compose restart`. To recreate containers after
changing configuration while retaining their named volumes, run:

```sh
docker compose up -d --force-recreate
```

To stop and remove containers while retaining named volumes, use
`docker compose down`, then `docker compose up -d` when ready.

### Intentional data reset

`docker compose down --volumes` permanently deletes this project's named volumes,
including its database, WordPress files, and monitoring data where applicable.
Use this only when deliberately discarding the deployment's data, after verifying
the project name and taking any required backups. It is not a troubleshooting step.

## Validation

From the repository root, run `python3 tools/check_compose.py` with Python 3 and
Docker Compose installed. CI runs the same check using `.env.example` values. It
renders every template, verifies unique default project and volume names, rejects
fixed container names, and checks two project-name overrides per template. It does
not start containers or test service readiness.
