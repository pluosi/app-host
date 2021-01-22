#!/bin/bash
cd /app

RAILS_ENV=production

mkdir -p shared/tmp/pids
mkdir -p shared/log
mkdir -p shared/public/uploads

rm -rf tmp && ln -s /app/shared/tmp .
rm -rf log && ln -s /app/shared/log .

ln -sf /app/shared/public/uploads public/uploads

#build secret_key_base
secret_file="config/secrets.yml"
flag="SECRET_KEY_BASE"
existing=$(cat $secret_file | grep "$flag")
if [[ $existing != "" ]]; then
  secret_key_base=$(ruby -e "require 'securerandom';puts SecureRandom.hex(64)")
  secret_text=$(sed -e "s/$flag/$secret_key_base/" $secret_file)
  echo "$secret_text" > $secret_file
fi

rm db/production.sqlite3
if [[ ! -f /app/shared/production.sqlite3 ]]; then
  ./bin/bundle exec rake db:migrate
  mv db/production.sqlite3 /app/shared/production.sqlite3
fi

ln -sf /app/shared/production.sqlite3 db/production.sqlite3