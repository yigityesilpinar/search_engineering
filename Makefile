.DEFAULT_GOAL := start

.PHONY: start
start:
	docker-compose -f docker/docker-compose-w1.yml up

.PHONY: stop
stop:
	docker-compose -f docker/docker-compose-w1.yml down

.PHONY: index
index:
	./index-data.sh

.PHONY: delete
delete:
	./delete-indexes.sh

.PHONY: count
count:
	./count-tracker.sh

.PHONY: track_index
track_index:
	tail -f logs/index.log