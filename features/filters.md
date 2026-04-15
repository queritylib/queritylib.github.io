---
layout: default
title: Filters
parent: Features
nav_order: 1
---

# Filters

Use `Querity.query().filter(condition).build()` to build a query with filters.

You can build filters which contains **conditions**, and they can be simple or nested conditions.

## Conditions

### Simple conditions

Use `Querity.filterBy` to build a simple condition with a property name, an operator and a value (if needed by the
operator, e.g. IS_NULL does not need a value).

```
Query query = Querity.query()
    .filter(filterBy("lastName", EQUALS, "Skywalker"))
    .build();
```

Supports **nested properties** with dot notation, also with one-to-many/many-to-many relationships.

E.g. `address.city` (one-to-one), `visitedPlaces.country` (one-to-many).

#### Operators

* EQUALS
* NOT_EQUALS
* STARTS_WITH (case-insensitive where supported*)
* ENDS_WITH (case-insensitive where supported*)
* CONTAINS (case-insensitive where supported*)
* GREATER_THAN
* GREATER_THAN_EQUALS
* LESSER_THAN
* LESSER_THAN_EQUALS
* IS_NULL
* IS_NOT_NULL
* IN
* NOT_IN

> \* Operators STARTS_WITH, ENDS_WITH, CONTAINS are case-insensitive only if the underlying database supports case-insensitive matching and proper configurations are applied.
>
>    E.g. JPA supports case-insensitive matching by default,
> while Elasticsearch requires a specific configuration (see [Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-analyzers.html) and [Spring Data Elasticsearch Documentation](https://docs.spring.io/spring-data/elasticsearch/reference/elasticsearch/object-mapping.html#elasticsearch.mapping.meta-model.annotations)).

### AND conditions

Use `Querity.and` and add more conditions to wrap them in a logical AND.

```
Query query = Querity.query()
    .filter(
        and(
            filterBy("firstName", EQUALS, "Luke"),
            filterBy("lastName", EQUALS, "Skywalker")
        )
    ).build();
```

You can also nest more levels of complex conditions.

### OR conditions

Use `Querity.or` and add more conditions to wrap them in a logical OR.

```
Query query = Querity.query()
    .filter(
        or(
            filterBy("lastName", EQUALS, "Skywalker"),
            filterBy("lastName", EQUALS, "Kenobi")
        )
    ).build();
```

You can also nest more levels of complex conditions.

### NOT conditions

Use `Querity.not` and specify a condition to wrap it in a logical NOT.

You can wrap simple conditions:

```
Query query = Querity.query()
    .filter(not(filterBy("lastName", EQUALS, "Skywalker")))
    .build();
```

or complex conditions:

```
Query query = Querity.query()
    .filter(
        not(and(
            filterBy("firstName", EQUALS, "Luke"),
            filterBy("lastName", EQUALS, "Skywalker")
        ))
    ).build();
```

### Native conditions

Use `Querity.filterByNative` and specify a native condition to use a database-specific condition in your query.

This could be useful if you really want to add very complex query conditions that cannot be built with the Querity APIs.

> Native conditions are supported only with Java API, not REST.

Example with Spring Data JPA / Jakarta Persistence:

```
Specification<Person> specification = (root, cq, cb) -> cb.equal(root.get("lastName"), "Skywalker");
Query query = Querity.query()
    .filter(filterByNative(specification))
    .build();
```

> In the module implementing the Spring Data JPA support, the Spring Data JPA's `Specification` class is used.
>
> In the module implementing the Jakarta Persistence support, there is a class named `Specification` that does the same
> (since the base library doesn't provide anything similar).

Example with Spring Data MongoDB / Elasticsearch:

```
Criteria criteria = Criteria.where("lastName").is("Skywalker");
Query query = Querity.query()
    .filter(filterByNative(criteria))
    .build();
```
