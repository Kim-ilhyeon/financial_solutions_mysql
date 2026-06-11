------------------------- [ ORDER BY 정렬 문제 ] -------------------------

-- 문제 1. 
-- 사원명, 급여, 입사일을 조회하되 입사일이 가장 최근인(나중에 입사한) 사원부터 내림차순 정렬하시오.
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;

-- 문제 2. 
-- 사원명, 부서코드, 급여를 조회하되 1차 기준은 부서코드 오름차순으로, 
-- 부서코드가 같을 경우 2차 기준은 급여 내림차순으로 정렬하시오.
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
ORDER BY DEPT_CODE, SALARY DESC;

-- 문제 3. 
-- 사원명, 보너스, 연봉(SALARY * 12)을 조회하시오. 
-- 연봉 컬럼에는 "연봉"이라는 별칭을 부여하고, 연봉이 가장 높은 사원순(내림차순)으로 정렬하시오. (ORDER BY절에 별칭 사용)
SELECT EMP_NAME, BONUS, (SALARY * 12) AS '연봉'
FROM EMPLOYEE
ORDER BY 연봉 DESC;

-- 문제 4. 
-- 사원명, 전화번호, 이메일을 사원명 가나다순(오름차순)으로 정렬하여 조회하시오.
SELECT EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
ORDER BY EMP_NAME;

-- 문제 5.
-- 사원명, 보너스를 조회하되 보너스 오름차순으로 정렬하시오. 
-- 단, 보너스가 없는(NULL) 사원들은 명단 가장 마지막에 출력되도록 정렬하시오.
SELECT EMP_NAME, BONUS
FROM EMPLOYEE
ORDER BY (BONUS IS NULL), BONUS;


----------------------- [ GROUP BY / HAVING 문제 ] -----------------------

-- 문제 6. 
-- 각 부서코드별 사원 수를 조회하시오. (부서코드, 사원수 출력)
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 문제 7. 
-- 직급코드(JOB_CODE)별 총 급여 합계를 조회하시오. (직급코드, 총급여합계 출력)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 문제 8. 
-- 각 부서코드별 평균 급여를 조회하되, 소수점은 버림(TRUNCATE) 처리하여 정수로 조회하시오.
SELECT DEPT_CODE, TRUNCATE(AVG(SALARY), 0)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 문제 9. 
-- 부서별 평균 급여가 300만 원 이상인 부서의 부서코드와 평균 급여를 조회하시오.
SELECT DEPT_CODE, TRUNCATE(AVG(SALARY), 0)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING TRUNCATE(AVG(SALARY) , 0) >= 3000000;

-- 문제 10. 
-- 2000년 1월 1일 이후 입사한 사원들을 대상으로 각 부서별 사원 수를 조회하시오.
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) >= 2000
GROUP BY DEPT_CODE;

-- 문제 11. 
-- 소속된 사원이 3명 이상인 직급코드와 사원 수를 조회하시오.
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING COUNT(*) >= 3;

-- 문제 12.
-- 부서코드와 직급코드가 모두 같은 사원들의 그룹별 사원 수를 조회하시오. (부서코드, 직급코드, 사원수 출력)
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE;

-- 문제 13. 
-- 각 부서별 최고 급여액이 400만 원 이상인 부서코드와 그 부서의 최고 급여액을 조회하시오.
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING MAX(SALARY) >= 4000000;

-- 문제 14. 
-- 각 부서별 사원 수, 총 급여 합계, 그리고 그 부서 내 최고급여와 최저급여의 차액(MAX - MIN)을 조회하시오. 
-- (컬럼명: 부서코드, 사원수, 총급여합, 급여차액)
SELECT DEPT_CODE AS '부서코드', COUNT(*) AS '사원 수', SUM(SALARY) AS '총 급여 합', (MAX(SALARY) - MIN(SALARY)) AS '급여 차액'
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 문제 15.
-- 사원번호(주민번호 앞자리 활용)를 기준으로 '남자' 사원들만 대상으로 각 부서별 평균 급여를 구하시오. 
-- 이때, 평균 급여가 250만 원 이상인 부서만 조회하고, 결과는 평균 급여 내림차순으로 정렬하시오.
-- (힌트: SUBSTRING(EMP_NO, 8, 1) IN ('1', '3') 사용)
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE SUBSTRING(EMP_NO, 8, 1) IN ('1', '3')
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 2500000
ORDER BY AVG(SALARY) DESC;