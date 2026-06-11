/*
	GROUP BY
    : 그룹 기준을 제시할 수 있는 구문
    여러 개의 개별 데이터(로우, 행)들을 하나의 그룹으로 묶어서 처리하는 목적
*/

-- 전체 사원의 급여 총합
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 각 부서별 급여 총합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 소속 사원 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 그룹 별 정렬
SELECT DEPT_CODE, COUNT(*), SUM(SALARY)	-- 3
FROM EMPLOYEE												-- 1
GROUP BY DEPT_CODE										-- 2
ORDER BY DEPT_CODE;										-- 4

-- GROUP BY절에서도 함수식 사용 가능 (그룹을 나누는 기준을 명확하게 제시)
-- 남녀별 사원 수 조회
SELECT IF(SUBSTRING(EMP_NO, 8, 1) IN ('1', '3'), '남', '여'),  COUNT(*)
FROM EMPLOYEE
GROUP BY IF(SUBSTRING(EMP_NO, 8, 1) IN ('1', '3'), '남', '여');

-- GROUP BY 절에도 여러 컬럼을 나열 가능
-- 여러 컬럼 나열 시 컬럼의 조합 자체가 그룹의 기준이 된다.
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

/*
	HAVING
    : 그룹에 대한 조건을 제시할 때 사용
    
*/



-- 각 부서별 평균 급여(부서코드, 평균급여)
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 부서별 평균급여가 300만원 이상인 부서만 조회
SELECT DEPT_CODE, AVG(SALARY)	-- 4
FROM EMPLOYEE								-- 1
WHERE SALARY >= 3000000					-- 2
GROUP BY DEPT_CODE;						-- 3
-- > 부서별 평균 급여가 아니라, 급여가 300만원 이상인 사람만 먼저 필터링 한 뒤에 그룹화를 시키기 때문에 모든 그룹이 다 300만원 이상이 되게 된다.

SELECT DEPT_CODE, AVG(SALARY) 	-- 4
FROM EMPLOYEE								-- 1
GROUP BY DEPT_CODE						-- 2
HAVING AVG(SALARY) >= 3000000;		-- 3

-- 직급별 총 급여 합이 1000만원 이상인 직급만 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- 부서별로 보너스를 받는 사원이 0명인 부서의 부서코드 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;














