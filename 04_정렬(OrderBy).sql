/*
	정렬 : ORDER BY
    SELECT 문 구조상 가장 마지막에 작성되는 구문으로, 조회된 데이터를 특정 기준에 맞춰 순서대로 정렬할 때 사용.
    
    SELECT 컬럼, 컬럼. . .
    FROM 테이블명
    WHERE 조건
    ORDER BY 정렬기준(컬럼명|별칭|순번) [ASC | DESC];
    
    - ASC : 오름차순
    - DESC : 내림차순
    
    NULL : mySQL(가장 작은 값), ORACLE(가장 큰 값) 으로 취급한다.
*/

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
ORDER BY SALARY;		-- 기본값은 오름차순(ASC)

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
ORDER BY SALARY DESC;

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
ORDER BY EMP_NAME DESC;

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;

-- 다중 정렬(기준이 여러개)
-- 첫번째 기준이 동일할 경우 두번째 기중으로 정렬 . . .
SELECT EMP_NAME, SALARY, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
ORDER BY DEPT_CODE ASC, EMP_NAME DESC;

-- 별칭이나 순번으로도 정렬이 가능
-- ORDER BY가 가장 마지막에 실행되므로 별칭 사용이 가능.
SELECT EMP_NAME, (SALARY * 12) AS '연봉'
FROM EMPLOYEE
ORDER BY 연봉 DESC;

SELECT EMP_NAME, (SALARY * 12) AS '연봉'
FROM EMPLOYEE
ORDER BY 2 DESC;

-- NULL값 위치 변경
-- 오라클은 NULS FIRST / NULLS LAST같은 문법이 따로 존재함.

-- 기본적으로 NULL은 가장 작은 값으로 취급함
SELECT EMP_NAME, BONUS
FROM EMPLOYEE
ORDER BY BONUS ASC;

-- 오름차순 정렬은 하되, NULL값을 가장 뒤쪽으로 배치하고 싶다면
-- BONUS IS NULL -> 참이면 1, 거짓이면 0을 반환.
-- 오름차순 정렬 시 0(데이터 있음), 1(데이터 없음)
-- 위와 같은 것을 이용하여 데이터 없는 것과 있는것 차이로 먼저 구분되고 그 이후에 보너스값에 따라 정렬 가능

SELECT EMP_NAME, BONUS
FROM EMPLOYEE
ORDER BY BONUS IS NULL, BONUS ASC;













