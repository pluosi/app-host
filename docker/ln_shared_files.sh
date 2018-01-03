#!/bin/bash
cd /app

mkdir -p shared/config
mkdir -p shared/tmp/pids
mkdir -p shared/log
mkdir -p shared/public/uploads

rm -rf tmp && ln -s /app/shared/tmp .
rm -rf log && ln -s /app/shared/log .

ln -sf /app/shared/public/uploads public/uploads

if [[ -f /app/shared/config/settings.local.yml ]]; then
  ln -sf /app/shared/config/settings.local.yml config/settings.local.yml
else
  mv config/settings.local.yml shared/config/settings.local.yml && ln -s /app/shared/config/settings.local.yml config/settings.local.yml
fi

if [[ ! -L db/production.sqlite3 ]]; then
  if [[ -f db/production.sqlite3 ]]; then
    mv db/production.sqlite3 shared/production.sqlite3 && ln -s /app/shared/production.sqlite3 db/production.sqlite3
  fi
else
  ln -sf /app/shared/production.sqlite3 db/production.sqlite3
fi
