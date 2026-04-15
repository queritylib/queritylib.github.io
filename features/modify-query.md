---
layout: default
title: Modify an existing Query
parent: Features
nav_order: 11
---

# Modify an existing Query

Query objects are immutable, so you can't modify them directly (there are no "setters").

You can build a new query by copying the existing one and changing the parts you need.

Use `Query.toBuilder()` to copy an existing Query into a new QueryBuilder, then you can make changes before calling `build()`.

```
Query query = originalQuery.toBuilder()
    .sort(sortBy("lastName"))
    .build();
```
