-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과 주민번호, 부서 명, 직급 조회 
SELECT 
    EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM
    EMPLOYEE
        JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        JOIN
    JOB USING (JOB_CODE)
WHERE
    SUBSTRING(EMP_NO, 1, 2) BETWEEN 70 AND 79
        AND SUBSTRING(EMP_NO, 8, 1) IN ('2' , '4')
        AND EMP_NAME LIKE '전%';

-- 2. 이름에 ‘형’이 들어가는 사원의 사원 코드, 사원 명, 직급 조회
SELECT 
    EMP_ID, EMP_NAME, JOB_NAME
FROM
    EMPLOYEE
        JOIN
    JOB USING (JOB_CODE)
WHERE
    EMP_NAME LIKE '%형%';

-- 3. 부서코드가 D5이거나 D6인 사원의 사원 명, 직급 명, 부서 코드, 부서 명 조회
SELECT 
    EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM
    EMPLOYEE
        JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        JOIN
    JOB USING (JOB_CODE)
WHERE
    DEPT_CODE IN ('D5' , 'D6');

-- 4. 보너스를 받는 사원의 사원 명, 부서 명, 지역 명 조회
SELECT 
    EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM
    EMPLOYEE
        JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        JOIN
    LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE
    BONUS IS NOT NULL;

-- 5. 사원 명, 직급 명, 부서 명, 지역 명 조회 (부서 배치를 받지 않은 사원도 포함할 것)
SELECT 
    EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM
    EMPLOYEE
        LEFT JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        LEFT JOIN
    JOB USING (JOB_CODE)
        LEFT JOIN
    LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 6. 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회  
SELECT 
    EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM
    EMPLOYEE
        LEFT JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        LEFT JOIN
    LOCATION ON (LOCATION_ID = LOCAL_CODE)
        LEFT JOIN
    NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국', '일본');

-- 7. 한 명의 사원과 같은 부서에서 일하는 사원의 이름 조회
--    (예: 사원 A가 속한 부서에서 다른 사원 B의 이름을 조회. 단, 본인 이름은 제외)
SELECT E.EMP_NAME AS '사원명', D.EMP_NAME AS '같은부서 사원'
FROM EMPLOYEE E
	JOIN EMPLOYEE D ON (E.DEPT_CODE = D.DEPT_CODE)
WHERE E.EMP_ID <> D.EMP_ID
ORDER BY E.EMP_ID;

-- 8. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급 명, 급여 조회
SELECT 
    EMP_NAME, JOB_NAME, SALARY
FROM
    EMPLOYEE
        JOIN
    JOB USING (JOB_CODE)
WHERE
    BONUS IS NULL
        AND JOB_CODE IN ('J4' , 'J7');

-- 9. 부서 명과 부서 별 급여 합계 조회
SELECT 
    DEPT_TITLE, SUM(SALARY)
FROM
    EMPLOYEE
        JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;

-- 10. 부서 별 급여 합계가 전체 급여 총합의 20%보다 많은 부서의 부서 명, 부서 별 급여 합계 조회
-- TODO : 서브쿼리
SELECT 
    DEPT_TITLE, SUM(SALARY)
FROM
    EMPLOYEE E
        JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (
	SELECT SUM(SALARY) * 0.2
	FROM EMPLOYEE
	);

-- 11. 나이 상 가장 막내인 사원의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회  
--     (단, 나이는 만 나이로 계산하거나, 주민번호 앞자리를 기준으로 구하시오)
-- TODO : 서브쿼리
SELECT EMP_ID, EMP_NAME, (YEAR(NOW()) - IF(SUBSTRING(EMP_NO, 1, 2) > 26, 1900+SUBSTRING(EMP_NO, 1, 2), 2000+SUBSTRING(EMP_NO, 1, 2))) AS '나이', DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE)
-- WHERE MIN((SUBSTRING(YEAR(NOW()), 3, 2) - SUBSTRING(EMP_NO, 1, 2) + 1)) = (SUBSTRING(YEAR(NOW()), 3, 2) - SUBSTRING(EMP_NO, 1, 2) + 1);
WHERE (YEAR(NOW()) - IF(SUBSTRING(EMP_NO, 1, 2) > 26, 1900+SUBSTRING(EMP_NO, 1, 2), 2000+SUBSTRING(EMP_NO, 1, 2))) = (
	SELECT MIN(YEAR(NOW()) - IF(SUBSTRING(EMP_NO, 1, 2) > 26, 1900+SUBSTRING(EMP_NO, 1, 2), 2000+SUBSTRING(EMP_NO, 1, 2)))
	FROM EMPLOYEE
    );

SELECT MIN(YEAR(NOW()) - IF(SUBSTRING(EMP_NO, 1, 2) > 26, 1900+SUBSTRING(EMP_NO, 1, 2), 2000+SUBSTRING(EMP_NO, 1, 2)))
FROM EMPLOYEE;


-- 12. 해외영업부서(해외영업1부, 2부, 3부)에 근무하는 사원들의 사원명, 직급명, 부서명, 급여를 조회하시오.
SELECT 
    EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM
    EMPLOYEE
        JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        JOIN
    JOB USING (JOB_CODE)
WHERE
    DEPT_TITLE LIKE '해외영업%';

-- 13. 비등가 조인을 활용하여 사원명, 부서명, 급여, 급여등급(SAL_LEVEL)을 조회하시오. 
--     (단, 부서 배치를 받지 않은 사원도 포함할 것)
SELECT 
    EMP_NAME, DEPT_TITLE, SALARY, SAL_LEVEL
FROM
    EMPLOYEE
        LEFT JOIN
    DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        LEFT JOIN
    SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- 14. 본인이 속한 부서의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 사원명, 부서명, 급여를 조회하시오.
-- TODO : 서브쿼리
--     (단, 부서 배치를 받은 사원들만 대상으로 할 것)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE E
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (
	SELECT AVG(SALARY)
    FROM EMPLOYEE
    WHERE DEPT_CODE = E.DEPT_CODE
	);

-- 15. 부서 배치를 받지 않은 사원(DEPT_CODE가 NULL)의 사원명, 직급명, 급여를 조회하되, 직급명 오름차순으로 정렬하시오.
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
WHERE DEPT_CODE IS NULL
ORDER BY JOB_NAME;