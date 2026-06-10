use tdb;
-- 1. 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
SELECT 
    emp_name, hire_date
FROM
    employee
WHERE
    emp_name LIKE '%연';

-- 2. 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT 
    emp_name, phone
FROM
    employee
WHERE
    phone NOT LIKE '010%';

-- 3. 이름에 '하'가 포함되어있고 급여가 240만원 이상인 사원들의 사원명, 급여 조회
SELECT 
    emp_name, salary
FROM
    employee
WHERE
    emp_name LIKE '%하%'
        AND salary >= 2400000;

-- 4. 부서(DEPARTMENT) 테이블에서 해외영업부서인 부서들의 부서코드, 부서명 조회
SELECT 
    dept_id, dept_title
FROM
    department
WHERE
    dept_title LIKE '해외영업%';

-- 5. 사수(MANAGER)가 없고 부서배치도 받지 않은 사원들의 사원명, 사번, 부서코드 조회
SELECT 
    emp_name, emp_id, dept_code
FROM
    employee
WHERE
    manager_id IS NULL AND dept_code IS NULL;

-- 6. 연봉(급여 * 12)이 3천만원 이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회
SELECT 
    emp_id, emp_name, salary, bonus
FROM
    employee
WHERE
    (salary * 12) >= 30000000
        AND bonus IS NULL;

-- 7. 입사일이 '1995-01-01' 이상이고 부서배치를 받지 않은 사원들의 사번, 사원명, 입사일, 부서코드 조회
SELECT 
    emp_id, emp_name, hire_date, dept_code
FROM
    employee
WHERE
    hire_date >= '1995-01-01'
        AND dept_code IS NULL;

-- 8. 급여가 200만원 이상 500만원 이하이면서 입사일이 '2001-01-01' 이상이고 보너스를 받지 않는 사원 조회
SELECT 
    *
FROM
    employee
WHERE
    salary BETWEEN 2000000 AND 5000000
        AND hire_date >= '2001-01-01'
        AND bonus IS NULL;

-- 9. 보너스를 포함한 연봉((SALARY + (SALARY * BONUS)) * 12)이 NULL이 아니고 이름에 '하'가 포함된 사원 조회
SELECT 
    *
FROM
    employee
WHERE
    ((salary + (salary * bonus)) * 12) IS NOT NULL
        AND emp_name LIKE '%하%';

-- 10. 사원명(이름)이 '이'로 시작하거나 '연'으로 끝나는 사원들의 사번, 사원명 조회
SELECT 
    emp_id, emp_name
FROM
    employee
WHERE
    emp_name LIKE '이%' OR emp_name LIKE '%연';

-- 11. 부서코드가 'D1', 'D2', 'D3' 중 하나이면서, 사수(MANAGER)가 배정되어 있는 사원들의 사원명, 직급코드, 부서코드, 관리자사번 조회
SELECT 
    emp_name, job_code, dept_code, manager_id
FROM
    employee
WHERE
    dept_code IN ('D1' , 'D2', 'D3')
        AND manager_id IS NOT NULL;

-- 12. 급여가 250만 원 이상 350만 원 이하인 사원 중에서, 직급코드(JOB_CODE)가 'J3'가 아닌 사원들의 사원명, 급여, 직급코드 조회
SELECT 
    emp_name, salary, job_code
FROM
    employee
WHERE
    salary BETWEEN 2500000 AND 3500000
        AND job_code <> 'J3';

-- 13. 2000년 1월 1일 이전에 입사한 사원들의 사원명, 입사일, 실수령 월급(기본급 + 보너스 금액) 조회 (단, 보너스가 없는 사원은 0으로 계산할 것)
-- select emp_name, ifnull((salary + (salary * bonus)) * 12, 0) AS '실수령 월급(기본급 + 보너스 금액)'
select emp_name, salary + (salary * ifnull(bonus, 0)) as '실수령 월급'
from employee
where hire_date < '2000-01-01';

-- 14. 전화번호 중간에 '666'이 포함되고, 부서코드가 'D9' 또는 'D6'인 사원들의 사원명, 전화번호, 부서코드 조회
select emp_name, phone, dept_code
from employee
where phone LIKE '%666%' AND dept_code IN ('D9', 'D6');

-- 15. 이메일(EMAIL) 주소에 'kh.co.kr'이 포함된 사원들 중, 급여가 300만원 이상인 사원들의 사원명, 이메일, 급여를 조회
select emp_name, email, salary
from employee
where email LIKE '%kh.co.kr%' AND salary >= 3000000;