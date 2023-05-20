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
	docker-compose -f docker/docker-compose-w1.yml stop


.PHONY: week1-query
week1-query:
	python week1/query.py --query_file ${QUERY_FILE} --max_queries ${MAX_QUERIES}

.PHONY: week2
week2:
	docker-compose -f docker/docker-compose-w2.yml up --detach

.PHONY: stop-week2
stop-week2:
	docker-compose -f docker/docker-compose-w2.yml stop

.PHONY: start-week3
start-week3:
	docker-compose -f docker/docker-compose-w3.yml up --detach

.PHONY: stop-week3
stop-week3:
	docker-compose -f docker/docker-compose-w3.yml stop

.PHONY: start
start:
	docker-compose -f docker/docker-compose-w4.yml up --detach

.PHONY: stop
stop:
	docker-compose -f docker/docker-compose-w4.yml stop

.PHONY: down
down:
	docker-compose -f docker/docker-compose-w4.yml down --remove-orphans

.PHONY: build-week2-opensearch
build-week2-opensearch:
	docker build -f docker/Opensearch.Dockerfile -t week2-opensearch:latest .

.PHONY: start-monitoring
start-monitoring:
	docker-compose -f docker-grafana/monitoring.yml up --detach

.PHONY: stop-monitoring
stop-monitoring:
	docker-compose -f docker-grafana/monitoring.yml stop

.PHONY: down-monitoring
down-monitoring:
	docker-compose -f docker-grafana/monitoring.yml down --remove-orphans

 .PHONY: mapping
mapping:
	printf "\nUsing mapping file: ${MAPPING_FILE}\n"
	curl -k -X PUT -u admin:admin "${HOST}/bbuy_products" -H 'Content-Type: application/json' -d  @"${MAPPING_FILE}"

.PHONY: index
index: delete mapping
	python3 week4/index.py -o ${HOST} -s ${BBUY_DATA} --refresh_interval ${REFRESH_INTERVAL} --batch_size ${BATCH_SIZE} --workers ${WORKERS}


# Set up a cross-cluster replication
.PHONY: replication
replication:
	./setup-replication.sh -l ${LEADER_SEED_HOST} -f ${FOLLOWER_HOST} -i ${INDEX_NAME} -a ${REPLICATION_ALIAS}

.PHONY: stop-replication
stop-replication:
	curl -XPOST -k -H 'Content-Type: application/json' -u 'admin:admin' '${FOLLOWER_HOST}/_plugins/_replication/${INDEX_NAME}/_stop?pretty' -d '{}'

.PHONY: delete-replicated-index
delete-replicated-index:
	curl -k -X DELETE -u admin:admin  "${FOLLOWER_HOST}/${INDEX_NAME}?pretty"

.PHONY: replication-status
replication-status:
	curl -XGET -k -u 'admin:admin' '${FOLLOWER_HOST}/_plugins/_replication/${INDEX_NAME}/_status?pretty'

.PHONY: delete
delete:
	curl -k -X DELETE -u admin:admin  "${HOST}/${INDEX_NAME}?pretty"

.PHONY: count
count:
	./count-tracker.sh  -o ${HOST}

.PHONY: track
track:
	tail -f logs/index.log


.PHONY: query
query:
	python week4/query.py --query_file ${QUERY_FILE} --max_queries ${MAX_QUERIES} --workers ${QUERY_WORKERS} -o ${HOST}

.PHONY: query-replicate-index
query-replicate-index:
	python week4/query.py --query_file ${QUERY_FILE} --max_queries ${MAX_QUERIES} --workers ${QUERY_WORKERS} -o ${FOLLOWER_HOST}


.PHONY: create-snapshot-repository
create-snapshot-repository:
	curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' "${HOST}/_snapshot/${SNAPSHOT_REPOSITORY_NAME}?pretty" -d \
	'{ \
	  "type": "fs", \
	  "settings": { \
		"location": "/usr/share/opensearch/snapshots" \
	  } \
	}'

.PHONY: snapshot
snapshot:
	curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' "${HOST}/_snapshot/${SNAPSHOT_REPOSITORY_NAME}/${SNAPSHOT_NAME}?pretty"

.PHONY: get-snapshot
get-snapshot:
	curl -XGET -k -H 'Content-Type: application/json' -u 'admin:admin' "${HOST}/_snapshot/${SNAPSHOT_REPOSITORY_NAME}/${SNAPSHOT_NAME}?pretty"

.PHONY: restore-snapshot
restore-snapshot:
	curl -XPOST -k -H 'Content-Type: application/json' -u 'admin:admin' "${HOST}/_snapshot/${SNAPSHOT_REPOSITORY_NAME}/${SNAPSHOT_NAME}/_restore?pretty" -d \
	'{ \
	  "indices": "${INDEX_NAME}", \
	  "ignore_unavailable": true, \
	  "include_global_state": false, \
	  "include_aliases": false, \
	  "partial": false, \
	  "index_settings": { \
	     "index.block.read_only": false \
	  }, \
	  "ignore_index_settings": [ \
	    "index.refresh_interval" \
	  ] \
	}'