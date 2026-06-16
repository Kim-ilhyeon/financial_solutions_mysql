/*
	DCL : 데이터 제어어
    - 데이터베이스 계정에 시스템 권한 또는 객체 접근권한을 부여(GRANT)하거나 회수(REVOKE)하는 구문
    
    - 시스템 권한 : DB생성, 사용자 생성 등 관리자 차원의 권한
    - 객체 접근 권한 : 특정 테이블, 뷰 등에 대한 SELECT, INSERT, UPDATE, DELETE 권한
*/

-- 1. 사용자 생성
-- localhost = dbms와 같은 컴퓨터에서만 접근가능
-- % = 모든 컴퓨터에서 접근 가능, 특정IP(192.xxx.xx.xx) = 특정 IP컴퓨터에서만 접근 가능
-- CREATE USER 계정명@접속위치 IDENTIFIED BY 비밀번호;
CREATE USER 'user01'@'localhost' IDENTIFIED BY 'test01';

-- 2. 권한 부여
-- GRANT 권한종류 ON db명.테이블명 TO 계정명@접속위치;

-- 3. 권한 회수 (REVOKE)
-- REVOKE 권한종류 ON db명.테이블명 FROM 계정명@접속위치;

-- ----------------------------------------------------
/*
	TCL : 트랜잭션 제어어
    - 트랜잭션은 하나 이상의 DML(INSERT, UPDATE, DELETE)문을 묶어서 하나의 논리적인 작업 단위로 처리하는 개념.
    
    - COMMIT : 트랜잭션 내용을 DB에 반영
    - ROLLBACK : 트랜잭션 내용을 전부 취소
    - SAVEPOINT : 트랜잭션 도중 시점을 저장 -> 해당 시점으로 ROLLBACK이 가능
    - ROLLBACK TO 세이브포인트 : 지정한 SAVEPOINT까지 돌아감
*/

-- mySQL은 기본적으로 DML실행 즉시 COMMIT이 되는 AUTOCOMMIT이 기본값으로 켜져있다.

-- AUTOCOMMIT 상태 확인
SELECT @@AUTOCOMMIT;

-- AUTOCOMMIT 수동 전환 (끄기)
SET AUTOCOMMIT = 0;


-- AUTOCOMMIT 수동 전환 (켜기)
SET AUTOCOMMIT = 1;

-- 직접 트랜잭션 사용 시에는 AUTOCOMMIT은 그냥 켜두고, STRAT TRANSACTION 활용
-- > 지금부터 트랜잭션을 만들어서 직접 사용하겠다. (1회성임)
START TRANSACTION;

DROP TABLE IF EXISTS EMP_01;

CREATE TABLE EMP_01 AS SELECT emp_id, emp_name, dept_code FROM EMPLOYEE;

SELECT * FROM EMP_01;

-- 트랜잭션 시작
START TRANSACTION;

-- 200번 201번 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (200, 201);

-- 지원진 것처럼 보이지만 아직 DB반영은 안된 상태
SELECT * FROM EMP_01;

-- 트랜잭션에 있는 작업 전부 취소
ROLLBACK;

SELECT * FROM EMP_01;	-- 200번, 201번 데이터가 다시 살아남.

-- 트랜잭션 시작
START TRANSACTION;

DELETE FROM EMP_01
WHERE EMP_ID IN (200, 201);

COMMIT;		-- 트랜잭션에 있는 모든 작업을 DB에 반영
SELECT * FROM EMP_01;

ROLLBACK;		-- 이미 커밋으로 트랜잭션이 비워져 있음
SELECT * FROM EMP_01;

-- ASVEPOINT
START TRANSACTION;

-- 214, 216, 217 사원 제거
DELETE FROM EMP_01
WHERE EMP_ID IN (214, 216, 217);

SAVEPOINT sp;

INSERT INTO EMP_01 VALUES (801, '김민규', 'D1');
INSERT INTO EMP_01 VALUES (800, '정민규', 'D2');
SELECT * FROM EMP_01;

-- 신입사원 추가 잘못되어서 되돌리고 싶다.
ROLLBACK TO sp;
SELECT * FROM EMP_01;
-- > INSERT 작업 두개는 취소되고, sp이전에 실행한 214,216,217제거는 유지됨.

COMMIT;

-- -----------------------------------------------------------
/*
	트랜잭션 진행 중에 CREATE, ALTER, FROP, TRUNCATE같은 DDL문을 실행하면
    현재까지 진행중인 트랜잭션 작업을 즉시 COMMIT(강제로 필수)
    
    -> DML작접 중에 절대호 작업하지마라!!
*/
START TRANSACTION;

INSERT INTO EMP_01 VALUES(999, '테스트', 'D1');

-- CREATE가 실행되는 순간 이전에 작업한 INSERT는 강제로 COMMIT됨.
CREATE TABLE test(tid INT);

ROLLBACK;
SELECT * FROM EMP_01;

/*
	트랜잭션의 ACID 속성
    : 트랜잭션이 데이터베이스의 일관성과 신뢰성을 보장하기 위해 지켜야하는 4가지
    
    A (Atomicity, 원자성) : 트랜잭션 내의 작업은 모두 성공(COMMIT), 모두 취소(ROLLBACK)되어야 한다.
    C (Consistencey, 일관성) : 트랜잭션 성공 후의 데이터베이스는 항상 유효한 상태를 유지해야 한다. -> 제약조건을 위반하면 안된다. -> 정상적이어야 한다.
    I (Isolation, 독립성) : 여러 트랜잭션이 동시에 실행될 때, 서로의 중간 작업 상태를 엿보거나 간섭할 수 없다. -> DB Lock
    D (Durability, 지속성) : 한번 커밋되면 이 결과는 시스템이 다운되거나 정전이 발생해도 영구적으로 보존되어야 한다.
*/

