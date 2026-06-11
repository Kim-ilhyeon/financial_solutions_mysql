-- =====================================================
-- ORDER BY / GROUP BY / HAVING 연습문제 Ver.2
-- =====================================================

-- 문제 1.
-- 사원명, 급여를 조회하시오.
-- 급여가 높은 순으로 정렬하고,
-- 급여가 같으면 사원명 오름차순으로 정렬하시오.
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC, EMP_NAME;



-- 문제 2.
-- 사원명, 입사일을 조회하시오.
-- 입사일이 오래된 순(오름차순)으로 정렬하시오.
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE;



-- 문제 3.
-- 사원명, 보너스율을 조회하시오.
-- 보너스율이 높은 순으로 정렬하되,
-- NULL 값은 가장 마지막에 출력하시오.
SELECT EMP_NAME, BONUS
FROM EMPLOYEE
ORDER BY BONUS IS NULL, BONUS DESC;



-- 문제 4.
-- 사원명, 급여, 연봉(SALARY * 12)을 조회하시오.
-- 연봉이 낮은 순으로 정렬하시오.
-- (ORDER BY에서 별칭 사용)
SELECT EMP_NAME, SALARY, (SALARY * 12) AS '연봉'
FROM EMPLOYEE
ORDER BY 연봉;


-- 문제 5.
-- 사원명, 부서코드, 입사일을 조회하시오.
-- 부서코드 오름차순,
-- 입사일 내림차순으로 정렬하시오.
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
ORDER BY DEPT_CODE, HIRE_DATE DESC;



-- =====================================================
-- GROUP BY
-- =====================================================

-- 문제 6.
-- 각 부서별 사원 수를 조회하시오.
--
-- 출력
-- 부서코드
-- 사원수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;



-- 문제 7.
-- 각 직급별 평균 급여를 조회하시오.
--
-- 출력
-- 직급코드
-- 평균급여
--
-- 평균급여는 소수점 버림 처리
SELECT JOB_CODE, TRUNCATE(AVG(SALARY), 0)
FROM EMPLOYEE
GROUP BY JOB_CODE;



-- 문제 8.
-- 각 부서별 최고 급여를 조회하시오.
--
-- 출력
-- 부서코드
-- 최고급여
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;


-- 문제 9.
-- 각 부서별 최저 급여를 조회하시오.
--
-- 출력
-- 부서코드
-- 최저급여
SELECT DEPT_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;



-- 문제 10.
-- 각 부서별 급여 총합을 조회하시오.
--
-- 출력
-- 부서코드
-- 총급여
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;



-- =====================================================
-- HAVING
-- =====================================================

-- 문제 11.
-- 평균 급여가 300만원 이상인 부서만 조회하시오.
--
-- 출력
-- 부서코드
-- 평균급여
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;



-- 문제 12.
-- 사원 수가 2명 이상인 부서만 조회하시오.
--
-- 출력
-- 부서코드
-- 사원수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(*) >= 2;



-- 문제 13.
-- 최고 급여가 500만원 이상인 직급만 조회하시오.
--
-- 출력
-- 직급코드
-- 최고급여
SELECT JOB_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING MAX(SALARY) >= 5000000;



-- 문제 14.
-- 총 급여 합계가 1억 원 이상인 부서를 조회하시오.
--
-- 출력
-- 부서코드
-- 총급여
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) >= 100000000;


-- 문제 15.
-- 평균 보너스율이 0.2 이상인 부서를 조회하시오.
--
-- 출력
-- 부서코드
-- 평균보너스율
SELECT DEPT_CODE, AVG(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(BONUS) >= 0.2;



-- =====================================================
-- GROUP BY + 함수
-- =====================================================

-- 문제 16.
-- 입사년도별 사원 수를 조회하시오.
--
-- 출력
-- 입사년도
-- 사원수
--
-- 힌트
-- YEAR(HIRE_DATE)
SELECT YEAR(HIRE_DATE), COUNT(*)
FROM EMPLOYEE
GROUP BY YEAR(HIRE_DATE);



-- 문제 17.
-- 성별별 사원 수를 조회하시오.
--
-- 출력
-- 성별
-- 사원수
--
-- 조건
-- 주민번호 8번째 자리 사용
-- 1,3 = 남자
-- 2,4 = 여자
SELECT IF(SUBSTRING(EMP_NO, 8, 1) IN ('1', '3'), '남자', '여자') AS '성별', COUNT(*)
FROM EMPLOYEE
GROUP BY IF(SUBSTRING(EMP_NO, 8, 1) IN ('1', '3'), '남자', '여자');



-- 문제 18.
-- 이메일 도메인별 사원 수를 조회하시오.
--
-- 출력
-- 이메일도메인
-- 사원수
--
-- 힌트
-- SUBSTRING + LOCATE
SELECT SUBSTRING(EMAIL, LOCATE('@', EMAIL)+1), COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTRING(EMAIL, LOCATE('@', EMAIL)+1);



-- 문제 19.
-- 입사년도별 평균 급여를 조회하시오.
--
-- 출력
-- 입사년도
-- 평균급여
--
-- 평균급여는 소수점 버림 처리
SELECT YEAR(HIRE_DATE), TRUNCATE(AVG(SALARY), 0)
FROM EMPLOYEE
GROUP BY YEAR(HIRE_DATE);



-- 문제 20.
-- 성별별 평균 급여를 조회하시오.
--
-- 출력
-- 성별
-- 평균급여
--
-- 평균급여가 높은 순으로 정렬하시오.
SELECT IF(SUBSTRING(EMP_NO, 8, 1) IN ('1', '3'), '남자', '여자'), AVG(SALARY)
FROM EMPLOYEE
GROUP BY IF(SUBSTRING(EMP_NO, 8, 1) IN ('1', '3'), '남자', '여자')
ORDER BY AVG(SALARY) DESC;
