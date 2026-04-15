---
layout: default
title: Installing
nav_order: 3
---

# Installing

All releases are published to the Maven Central repository
(see [here](https://search.maven.org/search?q=io.github.queritylib)).

Install one of the modules in your project as follows (see [Available modules]({% link available-modules.md %})).

Maven:

```xml

<dependency>
  <groupId>io.github.queritylib</groupId>
  <artifactId>querity-spring-data-jpa</artifactId>
  <version>{{ site.querity_version }}</version>
</dependency>
```

Gradle:

```groovy
implementation "io.github.queritylib:querity-spring-data-jpa:{{ site.querity_version }}"
```

See [Releases](https://github.com/queritylib/querity/releases) to check the latest version and see the changelogs.

All the Spring-related modules are "Spring Boot starters": if you use Spring Boot you just need to add the dependency to your project and
start using it, no other configuration needed.

## Compatibility matrix

| Querity | Java | Spring Boot | Spring Framework | Spring Data | Hibernate | Jakarta Persistence | Jackson |
|---------|------|-------------|------------------|-------------|-----------|---------------------|---------|
| 4.x     | 17+  | 4.0.x       | 7.0.x            | 2025.1.x    | 7.x       | 3.2                 | 3.x     |
| 3.x     | 17+  | 3.4.x+      | 6.2.x            | 2024.1.x    | 6.6.x     | 3.1                 | 2.x     |
| 2.x     | 17+  | 3.0.x       | 6.0.x            | 2022.0.x    | 6.1.x     | 3.1                 | 2.x     |
| 1.x     | 8+   | 2.7.x       | 5.3.x            | 2021.2.x    | 5.6.x     | 2.2 (javax)         | 2.x     |

## Without Spring Boot autoconfiguration

You can use Querity without Spring Boot, but you need to configure the `Querity` bean in your Spring configuration.

Example with JPA:

```java
import io.github.queritylib.querity.api.Querity;

@Configuration
public class QuerityConfiguration {
  @Bean
  Querity querity(EntityManager entityManager) {
    return new QuerityJpaImpl(entityManager);
  }
}
```

You can also disable the autoconfiguration of the Spring Boot starter by adding the following property to your `application.properties`:

```properties
querity.autoconfigure.enabled=false
```

> This is useful if you want to import multiple Querity modules (e.g. JPA and Elasticsearch) and configure multiple Querity beans in your application.
