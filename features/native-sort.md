---
layout: default
title: Native Sort Expressions
parent: Features
nav_order: 9
---

# Native Sort Expressions

Use `sortByNative` to sort by database-specific expressions.

## JPA native sort

```java
// Sort by length of lastName using CriteriaBuilder
OrderSpecification<Person> orderSpec = (root, cb) -> cb.asc(cb.length(root.get("lastName")));
Query query = Querity.query()
    .sort(sortByNative(orderSpec))
    .build();
List<Person> results = querity.findAll(Person.class, query);
```

## MongoDB native sort

```java
// Sort using Spring Data MongoDB's Order
org.springframework.data.domain.Sort.Order order = Sort.Order.asc("lastName");
Query query = Querity.query()
    .sort(sortByNative(order))
    .build();
```
