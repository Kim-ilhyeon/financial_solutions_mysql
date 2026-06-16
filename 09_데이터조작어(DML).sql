use tdb;
/*
	DML (데이터 조작어)
    : 테이블에 저장되어있는 데이터를 조작(추가-INSERT, 수정-UPDATE, 삭제-DELETE)하는 SQL언어이다.
    - DDL과는 달리 DML은 실행 후 트랜잭션처리를 통해 완전히 저장하거나 취소할 수 있다.
*/

/*
	1. INSERT 
    : 테이블에 새로운 행(Row)을 추가하는 구문
    
    (1) 모든 컬럼에 값 추가
    INSERT INTO 테이블명 VALUES (값1, 값2, 값3, . . .);
    => 테이블에 정의된 컬럼의 수와 순서에 맞게 정확히 값을 나열해줘야 한다.
    
    INSERT INTO EMPLOYEE
    VALUES(900, '김수민', '880813-1234567', 'dd123@naver,cin', '01012345678', 'D9', 'J5', 4000000, 0.2, NULL, NOW(), NULL, 'N');
    
    (2) 특정 컬럼에만 값 추가
    INSERT INTO 테이블명 (컬럼1, 컬럼3, 컬럼7) VALUES (값1, 값3, 값7);
    => 선택하지 않은 컬럼에는 기본적으로 NULL이 들어가고, DEFAULT설정이 있다면 기본값이 들어감.
    (NOT NULL 제약조건이 있는 경우 반드시 값을 넣어주어야 한다.)
    
    INSERT INTO EMPLOYEE (
		EMP_ID, 
		EMP_NAME, 
		EMP_NO, 
		JOB_CODE, 
		HIRE_DATE
	) VALUES (
		901, 
		'최수민', 
		'900102-1234123',
		'J7', 
		NOW()
);

	(3) 서브쿼리를 이용한 INSERT
    : VALUES에 직접 값을 적는 대신, SELECT문을 통해 조회된 결과를 한번에 추가할 수 있음.
    
    INSERT INTO emp_01 
	(
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
		LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	);
    
    (4) 다중 테이블 삽입
    : 여러 테이블에 한번에 데이터를 추가할 수 있는 방법
    - mySQL :  없음
    - Oracle : INSERT ALL문법을 통해 가능함
    
    2. UPDATE
    : 테이블에 기록된 시존 데이터를 수정하는 구문
    
    UPDATE 테이블명
    SET 	컬럼1 = 값1, 
			컬럼2 = 값2, 
            . . .
	[WHERE 조건];
    
    - WHERE절 생략 시 테이블의 모든 데이터가 수정되는 상황이 발생!
    
    3. DELETE
    : 테이블에 기록된 데이터를 삭제하는 구문.
    
    DELETE FROM 테이블명
    [WHERE 조건];
    => WHERE절을 생략 시 해당 테이블의 모든 행(Row)을 삭제함. -> TRUNCATE TABLE과 같음 (속도는 TRUNCATE가 더 빠름)
*/
    INSERT INTO EMPLOYEE
    VALUES(900, '김수민', '880813-1234567', 'dd123@naver,cin', '01012345678', 'D9', 'J5', 4000000, 0.2, NULL, NOW(), NULL, 'N');
    
-- ------------------------------------------
    
    INSERT INTO EMPLOYEE (
		EMP_ID, 
		EMP_NAME, 
		EMP_NO, 
		JOB_CODE, 
		HIRE_DATE
	) VALUES (
		901, 
		'최수민', 
		'900102-1234123',
		'J7', 
		NOW()
);

-- -------------------------------------

    INSERT INTO emp_01 
	(
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
		LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	);

-- -----------------------------------------

CREATE TABLE emp_01 (
	emp_id INT, 
    emp_name VARCHAR(20), 
    dept_title VARCHAR(35)
);

SELECT * FROM EMP_01;

INSERT INTO emp_01 
(
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
		LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

-- ---------------------------------
CREATE TABLE dept_table AS SELECT * FROM DEPARTMENT;
ALTER TABLE dept_table ADD PRIMARY KEY(dept_id);
CREATE TABLE emp_salary
AS SELECT emp_id, emp_name, dept_code, salary, bonus FROM employee;

-- 업데이트 안전모드 끄기 0 / 켜기 1
SET sql_safe_updates = 0;
-- D9부서의 부서명을 전략기획팀 으로 변경
UPDATE dept_table
	SET dept_title = '전략기획팀'
WHERE dept_id = 'D9';

SELECT * FROM dept_table;
SELECT * FROM emp_salary;

-- 선동일 사원의 급여를 700만원, 보너스를 0.2로 변경
UPDATE emp_salary
	SET salary = 70000000, 
			bonus = 0.2
WHERE emp_name = '선동일';

-- 전 사원의 급여를 기존급여 + 10%인상된 급여로 일괄 수정
UPDATE emp_salary
	SET salary = salary * 1.1;

-- ASIA지역에서 근무하는 사원들의 보너스 값을 0.3으로 변경
UPDATE emp_salary E
	JOIN department D ON (E.dept_code = D.dept_id)
    JOIN location L ON (D.location_id = L.local_code)
	SET E.bonus = 0.3, 
			D.dept_title = '아시아본부'
WHERE L.local_name LIKE 'ASIA%';

-- ------------------------

START TRANSACTION;		-- 트랜잭션 시작

-- 전체 행 삭제
DELETE FROM employee;

ROLLBACK;

START TRANSACTION;		-- 트랜잭션 시작

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '김수민';

DELETE FROM EMPLOYEE
WHERE EMP_ID = 901;

COMMIT;












