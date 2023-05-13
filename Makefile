.DEFAULT_GOAL := start

# include≈ .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif


.PHONY: week1
week1:
	docker-compose -f docker/docker-compose-w2.yml up


.PHONY: stop-week1
stop-week1:
	docker-compose -f docker/docker-compose-w1.yml down


.PHONY: week1-query
week1-query:
	python week1/query.py --query_file ${QUERY_FILE} --max_queries ${MAX_QUERIES}

.PHONY: week2
week2:
	docker-compose -f docker/docker-compose-w2.yml up --detach

.PHONY: stop-week2
stop-week2:
	docker-compose -f docker/docker-compose-w2.yml stop

.PHONY: start
start:
	docker-compose -f docker/docker-compose-w3.yml up --detach

.PHONY: stop
stop:
	docker-compose -f docker/docker-compose-w3.yml stop

.PHONY: build-week2-opensearch
build-week2-opensearch:
	docker build -f docker/Opensearch.Dockerfile -t week2-opensearch:latest .

.PHONY: start-monitoring
start-monitoring:
	docker-compose -f docker-grafana/monitoring.yml up --detach

.PHONY: stop-monitoring
stop-monitoring:
	docker-compose -f docker-grafana/monitoring.yml stop

 .PHONY: mapping
mapping:
	printf "\nUsing mapping file: ${MAPPING_FILE}\n"
	curl -k -X PUT -u admin:admin "https://${HOST}:9200/bbuy_products" -H 'Content-Type: application/json' -d  @"${MAPPING_FILE}"

.PHONY: index
index: delete mapping
	python3 week2/index.py -s ${BBUY_DATA} --refresh_interval ${REFRESH_INTERVAL} --batch_size ${BATCH_SIZE} --workers ${WORKERS}

.PHONY: delete
delete:
	./delete-indexes.sh

.PHONY: count
count:
	./count-tracker.sh

.PHONY: track
track:
	tail -f logs/index.log


.PHONY: query
query:
	python week2/query.py --query_file ${QUERY_FILE} --max_queries ${MAX_QUERIES} --workers ${QUERY_WORKERS}