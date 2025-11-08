# postgresql 보안

## 암호화: pgcrypto

postgresql에서 pgcrypto extenwsion을 설치해 사용.
```sql
create extension pgcrypto;
```

```sql
select crypt('password', gen_salt('bf')), gen_salt('bf'), gen_salt('bf') from person 
```

|crypt|gen_salt|gen_salt|
|-----|--------|--------|
|$2a$06$4VKMr06kmf.B2NYsXIo8YuFklgDAN/.d0DtXr8AjAGMTHmZM6zJPi|$2a$06$Pn8VLVjEMdDHGR6Kd8zHou|$2a$06$QVFyuO7KUwHM6ICBkOuKAO|
|$2a$06$z2G9KZTwNtRPRWC5aOGMz.pUQTyhLg8aJzqB9ITQ5Qh2snW8B4vaa|$2a$06$aZOByB.sIkzI1GIvvoJ7ce|$2a$06$msvxhMmuRI6rCkoTurvn9.|
|$2a$06$SEJOY6Fq6sAAODVeF9WQwOiXEYFVDdMVJnjMed/lOyLEwB4nj919O|$2a$06$UQb22zkq9hV0OMDTwFYxzO|$2a$06$shgzHIozenbZt7R7wFcsaO|
|$2a$06$3dGWLx4sW4wA/L1bcoj.L.X3ZT.KNINrTkrJhC2a41ntWuj5rERye|$2a$06$rTj03AOManccUIuI2XIbV.|$2a$06$2GBJ/6jZr1qg0nPgulMdFe|
|$2a$06$4OAARuBSDOZG9MpGee3psOzTiWM7dd20geejE71O9xVA94UqIk04O|$2a$06$/unpztSApPOrMpUFWZPaKO|$2a$06$jkqcmG.zFt43dfnKD4Jmo.|
|$2a$06$o1twjlcnFMbD7Ia2t/maye0QasloFQrH4YJBeP7xwqPO1nQe579pq|$2a$06$v.8anVVjrOqpwVs97AaTWe|$2a$06$5G/yWb9TZd8d9UPHdEdRLO|
|$2a$06$e9yMZYCbRsrzZ.EgFDzDLuWD3/soADwDmOPKV2UYJf8X0NlL8vNYK|$2a$06$N5gsCvmLl5p7h4HqTUo2ce|$2a$06$IxwHaxoJtS.8wtpRSqYxIO|
|$2a$06$KWrWFoDNVV81KGcF3Du0deuLKRRKjjuXCVJxOTd.QuothBzTD5rAa|$2a$06$sn09Y90aC2BIduxLJlTj2O|$2a$06$LnLkctD2dMdOh1OM1sfHq.|
|$2a$06$3YUzaaW8vWerHmlp2oqd3.G2nPEo5RdKTrp.Vsrxinqif2O7iJjDK|$2a$06$OdBQSrm05ATGeVrxna/d5u|$2a$06$8DBvMyAbKjyxLVG0MbAbO.|

<br />

`get_salt('bf')`는 할 때 마다 다 다른 값이 나온다.

이 값을 기반으로 같은 비밀번호라도(여기서는 'password') 해싱값이 다 다르게 나온다. 그래서 보안이 강력해진다.


### salt 값을 저장하지 않는 경우

#### 암호화하기

```sql
insert into person (id, pwd) values ('X00101', crypt('password', gen_salt('bf')));
```

#### 암호 검증
```sql
select id from person where id ='X00101' and pwd = crypt('password', pwd);
```

salt 값을 저장하지 않아도 문제없이 로그인을 할 수 있다.

보안이 아래 salt 값을 저장하는 경우보다 떨어진다고 한다.

<br />

### salt 값을 저장하는 경우

#### 암호화하기

```sql
insert into person 
    (id, pwd, salt) 
values 
    ('X00101', crypt('password', gen_salt('bf')), gen_salt('bf'));
```

#### 암호 검증
```sql
select 
    id 
from 
    person 
where 
    id ='X00101' 
    and pwd = crypt('password', salt);
```

이해는 되지 않지만 이렇게 해도 문제없이 로그인을 할 수 있다.

위에서 본 것 처럼 get_salt('bf')를 할 때마다 값이 달라지는데, 왜 salt 값을 저장.. 하는 거야. 

[https://postgresql.kr/docs/9.6/pgcrypto.html](https://postgresql.kr/docs/9.6/pgcrypto.html) 을 봐도 salt 값을 저장하라는 말은 없다.

perplexity 답:
```
PostgreSQL pgcrypto 확장 모듈을 이용해 비밀번호를 해시할 때, salt 값을 별도로 저장하지 않는 것이 일반적입니다. 이유는 crypt() 함수가 해시 결과 안에 salt 정보를 함께 포함하기 때문입니다.

비밀번호를 처음 저장할 때는 gen_salt() 함수로 salt를 생성하고, crypt(비밀번호, salt)로 해시를 만듭니다.

이 해시 문자열 안에 salt와 알고리즘 정보가 모두 포함되어 저장됩니다.

로그인 검증 시에는 저장된 해시 값을 salt 인자로 다시 crypt()에 넣어 같은 방식으로 해시를 생성하고, 결과를 비교합니다.

즉, salt를 별도의 컬럼에 저장하지 않고, 해시 문자열 자체에 포함시키는 방식이 표준입니다.
```