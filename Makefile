.DEFAULT_GOAL := start

# include≈ .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: start
start:
	docker-compose -f docker/docker-compose-w1.yml up

.PHONY: stop
stop:
	docker-compose -f docker/docker-compose-w1.yml down

 .PHONY: mapping
mapping:
	printf "\nUsing mapping file: ${MAPPING_FILE}\n"
	curl -k -X PUT -u admin:admin "https://${HOST}:9200/bbuy_products" -H 'Content-Type: application/json' -d  @"${MAPPING_FILE}"

.PHONY: index
index: delete mapping
	python3 week1/index.py -s ${BBUY_DATA} --refresh_interval ${REFRESH_INTERVAL} --batch_size ${BATCH_SIZE} --workers ${WORKERS}

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
	python week1/query.py --query_file ${QUERY_FILE} --max_queries ${MAX_QUERIES}