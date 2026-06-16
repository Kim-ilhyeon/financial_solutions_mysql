-- 실습1 : 사원의 이름, 부서명, 직급명을 조회할 수 있는 vw_emp_info 뷰를 생성
CREATE OR REPLACE VIEW vw_emp_info AS
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE);

-- 실습2 : 부서별 인원 수와 평균 급여를 조회하는 vw_dept_summary 뷰를 생성하고, 인원 수가 3명 이상인 부서만 조회
CREATE OR REPLACE VIEW vw_dept_summary AS
SELECT 
	COUNT(*) AS 'COUNT', 
	AVG(SALARY) AS 'avg_sal'
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT *
FROM vw_dept_summary
WHERE COUNT >= 3;

-- 실습3 : 급여 400만원 이상인 사원만 보이는 vw_high_salary 뷰를 WITH CHECK OPTION으로 생성하고, 급여를 300만원으로 수정 (오류 확인)
CREATE OR REPLACE VIEW vw_high_salary AS
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000
WITH CHECK OPTION;
