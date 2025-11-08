# oracle

oracle db를 podman에서 사용하기

```ps
podman pull docker.io/jaspeen/oracle-xe-11g

podman run --name oracle-xe-11g -d -p 1521:1521 jaspeen/oracle-xe-11g
```

컨테이너 처음 실행하고 2분 정도 기다려야 정상 접속됨.

```
ls: cannot access /u01/app/oracle/oradata: No such file or directory
Database not initialized. Initializing database.
Setting up:
processes=500
sessions=555
transactions=610
If you want to use different parameters set processes, sessions, transactions env variables and consider this formula:
processes=x
sessions=x*1.1+5
transactions=sessions*1.1

Oracle Database 11g Express Edition Configuration
-------------------------------------------------
This will configure on-boot properties of Oracle Database 11g Express 
Edition.  The following questions will determine whether the database should 
be starting upon system boot, the ports it will use, and the passwords that 
will be used for database accounts.  Press <Enter> to accept the defaults. 
Ctrl-C will abort.

Specify the HTTP port that will be used for Oracle Application Express [8080]:
Specify a port that will be used for the database listener [1521]:
Specify a password to be used for database accounts.  Note that the same
password will be used for SYS and SYSTEM.  Oracle recommends the use of 
different passwords for each database account.  This can be done after 
initial configuration:
Confirm the password:

Do you want Oracle Database 11g Express Edition to be started on boot (y/n) [y]:
Starting Oracle Net Listener...Done
Configuring database...Done
Starting Oracle Database 11g Express Edition instance...Done
Installation completed successfully.
Database initialized. Please visit http://#containeer:8080/apex to proceed with configuration
Oracle Database 11g Express Edition instance is already started

Database ready to use. Enjoy! ;)
```

이런 말이 log에 나올 때까지 기다려야 한다.


## 접속정보
- sid: XE
- 로그인: system / oracle


## 미리 생성되어 있는 계정 중 HR 사용하기 

podman의 컨테이너 터미널에서 다음 실행

```sql
root@f422033b47fe:/# sqlplus system/oracle

SQL*Plus: Release 11.2.0.2.0 Production on Thu Jun 26 12:58:53 2025

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

SQL> ALTER USER HR ACCOUNT UNLOCK;

User altered.

SQL> alter user hr identified by tiger;

User altered.

SQL> 
```