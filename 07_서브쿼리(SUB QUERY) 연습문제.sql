-- 문제 1.
-- '노옹철' 사원과 같은 부서(DEPT_CODE)에 속한 사원들의 사원명, 부서코드, 입사일을 조회하시오.
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
	)
    AND EMP_NAME <> '노옹철';

-- 문제 2. 
-- 회사 전체 사원의 평균 급여보다 같거나 많은 급여를 받는 사원들의 사번, 사원명, 급여를 조회하시오.
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= (
	SELECT AVG(SALARY)
    FROM EMPLOYEE
    );

-- 문제 3. 
-- 전 직원 중 가장 적은 급여를 받는 사원의 사원명, 직급코드, 급여를 조회하시오. 
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY = (
	SELECT MIN(SALARY)
    FROM EMPLOYEE
    );

-- 문제 4. 
-- 부서명(DEPT_TITLE)이 '총무부' 또는 '마케팅부'인 부서에 속한 사원들의 사원명, 부서코드, 급여를 조회하시오.
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN ('총무부', '마케팅부');

-- 문제 5. 
-- 직급이 '과장'인 사원들 중 어느 한 명의 급여보다라도 더 많이 받는 '대리' 사원의 사원명, 직급명, 급여를 조회하시오.
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
WHERE SALARY > ANY (
	SELECT SALARY
    FROM EMPLOYEE
		JOIN JOB USING (JOB_CODE)
	WHERE JOB_NAME = '과장'
    )
    AND JOB_NAME = '대리';

SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
	AND SALARY > ANY (
	SELECT SALARY
    FROM EMPLOYEE
		JOIN JOB USING (JOB_CODE)
	WHERE JOB_NAME = '과장'
    );


-- 문제 6. 
-- 다른 사원의 관리자(MANAGER_ID)로 지정되지 않은 일반 평사원들의 사원명, 부서코드, 직급코드를 조회하시오.
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_ID NOT IN (
	-- MANAGER_ID가 NULL이 아닌 MANAGER_ID를 중복없이 조회
	SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL
	);

-- 문제 7.
-- '유재식' 사원과 같은 부서코드, 같은 직급코드를 가지는 사원들의 사원명, 부서코드, 직급코드를 조회하시오.
-- (단, 유재식 사원 본인은 결과에서 제외할 것)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '유재식'
	)
    AND EMP_NAME <> '유재식';

-- 문제 8. 
-- 각 직급(JOB_CODE)별로 가장 높은 급여를 받는 사원들의 사원명, 직급코드, 급여를 조회하시오.
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
	SELECT JOB_CODE, MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE
	);

-- 문제 9. 
-- 부서별 급여 합계가 '회사 전체 급여 총합의 20%'보다 큰 부서의 부서코드와 급여 합계를 조회하시오.
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > (
	SELECT SUM(SALARY) * 0.2
    FROM EMPLOYEE
	);

-- 문제 10.
-- 부서별 평균 급여가 가장 높은 부서에 속한 사원들의 사원명, 부서코드, 급여를 조회하시오.
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
    FROM EMPLOYEE
	GROUP BY DEPT_CODE
    HAVING AVG(SALARY) = (
        	SELECT AVG(SALARY)
			FROM EMPLOYEE
			GROUP BY DEPT_CODE
			ORDER BY AVG(SALARY) DESC
			LIMIT 1
		)
	);
    
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY AVG(SALARY) DESC
    LIMIT 1
	);