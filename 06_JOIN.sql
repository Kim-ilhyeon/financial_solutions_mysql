/*
	JOIN : 조인
    - 두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문.
    - 조회 결과는 하나의 결과(view - result Set)로 반환된다.
    
    관계혀여 데이터베이스는 데이터 중복을 막기위해 최소한의 데이터를 각각의 테이블에 나누어 저장한다.
    따라서, 무작정 전부 조회해 오는것이 아니라, 각 테이블간의 연결고리(PK/FK)를 통해서 데이터를 매칭시켜 조회.
    
*/

-- 사원의 사번, 이름, 부서명을 조회
-- 사번, 이름 => employee, 부서명 => department
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E
	JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);
    
    
/*
	1. inner JOIN
    : 연결시키는 컬럼의 값이 일치하는 행들만 조회
    (기준 컬럼 값이 NULL이거나 양쪽테이블에 일치하는 값이 없으면 결과에서 제외)
    
    1. 
*/


-- 예전 오라클 방식 : FROM절에 합칠 테이블 나열 + WHERE절에 조건 제시
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- ansi구문 : JOIN절에 합칠 테이블을 기술 + ON / USING으로 조건 제시
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 1. 연결할 두컬럼명이 다른 경우 : JOIN ~ ON 사용 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2. 연결할 두 컬럼명이 같을 경우 : JOIN ~ USING 사용
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE);
    
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
    
-- ------------- 실습 -------------
-- 부서가 인사관리부인 사원들의 사번, 이름, 보너스 조회
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE E
	JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE D.DEPT_TITLE = '인사관리부';

-- 2. 부서와 지역 테이블을 연결해서 전체 부서의 부서코드, 부서명, 지역코드, 지역명을 조회
SELECT DEPT_CODE, DEPT_TITLE, LOCATION_ID, LOCAl_NAME
FROM EMPLOYEE E
	JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
-- > EMPLOYEE가 아닌 DEPARTMENT만 조회해도 가능
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAl_NAME
FROM DEPARTMENT D
    JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- 3. BONUS를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E
	JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE BONUS IS NOT NULL;










