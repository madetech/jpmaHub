# tgif-slack-app

## Prerequisites

* [Ruby](https://www.ruby-lang.org/en/)
* [PostgreSQL](https://www.postgresql.org/)
* Bundler (run `gem install bundler:2.1.4`)

## Create local postgres database

[Setup postgres tutorial](https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb) for Mac user

Once you have Postgres 11 installed with a user the role name postgres, which has permission to create a database, run the command

`make setup-db`

## Install
`bundle install`

## Run tests
`make test`

## Run server
`make run`