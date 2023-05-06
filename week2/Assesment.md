# Week 2 Project

## Level 1

### How long did it take to index the 1.2M product data set? What docs/sec indexing rate did you see?
With the default configuration (1 CPU, 2GB RAM, 1GB JVM heap, index.py -w 16 -b 500), it took 4.5 minutes. The indexing rate was 5.64 K/sec max and 3.72 K/ sec average.

### Notice that the Index size rose (roughly doubled) while the content was being indexed, peaked, then ~ 5 minutes after indexing stopped, the index size dropped down substantially. Why did it drop back down? (What did OpenSearch do here?)
When re-indexing without deleting the existing content, OpenSearch did not go through the hustle of replacing the documents in-place. It instead created a separate Lucene segment and do the cleanup for the stale docs afterwards.

### Looking at the metrics dashboard, what queries/sec rate are you getting?
With the default configuration (1 CPU, 2GB RAM, 1GB JVM heap, query -w 4 -m 25000), rate was around 105 queries/sec

### What resource(s) appear to be the constraining factor?
CPU was bound to 100%, memory usage was also around 2GB and queue depth during indexing (refresh: 4) and querying (search: 2)

## Level 2

### As you increased CPU and memory in your L2 tests, what seemed to be the constraining factor limiting indexing rate?
When only CPU setting is increased (5 CPU, 2GB RAM, 1GB JVM heap, index.py -w 16 -b 500), it took 1.8 minutes. The indexing rate was 12 K/sec max and 6.2 K/ sec average. CPU usage averaged %70 and max was 87%.
Memory usage was the constraining factor at 2GB. 

### As you increased memory in your L2 tests, what seemed to be the constraining factor limiting indexing rate? What was the constraining factor for querying rate?
When memory is increased (1 CPU, 8GB RAM, 4GB JVM heap, index.py -w 16 -b 500), indexing took 3.6 minutes. The indexing rate was 7 K/sec max and 4.3 K/ sec average. CPU was the constraining factor averaged %98.
Memory usage was between 4.5GB - 6GB.

When querying (query -w 4 -m 25000), rate was around 128 queries/sec. CPU was the constraining factor averaged %89. Queue depth (search) was at 2.
Memory usage was between 4.5GB - 6GB.

### Combined
When CPU & memory is increased (5 CPU, 8GB RAM, 4GB JVM heap, index.py -w 16 -b 500), indexing took 1.7 minutes. The indexing rate was 8.5 K/sec max and 13 K/ sec average. CPU usage averaged %50 and max was 94%.
Memory usage was between 4.7B - 7GB.

When querying (query -w 4 -m 25000), rate was around 350 queries/sec. CPU usage averaged %60 and max was %75. Queue dept was at 0.
Memory usage was between 5GB - 7GB.


## Level 3

### What is the impact on your query throughput (QPS) and indexing throughput (docs/sec)?
When CPU & memory is increased (5 CPU, 8GB RAM, 4GB JVM heap, index.py -w 16 -b 500), indexing & querying simultaneously:

The indexing rate was 5.6 K/sec max and 8.4 K/ sec average. The query rate was around 50 queries/sec. CPU usage averaged %80 and max was 100%. Memory usage was 7GB-8GB.

## Level 4

### Can you break the system?
With a bad setup (1 CPU, 512M RAM, 256M JVM heap and UseSerialGC, index.py -w 16 -b 5000, refresh interval 1s), indexing failed around 600K docs. The indexing rate was 2.8 K/sec max and 2.3 K/ sec average. CPU averaged at %96. Memory usage was 511MB.
JVM Heap was averaged at %84.

Many status:429 errors were observed during indexing. Container exited with "java.lang.OutOfMemoryError: Java heap space".