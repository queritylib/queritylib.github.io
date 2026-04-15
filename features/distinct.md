---
layout: default
title: Distinct results
parent: Features
nav_order: 4
---

# Distinct results

Use `Querity.query().distinct(true).build()` to build a query with distinct results.

You should set this flag to `true` when you are filtering by some nested properties that may produce duplicate results in SQL databases.

```
Query query = Querity.query()
    .distinct(true)
    .filter(filterBy("orders.items.quantity", GREATER_THAN, 8))
    .pagination(1, 5)
    .build();
```

> The distinct flag is meaningless in NoSQL databases and will be ignored.
