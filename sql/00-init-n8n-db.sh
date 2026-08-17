#!/bin/sh

set -eu

: "${N8N_DB_NAME:?N8N_DB_NAME is required}"
: "${N8N_DB_USER:?N8N_DB_USER is required}"
: "${N8N_DB_PASSWORD:?N8N_DB_PASSWORD is required}"

echo "Creating the dedicated n8n database and role..."

psql \
  -v ON_ERROR_STOP=1 \
  --username "$POSTGRES_USER" \
  --dbname "$POSTGRES_DB" \
  --set=n8n_db="$N8N_DB_NAME" \
  --set=n8n_user="$N8N_DB_USER" \
  --set=n8n_password="$N8N_DB_PASSWORD" <<'EOSQL'
CREATE ROLE :"n8n_user"
  LOGIN
  PASSWORD :'n8n_password'
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE;

CREATE DATABASE :"n8n_db"
  OWNER :"n8n_user";

REVOKE ALL
  ON DATABASE :"n8n_db"
  FROM PUBLIC;
EOSQL

echo "Dedicated n8n database and role created."
