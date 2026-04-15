---
layout: default
title: Sorting
parent: Features
nav_order: 2
---

# Sorting

Use `Querity.query().sort(...).build()` to build a query with sorting.

Use `Querity.sortBy` to build a sort criteria.

```
Query query = Querity.query()
    .sort(sortBy("lastName"), sortBy("birthDate", DESC))
    .build();
```
