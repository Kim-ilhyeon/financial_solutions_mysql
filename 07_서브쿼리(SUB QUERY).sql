/*
	SUB QUERY
    : 하나의 SQL문 안에 포함된 또 다른 SELECT문
    
    - 메인 QUERY문을 위해 보조 역할을 하는 QUERY문
*/

-- 노옹철 사원과 같은 부서에 속한 사원을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (
	-- 노옹철 사원의 부서코드
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
	);

-- 전체 직원의 평균급여보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급코드, 급여
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (
	SELECT AVG(SALARY)
    FROM EMPLOYEE
	);

/*
	서브쿼리 분류
    - 서브쿼리를 실행한 결과 값이 몇행, 몇열로 나오는지에 따라서 분류
    
    1. 단일 행 서브쿼리				: 서브쿼리의 조회 결과 값이 오로지 1개인 경우 (1행 1열)
    2. 다중 행 서브쿼리				: 서브쿼리의 조회 결과 값이 여러 행인 경우 (N행 1열)
    3. 다중 열 서브쿼리				: 서브쿼리의 조회 결과 값이 여러 열인 경우 (1행 N열)
    4. 다중 행 다중 열 서브쿼리	: 서브쿼리의 조회 결과 값이 여러 행, 여러 열일 경우 (N행 N열)
*/
/*
	단일 행 서브쿼리
    - 쿼리 결과 값이 딱 1개이다.
    - 일반적으로 비교연산자와 함께 사용 (= <> > < . . .)
*/
-- 전 직원의 평균 급여보다 급여를 더 적게 받는 사원들의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY < (
	SELECT AVG(SALARY)
    FROM EMPLOYEE
	);

-- 사원들 중 최저급여을 받는 사원의 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (
	SELECT MIN(SALARY)
    FROM EMPLOYEE
    );

-- 부서 별 급여 합이 가장 큰 부서의 부서코드, 급여 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
	SELECT SUM(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY SUM(SALARY) DESC
    LIMIT 1
	);
-- > LIMIT N: 정렬한 기준으로 가장 N번째 값까지만 조회

-- 전지연 사원과 같은 부서 사람들의 사번, 사원명, 전화번호, 부서명을 조회
-- 단, 전지연 본인은 제외
SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '전지연'
	)
    AND EMP_NAME <> '전지연';

-- ---------------------------------------------
/*
	다중 행 서브쿼리
    - 서브 쿼리의 결과 값이 여러 행일 경우 (단, 컬럼은 1개)
    
    - 다중 행 연산자
    IN (여러개의 값) : 여러 개의 값 중에 하나라도 일치하는가?
    > ANY (여러 값) : 여러 개의 값 중 최소값보다 큰가? (하나라도 만족하면 참)
    < ANY (여러 값) : 여러 개의 값 중 최대값보다 작은가? (하나라도 만족하면 참)
    > ALL (여러 값) : 여러 개의 값 모두보다 큰가? (모두 다 만족해야 참)
    < ALL (여러 값) : 여러 개의 값 모두보다 작은가? (모두 다 만족해야 참)
*/
-- 유재식 또는 윤은해 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (
	SELECT JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME IN ('유재식', '윤은해')
	);

-- 대리 직급임에도 과장 직급의 최소급여보다 더 많이 받는 사원들의 사번, 이름, 직급, 급여를 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
	AND SALARY > ANY (
	SELECT SALARY
    FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
    WHERE JOB_NAME = '과장'
    );

/*
	다중 열 서브쿼리
    - 결과 값은 한 행이지만, 나열된 컬럼의 수가 여러 개일 경우
    - 튜플비교방식을 사용함 (컬럼1, 컬럼2) = (값1, 값2)
    * 위치 값으로 비교하기 때문에 주의!!!
*/

-- 하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE EMP_NAME = '하이유'
    )
    AND EMP_NAME <> '하이유';

-- 박나라 사원과 같은 직급코드, 같은 사수를 가지고있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회 (단, 박나라 제외)
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (
	SELECT JOB_CODE, MANAGER_ID
    FROM EMPLOYEE
    WHERE EMP_NAME = '박나라'
	)
    AND EMP_NAME <> '박나라';

-- ------------------------------------
/*
	다중 행 다중 열 서브쿼리
    - 서브쿼리의 조회 결과 값이 여러 ROW데이터, 여러 컬럼일 경우
*/

-- 각 직급별 최소급여를 받는 사원의 사번, 사원명, 직급코드, 급여를 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
	SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE
	);

-- 각 부서별 급여 합계가 전체급여 총합의 20%보다 많은 부서의 부서명, 부서별 급여합계 조회
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (
	SELECT SUM(SALARY) *0.2
    FROM EMPLOYEE
	);

-- 각 부서의 최고 급여를 받는 사원들의 사번, 사원명, 부서코드, 급여를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (
	SELECT DEPT_CODE, MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
	);












