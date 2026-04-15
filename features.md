---
layout: default
title: Features
nav_order: 7
---

# Features

Use the static method `Querity.query().build()` to build an empty query (see the following chapters to build a more
complex query).

You can `@Autowire` the `Querity` service to run queries against the database configured in your application.

Having the `Querity` service, you can use the following instance methods:

* `Querity.findAll(entityClass, query)` to run the query and retrieve the results;
* `Querity.count(entityClass, condition)` to just count the elements filtered by the condition.
