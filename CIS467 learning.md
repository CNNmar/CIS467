CIS467 learning



- 关系数据库以行为单位读写



### Functions in SQL

- DDL
  - CREATE
  - DROP
  - ALTER
- DML （most important）
  - SELECT
  - INSERT
  - UPDATE
  - DELETE
- DCL
  - COMMIT 确认数据库数据变更
  - ROLLBACK 取消变更
  - GRANT 赋予用户权限
  - REVOKE 取消权限



### Grammar of SQL

- string and date needs to be quoted by ' '



### Substring

```sql
LEFT(arg, num) # the first num elements in arg
RIGHT(arg, num) # the last num elements in arg
SUBSTRING(arg, left,num) # from the left of the string and substring for num elements
SUBSTRING(arg, left) #defaultly to the end, support the negative value, means the last 
SUBSTRING_INDEX(arg, keyword, num) #return the string before the numth keyword in arg
SUBSTRING_INDEX(arg, keyword, -num) #return the string after the numth keyword in arg

LIKE("xx%") # %means many
LIKE("xx_") # _means one
```



### REGEXPS

![image-20220915094734011](/Users/fanfan/Library/Application Support/typora-user-images/image-20220915094734011.png)

```sql
CONCAT(a, "x",b)
```

#### Aggregate function

- COUNT : neglect null value
- GROUP BY: WITH ROLLUP: with a description of the query

### Subquery

- WHERE IN(SELECT xxx)
- SELECT a, SELECT xxx = JOIN (correlated subquery = join)
- SELECT FROM(SELECT)

#### View VS Table

- view : virtual, update instantly
  - ![image-20221011004013078](/Users/fanfan/Library/Application Support/typora-user-images/image-20221011004013078.png)
  - UPDATE sss SET bbb = xxx WHERE aaa = 'aaa'
- Table: Not update instantly

#### GRAMMAR

- CASE xxx WHEN a THEN b

  ELSE d

  END AS c

- IF(a = 'a','YES','NO')

- IFNULL(a,'NULL') AS 'judge_a_null' = COALESCE(a,'NULL') AS 'judge_a_null' 

  - ifnull judge 1, coalesce judge n and iterately judge

  - SELECT city, state, country,
    	COALESCE (city, state, country, "none")
    FROM test;  

    if city, state, country all null, then none, else return city>state>country  

### Tricks

- Start with the table without foreign keys when inserting

- If we want to return the pair value between different rows, we can use different name of the same table to join them for a new table.