---
layout: default
title: Spring MVC and REST APIs
nav_order: 8
---

# Support for Spring MVC and REST APIs

Querity objects need some configuration to be correctly deserialized when they are received by a
Spring `@RestController` as a JSON payload.

This includes:

* registering property editors in Spring MVC to recognize the `Querity` and `Condition` objects as valid request parameters,
* configuring the Jackson module `QuerityModule` to correctly deserialize the Querity objects from JSON,
* configuring the aspect `QuerityPreprocessorAspect` to use the preprocessors in the Spring controllers (see [Preprocessors]({% link spring-mvc/preprocessors.md %}) below).

These configurations are automatically done by importing the `querity-spring-web` module (see [Installing]({% link installing.md %})).

> You can disable the autoconfiguration of the Spring Boot starter by adding the following property to your `application.properties`:
>
> `querity.web.autoconfigure.enabled=false`
>
> Then you will have to apply the needed configurations manually.

After that, you'll be able to use a `Query` or `Condition` as a controller parameter and build REST APIs like this:

```java
import io.github.queritylib.querity.api.Query;

@RestController
public class MyRestController {

  @Autowired
  MyService service;

  @GetMapping(value = "/people", produces = MediaType.APPLICATION_JSON_VALUE)
  Result<Person> getPeople(@RequestParam(required = false) Query q) {
    return service.getPeople(q);
  }
}
```

Then the above REST API could be invoked like this:

```bash
curl 'http://localhost:8080/people?q={"filter":{"and":[{"propertyName":"lastName","operator":"EQUALS","value":"Skywalker"},{"propertyName":"lastName","operator":"EQUALS","value":"Luke"}]}}'
```
