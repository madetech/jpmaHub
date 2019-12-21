#!/usr/bin/env ash

set -e

while ! psql $DATABASE_URL -c 'SELECT 1'; do
    echo 'Waiting for db'; sleep 3;
done

bundle exec rspec