---
layout: default
title: Query Customizers (JPA)
parent: Features
nav_order: 10
---

# Query Customizers (JPA)

You can customize JPA queries with specific hints and optimizations using the `.customize()` method. This is useful for performance tuning.

## Fetch Join (Eager Loading)

Solve N+1 query problems by fetching associated entities eagerly:

```java
import io.github.queritylib.querity.jpa.JPAHints;

// Fetch associated entities eagerly to avoid N+1 queries
Query query = Querity.query()
    .filter(filterBy("status", EQUALS, "ACTIVE"))
    .customize(JPAHints.fetchJoin("orders", "orders.items")) // Supports nested paths
    .build();
List<Person> results = querity.findAll(Person.class, query);
```

## Named Entity Graphs

Use JPA entity graphs for fetch optimization:

```java
Query query = Querity.query()
    .customize(JPAHints.namedEntityGraph("Person.withOrders"))
    .build();
```

## Other Optimizations

```java
Query query = Querity.query()
    .customize(
        JPAHints.batchSize(50),      // Optimize JDBC fetch size
        JPAHints.timeout(5000),      // Query timeout in ms
        JPAHints.cacheable(true)     // Enable L2 Query Cache
    )
    .build();
```

> **Note:** Customizers are backend-specific. `JPAHints` will only be applied when using the JPA module and are safely ignored by other modules like MongoDB.
