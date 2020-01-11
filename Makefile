.PHONY: setup-db
setup-db:
	echo ">>>>> Creating DB"
	bundle exec rake db:create
	echo ">>>>> Migrating DB"
	bundle exec rake db:migrate
	echo ">>>>> Populating Test DB"
	bundle exec rake db:test:prepare

.PHONY: run
run:
	bundle exec rerun rackup

.PHONY: test
test:
	bundle exec rake spec
