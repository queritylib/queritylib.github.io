---
layout: default
title: Quick start
nav_order: 6
---

# Quick start

In your Spring Boot project, add the dependency as shown in [Installing]({% link installing.md %}) and create a Spring service as
follows:

```java
import static io.github.queritylib.querity.api.Querity.*;
import static io.github.queritylib.querity.api.Operator.*;
import static io.github.queritylib.querity.api.Sort.Direction.*;

@Service
public class MyService {

  @Autowired
  Querity querity;

  public Result<Person> getPeople() {
    Query query = Querity.query()
        .filter(
            not(and(
                filterBy("lastName", EQUALS, "Skywalker"),
                filterBy("firstName", EQUALS, "Luke")
            ))
        )
        .sort(sortBy("lastName"), sortBy("birthDate", DESC))
        .pagination(1, 10)
        .build();
    List<Person> items = querity.findAll(Person.class, query);
    Long totalCount = querity.count(Person.class, query.getFilter());
    return new Result<>(items, totalCount);
  }

  record Result<T>(List<T> items, Long totalCount) {
  }
}
```

In the above example, the `findAll` method returns the first of n pages with max 10 elements of all people NOT named
Luke Skywalker, sorted by last name and then birthdate descending.<br />
The `count` method returns the total filtered items count excluding pagination (the record keyword is implemented from
Java 14).

> Notice the static imports to improve the readability.
