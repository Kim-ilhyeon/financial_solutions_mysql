/*
	VIEW : SELECT문의 결과로 만든 가상테이블
    - 자주 사용하는 복잡한 SELECT문을 하나의 가상테이블처럼 저장해놓은 객체
    (실제 데이터를 디스크에 물리적으로 저장하지 않고, 뷰를 조회할 때마다 SELECT문이 실행됨) -> 메크로돌리는 느낌
    - 복잡한 JOIN쿼리를 매번 작성할 필요없이 재사용할 수 있어서 가독성과 생산성이 증가.
*/

use tdb;
-- 한국, 러시아, 일본 등 각 국가별 근무 사원을 조회할 때
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본';

-- 매번 이렇게 긴 JOIN쿼리를 작성해야 한다면 VIEW를 생성해서 효율적으로 관리할 수 있음.

/*
	VIEW 생성 및 수정 방법
    
    CREATE [OR REPLACE] VIEW 뷰명
    AS 서브쿼리(SELECT문)
*/

CREATE OR REPLACE VIEW vw_employee
AS 
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
	FROM EMPLOYEE
		JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
		JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
		JOIN NATIONAL USING (NATIONAL_CODE);

-- 생성된 뷰는 테이블과 동일하게 사용 가능
SELECT * FROM vw_employee
WHERE NATIONAL_NAME = '중국';

/*
	연산식이나 함수를 포함한 VIEW 생성
*/

CREATE OR REPLACE VIEW vw_emp_job AS
SELECT EMP_ID, EMP_NAME, JOB_NAME, 
			IF(SUBSTRING(EMP_NO, 8, 1) IN ('1', '3'), '남', '여') AS 'GENDER', 
			(YEAR(NOW()) - YEAR(HIRE_DATE)) AS 'SERVICE_YEAR'
FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE);


SELECT * FROM vw_emp_job;

-- 뷰 삭제
DROP VIEW vw_emp_job;

/*
	뷰를 통한 DML이 가능하다.
    (뷰를 조작하면, 뷰가 참조하고 있는 실제 원본테이블의 데이터가 변경됨.)
    -> 대체적으로 VIEW를 통한 데이터 조작은 가능하나 권장하지 않음.
*/

/*
	VIEW 생성 옵션
    CREATE [OR REPLACE] VIEW 뷰명 AS 서브쿼리
    [WITH CHECK OPTION]
*/

-- WITH CHECK OPTION
-- 뷰를 생성할 때 쓴 WHERE 조건에 위배되는 데이터의 삽입/수정을 차단한다.
CREATE OR REPLACE VIEW vw_emp AS
SELECT *FROM EMPLOYEE WHERE SALARY >= 3000000;

SELECT * FROM vw_emp;

-- 원본테이블도 수정되면서 이 뷰에서는 더이상 해당 데이터를 가져올 수 없다.
UPDATE vw_emp
SET SALARY = 2000000
WHERE EMP_ID = 200;

SELECT * FROM vw_emp;
SELECT * FROM EMPLOYEE;

UPDATE EMPLOYEE
SET SALARY = 8000000
WHERE EMP_ID = 200;

CREATE OR REPLACE VIEW vw_emp AS
SELECT *FROM EMPLOYEE WHERE SALARY >= 3000000
WITH CHECK OPTION;

-- 뷰의 조건을 벗어나는 값으로 데이터가 수정되면 DB가 강제로 막아준다.
UPDATE vw_emp
SET SALARY = 2000000
WHERE EMP_ID = 200;

/*
	인라인 뷰 (Inline View)
    : FROM절에 사용하는 서브쿼리를 의미함
    - CREATE VIEW로 실행하는 뷰는 아니고, 쿼리가 실행되는 순간 서브쿼리의 결과를 마치 가상테이블처럼 FROM절에 사용할 수 있다.
*/

SELECT V.EMP_NAME, V.SALARY
FROM (
	SELECT EMP_ID, EMP_NAME, SALARY
    FROM EMPLOYEE
) AS V;		-- 인라인 뷰는 별칭이 필수이다.

-- 부서별 평균 급여보다 많이 받는 사원 찾기
SELECT E.EMP_NAME, E.DEPT_CODE, E.SALARY, V.avg_sal
FROM EMPLOYEE E
	JOIN (
		SELECT DEPT_CODE, AVG(SALARY) AS 'avg_sal'
		FROM EMPLOYEE
		GROUP BY DEPT_CODE
    ) AS V ON (E.DEPT_CODE = V.DEPT_CODE)
WHERE E.SALARY > V.avg_sal;

SELECT DEPT_CODE, AVG(SALARY) AS avg_sal
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 문제 1
-- EMPLOYEE 테이블에서 사번(EMP_ID), 직원명(EMP_NAME), 직급코드(JOB_CODE)만 조회하는 인라인 뷰를 만들고,
-- 그 가상 테이블에서 직급코드가 'J5' 또는 'J6'인 사원만 조회하시오.
SELECT *
FROM (
	SELECT EMP_ID, EMP_NAME, JOB_CODE
    FROM EMPLOYEE
    ) AS V
WHERE V.JOB_CODE IN ('J5', 'J6');


-- 문제 2.
-- 각 부서별(DEPT_CODE)로 가장 높은 급여(MAX_SAL)를 구하는 인라인 뷰를 작성하고, 
-- 이를 EMPLOYEE 테이블과 조인하여 '자신이 속한 부서에서 가장 높은 급여를 받는 사원'의
-- 직원명(EMP_NAME), 부서코드(DEPT_CODE), 급여(SALARY)를 조회하시오.
SELECT E.EMP_NAME, E.DEPT_CODE, E.SALARY
FROM EMPLOYEE E
	JOIN (
    SELECT DEPT_CODE, MAX(SALARY) AS MAX_SAL
	FROM EMPLOYEE
	GROUP BY DEPT_CODE
    ) AS G ON (E.DEPT_CODE = G.DEPT_CODE)
WHERE E.SALARY = G.MAX_SAL;
--     ) AS G ON (E.DEPT_CODE = G.DEPT_CODE AND E.SALARY = G.MAX_SAL);

-- 문제 3
-- 입사일(HIRE_DATE)이 가장 빠른(오래된) '최고참 사원 3명'의 직원명과 입사일을 조회하시오.
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE
LIMIT 3;













