---
layout: default
title: Field-to-Field Comparison
parent: Features
nav_order: 6
---

# Field-to-Field Comparison

Use `filterByField` to compare two entity fields directly:

```java
// Find orders where quantity exceeds available stock
Query query = Querity.query()
    .filter(filterByField("quantity", GREATER_THAN, field("availableStock")))
    .build();

// Find employees whose salary exceeds their manager's salary
Query query = Querity.query()
    .filter(filterByField("salary", GREATER_THAN, field("manager.salary")))
    .build();
```

Use `Querity.field("propertyName")` to reference a field on the right-hand side of the comparison.

Supports all comparison operators: `EQUALS`, `NOT_EQUALS`, `GREATER_THAN`, `GREATER_THAN_EQUALS`, `LESSER_THAN`, `LESSER_THAN_EQUALS`.

> **Backend support:**
> - **JPA**: Full support
> - **MongoDB**: Full support
> - **Elasticsearch**: Not supported
