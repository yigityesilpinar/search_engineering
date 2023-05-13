

# Week 3 Project

## Level 1

### Q1: Which node was elected as cluster manager?
opensearch-node2

### Q2: After stopping the previous cluster manager, which node was elected the new cluster manager?
opensearch-node1

[opensearch-node1] node-left[{opensearch-node2}{hrnJ1H-OSZ-v9kweN0mMDA}{ODhBjCX2Rzm9VXpF1fhdIg}{172.20.0.2}{172.20.0.2:9300}{dimr}{shard_indexing_pressure_enabled=true} reason: disconnected], term: 4, version: 46, delta: removed {{opensearch-node2}{hrnJ1H-OSZ-v9kweN0mMDA}{ODhBjCX2Rzm9VXpF1fhdIg}{172.20.0.2}{172.20.0.2:9300}{dimr}{shard_indexing_pressure_enabled=true}}
[2023-05-13T14:43:57,627][INFO ][o.o.c.s.ClusterApplierService] [opensearch-node1] cluster-manager node changed {previous [], current [{opensearch-node1}{LYi4CiiVSQSscMTr4q5L-Q}{C1_4gwDYTaOif0_5bXx3ag}{172.20.0.3}{172.20.0.3:9300}{dimr}{shard_indexing_pressure_enabled=true}]}, term: 4, version: 45, reason: Publication{term=4, version=45}

### Q3: Did the cluster manager node change again? (was a different node elected as cluster manager when you started the node back up?)
No, it did not change again.

## Level 2

### Q4: How much faster was it to index the dataset with 0 replicas versus the previous time with 2 replica shards?
With "number_of_shards": 3, "number_of_replicas": 2
INFO:Done. 1275077 were indexed in 5.210835180566694 minutes.  Total accumulated time spent in `bulk` indexing: 67.57187932633363 minutes

With "number_of_shards": 3, "number_of_replicas": 0
INFO:Done. 1275077 were indexed in 2.274954776383432 minutes.  Total accumulated time spent in `bulk` indexing: 13.458576809365331 minutes

### Q5: Why was it faster?
Because there was no need to replicate the data to other nodes. When there are replicas, primary shard indexes the data first and forwards to each replica shard (in parallel for multiple replicas). 

### Q6: How long did it take to create the new replica shards?  This will be the difference in time between those two log messages.
43 seconds.
[2023-05-13T15:59:10,552][INFO ][o.o.c.m.MetadataUpdateSettingsService] [opensearch-node1] updating number_of_replicas to [2] for indices [bbuy_products]
[2023-05-13T15:59:53,845][INFO ][o.o.c.r.a.AllocationService] [opensearch-node1] Cluster health status changed from [YELLOW] to [GREEN] (reason: [shards started [[bbuy_products][2]]]).

### Q7: Those two messages were both logged by the cluster_manager.  Why do you think the cluster manager is the node that logs these actions (versus non-manager nodes)?
The cluster manager is responsible for coordinating actions like allocating new replica shards and populating those shards.


## Level 3

### Q8: Looking at the metrics dashboard, what queries/sec rate are you getting?
It seems to be around 300 queries/sec per node.

### Q9: How does that compare to the max queries/sec rate you saw in week 2?
Best of week 2 (When CPU & memory is increased (5 CPU, 8GB RAM, 4GB JVM heap, index.py -w 16 -b 500)) was 350 queries/sec. Considering that we have 3 nodes in the cluster, it seems to be 2.5 times better.