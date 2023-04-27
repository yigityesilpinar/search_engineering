# Week 1 Project

## Level 1

### Fields and Schema

Using **week1/bbuy_prmaoducts.json** and **only 5 fields**

```text
1275077 were indexed in 0.5439741527666532 minutes.  Total accumulated time spent in `bulk` indexing: 2.545389340035278 minutes
```

Using **week1/bbuy_products_no_map.json** and **only 5 fields**

```text
1275077 were indexed in 0.4373955118166729 minutes.  Total accumulated time spent in `bulk` indexing: 1.6941084216189968 minutes
```

Using **week1/bbuy_prmaoducts.json** and **all fields**

```text
1275077 were indexed in 1.7786700451334279 minutes.  Total accumulated time spent in `bulk` indexing: 5.728659874252601 minutes
```

Using **week1/bbuy_products_no_map.json** and **all fields**

```text
1275077 were indexed in 1.6864325152833772 minutes.  Total accumulated time spent in `bulk` indexing: 5.064607691901498 minutes
```

Using **week1/bbuy_prmaoducts.json** and **all fields** and

**refresh_interval** set to **-1**

```text
1275077 were indexed in 1.7704085312499955 minutes.  Total accumulated time spent in `bulk` indexing: 5.799076557173491 minutes
```

**refresh_interval** set to **1s**

```text
1275077 were indexed in 1.7824171354167144 minutes.  Total accumulated time spent in `bulk` indexing: 5.787701758272427 minutes
```

**refresh_interval** set to **60s**

```text
1275077 were indexed in 1.7319606166666441 minutes.  Total accumulated time spent in `bulk` indexing: 5.511831431552855 minutes
```

**batch_size** set to **400**

```text
1275077 were indexed in 1.7123986194499594 minutes.  Total accumulated time spent in `bulk` indexing: 5.340675873232006 minutes
```

**batch_size** set to **800**

```text
1275077 were indexed in 1.724886823616786 minutes.  Total accumulated time spent in `bulk` indexing: 5.259540913615395 minutes
```

**batch_size** set to **1600**

```text
1275077 were indexed in 1.7042924562500654 minutes.  Total accumulated time spent in `bulk` indexing: 5.106340252217584 minutes
```

**batch_size** set to **3200**

```text
1275077 were indexed in 1.7205106701500579 minutes.  Total accumulated time spent in `bulk` indexing: 5.0706786690161 minutes
```

**batch_size** set to **5000**

```text
1275077 were indexed in 1.7471747069333408 minutes.  Total accumulated time spent in `bulk` indexing: 5.235540663849921 minutes
```

Using **week1/bbuy_prmaoducts.json** and **all fields** and **refresh_interval** set to **60s** and **batch_size** set to **1600** 

**workers** set to **8**

```text
1275077 were indexed in 1.7042924562500654 minutes.  Total accumulated time spent in `bulk` indexing: 5.106340252217584 minutes
```

**workers** set to **16**

```text
1275077 were indexed in 1.693205220149927 minutes.  Total accumulated time spent in `bulk` indexing: 15.896656775477943 minutes
```

**workers** set to **32**

```text
1275077 were indexed in 2.0043314680668116 minutes.  Total accumulated time spent in `bulk` indexing: 47.440762228798846 minutes
```

**workers** set to **64**

```text
1275077 were indexed in 2.856647052083281 minutes.  Total accumulated time spent in `bulk` indexing: 139.22584377878107 minutes
```
