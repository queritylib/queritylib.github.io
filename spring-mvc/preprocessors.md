---
layout: default
title: Support for DTO layer
parent: Spring MVC and REST APIs
nav_order: 2
---

# Support for DTO layer

You may not want to expose database entities to the clients of your REST APIs.

If you implemented a DTO layer, with DTO objects mapping properties from your entities, the queries which would come to your REST APIs will have the DTO property names, not the entity ones. This is a problem, because some queries would not work, looking for non-existing properties on the entities.

> Note: it would work without any help only if properties in the DTO have the same name and structure of the properties in the entity

Querity has a "preprocessing layer" which you can use to map the DTO property names in your Query to the entity property names.

## Preprocessors

Use the `@WithPreprocessor("beanName")` annotation to annotate `Query` or `Condition` parameters in your Spring RestControllers.

The `beanName` argument must refer to an existing Spring bean which implements `QueryPreprocessor`.

When entering your controller method, the `Query` or `Condition` object would already be preprocessed.

### PropertyNameMappingPreprocessor

`PropertyNameMappingPreprocessor` is a `QueryProcessor` abstraction to convert property names.

Querity already has a simple mapper, `SimplePropertyNameMapper`, which simply does a property name conversion by looking into a Map you must provide.

To use `PropertyNameMappingPreprocessor` with `SimplePropertyNameMapper`, instantiate a bean into your Spring configuration:

```java
@SpringBootApplication
public class MyApplication {
  public static void main(String[] args) {
    SpringApplication.run(MyApplication.class, args);
  }

  @Bean
  public QueryPreprocessor preprocessor1() {
    return new PropertyNameMappingPreprocessor(
        SimplePropertyNameMapper.builder()
            .recursive(true) // default is true
            .mapping("prop1", "prop2") // customize your mappings here
            .build());
  }
}
```

and use it to annotate the parameter in your RestController:

```java
@RestController
public class MyRestController {

  @Autowired
  MyService service;

  @GetMapping(value = "/people", produces = MediaType.APPLICATION_JSON_VALUE)
  Result<Person> getPeople(@RequestParam(required = false) @WithPreprocessor("preprocessor1") Query q) {
    return service.getPeople(q);
  }
}
```

The mappings in `SimplePropertyNameMapper` are resolved recursively by default.

So if you mapped `prop1` to `prop2`, then all the fields nested in `prop1` will be automatically mapped to equal-named fields under `prop2`.

You can switch off the recursive mapping by setting the `recursive` flag to `false` in the builder.
