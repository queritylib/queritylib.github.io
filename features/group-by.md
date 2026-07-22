---
layout: default
title: GROUP BY and HAVING
parent: Features
nav_order: 8
---

# GROUP BY and HAVING

Querity supports GROUP BY and HAVING clauses for aggregate queries. Use `advancedQuery()` with `groupBy` to group results and `having` to filter groups.

## Basic GROUP BY

```java
import static io.github.queritylib.querity.api.Querity.*;

// Group by single property
AdvancedQuery query = Querity.advancedQuery()
    .select(selectBy(
        prop("category"),
        count(prop("id")).as("itemCount"),
        sum(prop("amount")).as("totalAmount")
    ))
    .groupBy("category")
    .build();
List<Map<String, Object>> results = querity.findAllProjected(Order.class, query);
// Returns: [{category: "Electronics", itemCount: 42, totalAmount: 15000}, ...]
```

## Group by multiple properties

```java
AdvancedQuery query = Querity.advancedQuery()
    .select(selectBy(
        prop("category"),
        prop("region"),
        avg(prop("price")).as("avgPrice")
    ))
    .groupBy("category", "region")
    .build();
```

## Group by with HAVING clause

```java
AdvancedQuery query = Querity.advancedQuery()
    .select(selectBy(
        prop("category"),
        sum(prop("amount")).as("total")
    ))
    .groupBy("category")
    .having(filterBy(sum(prop("amount")), GREATER_THAN, 1000))
    .build();
// Returns only categories with total amount > 1000
```

## Group by with function expressions

```java
// Group by function result (e.g., group by uppercase category)
AdvancedQuery query = Querity.advancedQuery()
    .select(selectBy(
        upper(prop("category")).as("upperCategory"),
        count(prop("id")).as("orderCount")
    ))
    .groupBy(upper(prop("category")))
    .build();
```

## Native GROUP BY expressions (JPA only)

For groupings the querity model cannot express (e.g. a JSON extraction over a `jsonb` column),
use `groupByNative` with a `GroupBySpecification` — the deferred `(Root, CriteriaBuilder) -> Expression`
counterpart of the native select and native sort specifications.

Because the aggregate must be computed per group, pair it with native selections
(`selectByNative`) so the whole query is native:

```java
import static io.github.queritylib.querity.api.Querity.*;

SelectionSpecification<MyEntity> categorySelection = AliasedSelectionSpecification.of(
    (root, cb) -> cb.function("jsonb_extract_path_text", String.class,
        root.get("attributes"), cb.literal("category")),
    "category");
SelectionSpecification<MyEntity> totalSelection = AliasedSelectionSpecification.of(
    (root, cb) -> cb.count(root.get("id")), "total");
GroupBySpecification<MyEntity> categoryGrouping =
    (root, cb) -> cb.function("jsonb_extract_path_text", String.class,
        root.get("attributes"), cb.literal("category"));

AdvancedQuery query = Querity.advancedQuery()
    .select(selectByNative(categorySelection, totalSelection))
    .groupBy(groupByNative(categoryGrouping))
    .build();
List<Map<String, Object>> results = querity.findAllProjected(MyEntity.class, query);
```

`groupByNative` accepts one or more specifications, mirroring `selectByNative` and `sortByNative`.

> Native GROUP BY expressions are only available for JPA.

> **Backend support:**
> - **JPA**: Full support for GROUP BY and HAVING
> - **MongoDB**: Not yet supported
> - **Elasticsearch**: Not supported
