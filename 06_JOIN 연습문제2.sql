-- =====================================================
-- JOIN 연습문제 Ver.1
-- =====================================================

-- 문제 1.
-- 사원명, 부서명을 조회하시오.
--
-- 출력
-- 사원명
-- 부서명
--
-- 힌트
-- EMPLOYEE, DEPARTMENT
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E
	JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);


-- 문제 2.
-- 사원명, 직급명을 조회하시오.
--
-- 출력
-- 사원명
-- 직급명
--
-- 힌트
-- EMPLOYEE, JOB
SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE);



-- 문제 3.
-- 사원명, 부서명, 직급명을 조회하시오.
--
-- 출력
-- 사원명
-- 부서명
-- 직급명
--
-- 힌트
-- EMPLOYEE, DEPARTMENT, JOB
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE);



-- 문제 4.
-- 사원명, 급여, 급여등급(SAL_LEVEL)을 조회하시오.
--
-- 출력
-- 사원명
-- 급여
-- 급여등급
--
-- 힌트
-- EMPLOYEE, SAL_GRADE
-- BETWEEN 사용
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE E
	JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);



-- 문제 5.
-- 사원명, 근무지역명(LOCAL_NAME)을 조회하시오.
--
-- 출력
-- 사원명
-- 지역명
--
-- 힌트
-- EMPLOYEE
-- DEPARTMENT
-- LOCATION
SELECT EMP_NAME, LOCAL_NAME
FROM EMPLOYEE E
	JOIN LOCATION L ON (



-- =====================================================
-- JOIN + 함수
-- =====================================================

-- 문제 6.
-- 사원명, 입사년도, 부서명을 조회하시오.
--
-- 출력
-- 사원명
-- 입사년도
-- 부서명
--
-- 힌트
-- YEAR(HIRE_DATE)



-- 문제 7.
-- 사원명, 이메일아이디, 직급명을 조회하시오.
--
-- 출력
-- 사원명
-- 이메일아이디
-- 직급명
--
-- 힌트
-- SUBSTRING
-- LOCATE



-- 문제 8.
-- 사원명, 연봉(SALARY * 12), 부서명을 조회하시오.
--
-- 출력
-- 사원명
-- 연봉
-- 부서명
--
-- 연봉 높은 순 정렬



-- 문제 9.
-- 사원명, 성별, 직급명을 조회하시오.
--
-- 출력
-- 사원명
-- 성별
-- 직급명
--
-- 조건
-- 주민번호 8번째 자리
-- 1,3 = 남자
-- 2,4 = 여자



-- 문제 10.
-- 사원명, 입사일, 국가명(NATIONAL_NAME)을 조회하시오.
--
-- 출력
-- 사원명
-- 입사일
-- 국가명
--
-- 힌트
-- EMPLOYEE
-- DEPARTMENT
-- LOCATION
-- NATIONAL



-- =====================================================
-- JOIN + GROUP BY
-- =====================================================

-- 문제 11.
-- 부서별 사원 수를 조회하시오.
--
-- 출력
-- 부서명
-- 사원수



-- 문제 12.
-- 직급별 평균 급여를 조회하시오.
--
-- 출력
-- 직급명
-- 평균급여
--
-- 평균급여 내림차순 정렬



-- 문제 13.
-- 국가별 사원 수를 조회하시오.
--
-- 출력
-- 국가명
-- 사원수
--
-- 힌트
-- EMPLOYEE
-- DEPARTMENT
-- LOCATION
-- NATIONAL



-- 문제 14.
-- 부서별 최고 급여를 조회하시오.
--
-- 출력
-- 부서명
-- 최고급여
--
-- 최고급여 내림차순 정렬



-- 문제 15.
-- 평균 급여가 300만원 이상인 부서를 조회하시오.
--
-- 출력
-- 부서명
-- 평균급여
--
-- 힌트
-- GROUP BY
-- HAVING