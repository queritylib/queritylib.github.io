---
layout: default
title: Query language
parent: Spring MVC and REST APIs
nav_order: 1
---

# Query language

The `querity-parser` module provides a simple query language to build a `Query` object,
useful when you need the user to write and understand the query.

It is an alternative approach to the one provided by the module `querity-spring-web`, which parses JSON.

To enable the query language, import the `querity-parser` module (see [Installing]({% link installing.md %})).

The following snippet rewrites the previous example using the support for the query language:

```java
import io.github.queritylib.querity.api.Query;
import io.github.queritylib.querity.parser.QuerityParser;

@RestController
public class MyRestController {

  @Autowired
  MyService service;

  @GetMapping(value = "/people", produces = MediaType.APPLICATION_JSON_VALUE)
  Result<Person> getPeople(@RequestParam(required = false) String q) {
    Query query = QuerityParser.parseQuery(q);
    return service.getPeople(query);
  }
}
```

Then the above REST API could be invoked like this:

```bash
curl 'http://localhost:8080/people?q=and(lastName="Skywalker",firstName="Luke")'
```

_Much simpler than JSON, isn't it?_

## Query language syntax

The query language supports the following grammar (ANTLR v4 format):

```
DISTINCT    : 'distinct';
WHERE       : 'where';
AND         : 'and';
OR          : 'or';
NOT         : 'not';
SORT        : 'sort by';
ASC         : 'asc';
DESC        : 'desc';
PAGINATION  : 'page';
SELECT      : 'select';
GROUP_BY    : 'group by';
HAVING      : 'having';
AS          : 'as';
NEQ         : '!=';
LTE         : '<=';
GTE         : '>=';
EQ          : '=';
LT          : '<';
GT          : '>';
STARTS_WITH : 'starts with';
ENDS_WITH   : 'ends with';
CONTAINS    : 'contains';
IS_NULL     : 'is null';
IS_NOT_NULL : 'is not null';
IN          : 'in';
NOT_IN      : 'not in';
LPAREN      : '(';
RPAREN      : ')';
COMMA       : ',';

INT_VALUE     : [0-9]+;
DECIMAL_VALUE : [0-9]+'.'[0-9]+;
BOOLEAN_VALUE : 'true' | 'false';
PROPERTY      : [a-zA-Z_][a-zA-Z0-9_.]*;
STRING_VALUE  : '"' (~["\\] | '\\' .)* '"';
FUNCTION_NAME : 'UPPER' | 'LOWER' | 'LENGTH' | 'TRIM' | 'LTRIM' | 'RTRIM' |
                'ABS' | 'SQRT' | 'MOD' | 'CONCAT' | 'SUBSTRING' | 'LOCATE' |
                'COALESCE' | 'NULLIF' | 'CURRENT_DATE' | 'CURRENT_TIME' |
                'CURRENT_TIMESTAMP' | 'COUNT' | 'SUM' | 'AVG' | 'MIN' | 'MAX';

query            : DISTINCT? (WHERE? condition)? (SORT sortFields)? (PAGINATION paginationParams)? ;
advancedQuery    : (SELECT selectFields)? (WHERE? condition)? (GROUP_BY groupByFields)? (HAVING havingCondition)? (SORT sortFields)? (PAGINATION paginationParams)? ;
condition        : simpleCondition | conditionWrapper | notCondition;
operator         : NEQ | LTE | GTE | EQ | LT | GT | STARTS_WITH | ENDS_WITH | CONTAINS | IS_NULL | IS_NOT_NULL | IN | NOT_IN ;
conditionWrapper : (AND | OR) LPAREN condition (COMMA condition)* RPAREN ;
notCondition     : NOT LPAREN condition RPAREN ;
simpleValue      : INT_VALUE | DECIMAL_VALUE | BOOLEAN_VALUE | STRING_VALUE;
arrayValue       : LPAREN simpleValue (COMMA simpleValue)* RPAREN ;
propertyOrFunction : PROPERTY | functionCall ;
functionCall     : FUNCTION_NAME LPAREN (functionArg (COMMA functionArg)*)? RPAREN ;
functionArg      : PROPERTY | simpleValue | functionCall ;
simpleCondition  : propertyOrFunction operator (simpleValue | arrayValue)? ;
direction        : ASC | DESC ;
sortField        : propertyOrFunction (direction)? ;
sortFields       : sortField (COMMA sortField)* ;
selectField      : propertyOrFunction (AS PROPERTY)? ;
selectFields     : selectField (COMMA selectField)* ;
groupByFields    : propertyOrFunction (COMMA propertyOrFunction)* ;
havingCondition  : condition ;
paginationParams : INT_VALUE COMMA INT_VALUE ;
```

Some examples of valid queries:

```text
lastName="Skywalker"
lastName!="Skywalker"
lastName starts with "Sky"
lastName ends with "walker"
lastName contains "wal"
and(firstName="Luke", lastName="Skywalker")
age>30
age<30
height>=1.80
height<=1.80
and(lastName="Skywalker", age>30)
and(or(firstName="Luke", firstName="Anakin"), lastName="Skywalker") sort by age desc
and(not(firstName="Luke"), lastName="Skywalker")
lastName="Skywalker" page 2,10
lastName is null
lastName is not null
lastName in ("Skywalker", "Solo")
lastName not in ("Skywalker", "Solo")
deleted=false
address.city="Rome"
distinct and(orders.totalPrice>1000,currency="EUR")
sort by lastName asc, age desc page 1,10
```

**Function expressions in query language:**

```text
UPPER(lastName)="SKYWALKER"
LENGTH(firstName)>5
LOWER(email) starts with "luke"
and(UPPER(lastName)="SKYWALKER", LENGTH(firstName)>3)
sort by LENGTH(lastName) desc
COALESCE(nickname, firstName)="Luke"
```

**Optional WHERE keyword:**

The `WHERE` keyword is optional and can be used for readability:

```text
where lastName="Skywalker"
where and(firstName="Luke", lastName="Skywalker") sort by age
distinct where status="ACTIVE" page 1,10
```

**SELECT, GROUP BY, and HAVING (AdvancedQuery):**

Use `QuerityParser.parseAdvancedQuery()` for queries with projections or grouping:

```text
select firstName, lastName, address.city
select id, UPPER(lastName) as upperName
select category, COUNT(id) as itemCount group by category
select category, SUM(amount) as total group by category having SUM(amount)>1000
select region, category, AVG(price) as avgPrice group by region, category sort by avgPrice desc
```

> Notice that string values must always be enclosed in double quotes.
