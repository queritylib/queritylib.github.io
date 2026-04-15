---
layout: default
title: Projections (Select)
parent: Features
nav_order: 5
---

# Projections (Select)

Use `Querity.advancedQuery()` with `selectBy` to retrieve only specific fields instead of full entities.

```java
AdvancedQuery query = Querity.advancedQuery()
    .select(selectBy("firstName", "lastName", "address.city"))
    .filter(filterBy("lastName", EQUALS, "Skywalker"))
    .build();
List<Map<String, Object>> results = querity.findAllProjected(Person.class, query);
// Each map contains only: {firstName: "...", lastName: "...", city: "..."}
```

Supports **nested properties** with dot notation (e.g., `address.city`).

## Query vs AdvancedQuery

Querity provides two query types:

* **`Query`** - For simple entity queries. Use with `findAll()` to retrieve full entities.
* **`AdvancedQuery`** - For projection queries with `selectBy`, `groupBy`, `having`. Use with `findAllProjected()` to retrieve `Map<String, Object>` results.

```java
// Simple entity query
Query query = Querity.query()
    .filter(filterBy("lastName", EQUALS, "Skywalker"))
    .build();
List<Person> entities = querity.findAll(Person.class, query);

// Projection query
AdvancedQuery advQuery = Querity.advancedQuery()
    .select(selectBy("firstName", "lastName"))
    .filter(filterBy("lastName", EQUALS, "Skywalker"))
    .build();
List<Map<String, Object>> projections = querity.findAllProjected(Person.class, advQuery);
```

## Native select expressions (JPA only)

For advanced use cases, JPA modules support native expressions using `CriteriaBuilder`:

```java
// Select concatenated full name using native expression
SelectionSpecification<Person> fullNameSpec = AliasedSelectionSpecification.of(
    (root, cb) -> cb.concat(cb.concat(root.get("firstName"), " "), root.get("lastName")),
    "fullName"
);
AdvancedQuery query = Querity.advancedQuery()
    .select(selectByNative(fullNameSpec))
    .build();
List<Map<String, Object>> results = querity.findAllProjected(Person.class, query);
// Each map contains: {fullName: "Luke Skywalker"}
```

> Native select expressions are only available for JPA.
