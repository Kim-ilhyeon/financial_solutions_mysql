use tdb;
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
/* inner */JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE BONUS IS NOT NULL;

-- ------------------------------------
/*
	2. OUTER JOIN
    : 두 테이블 간의 JOIN시 일치하지 않는 행도 포함시켜서 조회할 때 사용
    (예시 : 부서배치를 아직 받지않은 신입사원도 목록에 포함해서 보고 싶을 때) = 테이블의 데이터를 누락없이 조회하기 위해서
    
    반드시 LEFT/RIGHT를 지정해서 어떤 테이블이 기준이 될지를 정해줘야 함.
*/
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- > INNER JOIN시 부서배치를 받지 않은 DEPT_CODE가 NULL인 사원 2명이 누락됨.

-- LEFT [OUTER] JOIN : 왼쪽(FROM절)에 있는 테이블을 기준으로 모든 데이터를 무조건 가져온다.
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
	LEFT /* OUTER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- > 부서가 없는 사원도 조회

-- RIGHT JOIN : 오른쪽(JOIN절) 테이블의 모든 데이터를 무조건 가져온다.
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
	RIGHT /* OUTER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- > 소속된 사원이 없는 부서도 조회

-- FULL JOIN : 양쪽 테이블의 모든 행을 살려서 조회
-- mySQL에서는 FULL JOIN이라는 문법을 지원하지 않는다.
-- 따라서 LEFT JOIN 결과와 RIGHT JOIN 결과를 UNION 연산자를 사용해서 합치는 방식을 사용함

SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
UNION
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
	RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
/*
	집합 연산자
    : 여러 개의 쿼리를 하나의 결과로 합해서 보여주는 연산자
    
    - UNION : 합집합 (두 쿼리 결과를 합치되, 중복은 제거)
    - UNION ALL : 합집합 (두 쿼리 결과를 합치고, 중복 제거X)
*/

-- ------------------------------------------------
/*
	3. 비등가 조인
    : 매칭시킬 컬럼에 대한 조건 작성 시 '='를 사용하지 않는 조인.
    주로 수치적 범위를 기반으로 JOIN할 때 사용.
    (속도가 느리다)
*/
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
	JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

/*
	4. SELF JOIN
    : 같은 테이블을 다시 한번 더 JOIN하는 경우
    
    - 주로 사원과 관리자, 부품과 상위부품 등의 계층형 데이터 관계를 다룰 때사용한다.
    - 동일한 테이블을 2번 부르기 때문에 반드시 별칭을 지정해서 구분해야 한다.
    (일반적으로 테이블 별칭은 대문자 1개로 작성한다.)
*/
-- 전체 사원의 사번, 사원명, 부서코드, 사수의 사번, 사수의 사원명, 사수의 부서코드
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
	LEFT JOIN EMPLOYEE M ON (M.EMP_ID = E.MANAGER_ID);

-- ---------------------------------------------
/*
	5. 다중 조인(MULTIPLE JOIN)
    : 2개 이상의 테이블을 순차적으로 계속 JOIN해 나간다.
    연결 고리가 있는 테이블부터 차근차근 이어가야 함.
*/
-- 사원의 사번, 사원명, 부서명, 직급명 조회()
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    LEFT JOIN JOB USING (JOB_CODE);	-- 여기서 LEFT를 하는 경우 EMPLOYEE + DEPARTMENT에서 EMPLOYEE기준으로 합쳐진것을 기준으로 한다는 뜻이다.
    
-- 사원의 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    LEFT JOIN JOB USING (JOB_CODE)
    LEFT JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
    LEFT JOIN NATIONAL USING (NATIONAL_CODE)
    LEFT JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- ----------------------------------------

/*
	6. 자연 JOIN(NATURAL JOIN)
    : 두 테이블 간에 동일한 이름을 가진 컬럼을 데이터베이스가 알아서 찾아서 JOIN
    (ON이나 USING을 쓰지 않아도됨. 실제로 거의 사용하지 않음)
    
    단점 : 개발자의 의도와는 다르게 우연히 이름이 같은 다른 컬럼까지 모두 조인조건으로 묶어버릴 수 있다.
*/

-- EMPLOYEE와 JOB테이블에는 둘다 JOB_CODE라는 컬럼이 있음. (자동연결 가능)
SELECT *
FROM EMPLOYEE
NATURAL JOIN JOB;


