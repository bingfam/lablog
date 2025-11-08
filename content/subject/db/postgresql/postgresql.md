# postgresql

## 사용법

docker에 postgresql을 실행한 다음임.

### 유저 생성

```sql
# su - postgres
postgres@963e6c43fae6:~$ psql    
psql (17.4 (Debian 17.4-1.pgdg120+2))
Type "help" for help.

postgres=# create user scott password 'tiger';
CREATE ROLE
```


### 생성된 유저 보기
```
postgres=# \du
                             List of roles
 Role name |                         Attributes                         
-----------+------------------------------------------------------------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS
 scott     |
 ```


### 데이터베이스 생성(한글 잘 나오게)
```sql
postgres=# create database test owner scott  LC_COLLATE='C.utf8' LC_CTYPE='C.utf8' template=template0;
CREATE DATABASE
```


### scott으로 접속하기
```sql
postgres=# exit
postgres@963e6c43fae6:~$ psql -U scott test
psql (17.4 (Debian 17.4-1.pgdg120+2))
Type "help" for help.

test=> 
```

### 데이터베이스 목록 보기
```sql
nextauth=> \l
                                                    List of databases
   Name    |  Owner   | Encoding | Locale Provider |  Collate   |   Ctype    | Locale | ICU Rules |   Access privileges   
-----------+----------+----------+-----------------+------------+------------+--------+-----------+-----------------------
 nextauth  | scott    | UTF8     | libc            | C.utf8     | C.utf8     |        |           | 
 postgres  | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | 

 (4 rows)
```

### 테이블 목록 보기
```sql
nextauth=> \dt
        List of relations
 Schema |  Name  | Type  | Owner 
--------+--------+-------+-------
 public | data   | table | scott
 public | member | table | scott
(2 rows)
```


### 테이블 구조 보기
```sql
nextauth=> \d member
                       Table "public.member"
  Column  |          Type          | Collation | Nullable | Default 
----------+------------------------+-----------+----------+---------
 id       | character varying(10)  |           | not null | 
 nickname | character varying(10)  |           | not null | 
 pwd      | character varying(62)  |           | not null | 
 email    | character varying(100) |           |          | 
Indexes:
    "member_pkey" PRIMARY KEY, btree (id)

nextauth=> 
```
