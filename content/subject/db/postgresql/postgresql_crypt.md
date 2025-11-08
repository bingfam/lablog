# postgresql 암호화

## 암호화 모듈 설치

super user가 아니어도 된다. 누구나 설치할 수 있는 듯.

```
CREATE EXTENSION pgcrypto;
```

### 암호화 저장(단방향)
```sql
insert into person 
	(id, nickname, pwd)
values
(
	'user01'
	,'nickname'
	, crypt('entered password', gen_salt('bf'))	
);
```

gen_salt('bf') 로 하면 60자리 암호화 문자열이 만들어진다.


### 암호확인
```sql
select * 
from person
where 
	pwd = crypt('entered password', pwd);
```