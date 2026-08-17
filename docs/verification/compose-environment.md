# Local Compose Environment Verification

## Container Images

- n8n image: docker.n8n.io/n8nio/n8n:2.34.6
- PostgreSQL image: postgres:18.6-alpine3.24
- Mailpit image: axllent/mailpit:v1.30.7

## Runtime Verification

- n8n runtime version: 2.34.6
- PostgreSQL runtime version: 18.6
- n8n readiness status: HTTP 200
- Mailpit readiness status: HTTP 200

## Database Verification

- n8n database created: PASS
- n8n database table count: 125
- Dedicated database role n8n_app created: PASS
- n8n_app is not a superuser: PASS
- n8n_app cannot create roles: PASS
- n8n_app cannot create databases: PASS

## Security Configuration

- n8n is bound to 127.0.0.1:5678.
- Mailpit Web UI is bound to 127.0.0.1:8025.
- Mailpit SMTP port 1025 is available only inside the Docker network.
- PostgreSQL port 5432 is not published to the host.
- n8n uses a dedicated non-superuser PostgreSQL role.
- Secrets are stored in the Git-ignored .env file.
- Persistent data is stored in Docker named volumes.

## Persistence Verification

- docker compose down removed containers and the Compose network: PASS
- PostgreSQL named volume remained after container removal: PASS
- n8n named volume remained after container removal: PASS
- Mailpit named volume remained after container removal: PASS
- Containers were recreated successfully: PASS
- n8n owner account remained after container recreation: PASS
- n8n readiness after recreation: HTTP 200

## Result

Local Compose stack verification: PASS

- Verified at: 2026-08-15T18:10:01+09:00
