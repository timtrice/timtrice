---
title: Big Countries
summary: > 
  LeetCode #595
date: 2022-12-01
categories: 
  - LeetCode
tags: 
  - SQL
output:
    blogdown::html_page:
      keep_md: true
      toc: true
---







[LeetCode #595. Big Countries](https://leetcode.com/problems/big-countries/description/)

## SChema


```sql
Create table If Not Exists World 
  (name varchar(255), continent varchar(255), area int, population int, gdp int)
```


```sql
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000')
```


```sql
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000')
```


```sql
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000')
```


```sql
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000')
```


```sql
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000')
```

## Intuition

<!-- Describe your first thoughts on how to solve this problem. -->

## Approach

<!-- Describe your approach to solving the problem. -->

## Complexity

- Time complexity:
<!-- Add your time complexity here, e.g. $$O(n)$$ -->

- Space complexity:
<!-- Add your space complexity here, e.g. $$O(n)$$ -->

## Code


```sql
SELECT
  `name`,
  `population`,
  `area`
FROM `World`
WHERE `area` > 3e6
  OR `population` > 25e6;
```


<div class="knitsql-table">


Table: (\#tab:unnamed-chunk-8)2 records

|name        | population|    area|
|:-----------|----------:|-------:|
|Afghanistan |   25500100|  652230|
|Algeria     |   37100000| 2381741|

</div>