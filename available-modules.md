---
layout: default
title: Available modules
nav_order: 5
---

# Available modules

Currently, Querity supports the following technologies with its modules:

> The datasource configuration is not managed by Querity and is delegated to the underlying application.

## querity-spring-data-jpa

Supports [Spring Data JPA](https://spring.io/projects/spring-data-jpa) and any SQL database with a compatible JDBC driver.

## querity-jpa

Supports plain [Jakarta Persistence API](https://jakarta.ee/specifications/persistence/) and any SQL database with a compatible JDBC driver.

This module is not Spring-specific, so it's not a Spring Boot starter: you will need to apply all the configurations manually.

You basically need to instantiate a `QuerityJpaImpl` object and pass it the JPA `EntityManager` you want to use.

## querity-spring-data-mongodb

Supports [Spring Data MongoDB](https://spring.io/projects/spring-data-mongodb).

## querity-spring-data-elasticsearch

Supports [Spring Data Elasticsearch](https://spring.io/projects/spring-data-elasticsearch).

> Remember to map the fields you want to query as "keyword" in your Elasticsearch index.

## querity-spring-web

Supports JSON serialization and deserialization of Querity objects in [Spring Web MVC](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html).

With this module, you can pass a JSON `Query` or `Condition` object as request param in your Spring `@RestController` and it will be automatically deserialized into a Querity object.

For example, your API calls will look like this:

```
curl 'http://localhost:8080/people?q={"filter":{"and":[{"propertyName":"lastName","operator":"EQUALS","value":"Skywalker"},{"propertyName":"lastName","operator":"EQUALS","value":"Luke"}]}}'
```

This is an alternative approach to the one provided by the module `querity-parser`.

See [Spring MVC and REST APIs]({% link spring-mvc.md %}) for more details.

## querity-parser

Enables the parsing of Querity objects from a **simple textual query language**.

For example, your API calls will look like this:

```
curl 'http://localhost:8080/people?q=and(lastName="Skywalker",firstName="Luke")'
```

This is an alternative approach to the one provided by the module `querity-spring-web`.

See [Query language]({% link spring-mvc/query-language.md %}) for more details.
