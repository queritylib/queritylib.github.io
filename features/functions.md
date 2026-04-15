---
layout: default
title: Function Expressions
parent: Features
nav_order: 7
---

# Function Expressions

Querity supports SQL-like functions in filters, sorting, and projections. Use `prop()` for property references and `lit()` for literal values.

## Using functions in filters

```java
import static io.github.queritylib.querity.api.Querity.*;

// Filter by uppercase lastName
Query query = Querity.query()
    .filter(filterBy(upper(prop("lastName")), EQUALS, "SKYWALKER"))
    .build();

// Filter by string length
Query query = Querity.query()
    .filter(filterBy(length(prop("firstName")), GREATER_THAN, 5))
    .build();
```

## Using functions in sorting

```java
// Sort by string length
Query query = Querity.query()
    .sort(sortBy(length(prop("lastName")), DESC))
    .build();

// Sort by uppercase value
Query query = Querity.query()
    .sort(sortBy(upper(prop("firstName"))))
    .build();
```

## Using functions in projections

```java
// Select with function expressions
AdvancedQuery query = Querity.advancedQuery()
    .select(selectBy(
        prop("id"),
        upper(prop("lastName")).as("upperLastName"),
        concat(prop("firstName"), lit(" "), prop("lastName")).as("fullName"),
        length(prop("email")).as("emailLength")
    ))
    .build();
```

## Available functions

| Category | Functions |
|----------|-----------|
| Arithmetic | `abs()`, `sqrt()`, `mod()` |
| String | `concat()`, `substring()`, `trim()`, `ltrim()`, `rtrim()`, `lower()`, `upper()`, `length()`, `locate()` |
| Date/Time | `currentDate()`, `currentTime()`, `currentTimestamp()` |
| Conditional | `coalesce()`, `nullif()` |
| Aggregate | `count()`, `sum()`, `avg()`, `min()`, `max()` |

## Function arguments

Function arguments must be either property references or literals:
- `prop("fieldName")` - reference to an entity property (alias for `property()`)
- `lit(value)` - literal value (String, Number, or Boolean)

```java
// Combine functions
coalesce(prop("nickname"), lit("Anonymous"))
mod(prop("quantity"), lit(10))
concat(prop("firstName"), lit(" - "), prop("lastName"))

// Nested functions
upper(trim(prop("name")))  // UPPER(TRIM(name))
length(lower(prop("email")))  // LENGTH(LOWER(email))

// Nested properties (e.g., address.city)
upper(prop("address.city"))
coalesce(prop("contact.email"), prop("contact.phone"), lit("N/A"))
```

## Backend support for functions

> - **JPA**: Full support for all functions in filters, sorting, and projections
> - **MongoDB**: Functions supported in filters only (via `$expr`). Using functions in sort or select throws `UnsupportedOperationException`
> - **Elasticsearch**: Functions are **not supported**. Using functions throws `UnsupportedOperationException`

**Function support by implementation:**

| Function | JPA | MongoDB | Elasticsearch |
|----------|-----|---------|---------------|
| `abs()`, `sqrt()`, `mod()` | ✓ Filters, Sort, Select | ✓ Filters only | ✗ |
| `concat()`, `substring()`, `trim()`, `ltrim()`, `rtrim()` | ✓ Filters, Sort, Select | ✓ Filters only | ✗ |
| `lower()`, `upper()`, `length()`, `locate()` | ✓ Filters, Sort, Select | ✓ Filters only | ✗ |
| `currentDate()`, `currentTime()`, `currentTimestamp()` | ✓ Filters, Sort, Select | ✓ Filters only | ✗ |
| `coalesce()`, `nullif()` | ✓ Filters, Sort, Select | ✓ Filters only | ✗ |
| `count()`, `sum()`, `avg()`, `min()`, `max()` | ✓ Filters, Sort, Select | ✓ Filters only | ✗ |
