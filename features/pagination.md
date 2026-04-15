---
layout: default
title: Pagination
parent: Features
nav_order: 3
---

# Pagination

Use `Querity.query().pagination(page, pageSize).build()` to build a query with pagination.

```
Query query = Querity.query()
    .pagination(1, 5)
    .build();
```
