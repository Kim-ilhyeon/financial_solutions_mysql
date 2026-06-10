-- 문제 1. 
-- 사원들의 사원명, 사원명의 글자 수, 이메일의 바이트(Byte) 수를 조회하시오.
SELECT EMP_NAME, CHAR_LENGTH(EMP_NAME), LENGTH(EMAIL)
FROM EMPLOYEE;

-- 문제 2. 
-- 사원들의 사원명과 주민등록번호의 생년월일(앞 6자리)만 추출하여 '생년월일'이라는 별칭으로 조회하시오.
SELECT EMP_NAME, SUBSTRING(EMP_NO, 1, 6) AS '생년월일'
FROM EMPLOYEE;

-- 문제 3. 
-- CONCAT_WS 함수를 사용하여 사원들의 사원명과 이메일을 "이름 - 이메일" 형식으로 결합하여 조회하시오.
SELECT CONCAT_WS(' - ', EMP_NAME, EMAIL)
FROM EMPLOYEE;

-- 문제 4. 
-- 사원들의 사원명과 1일 급여(SALARY / 30)를 조회하되, 소수점 첫째 자리에서 버림(TRUNCATE)하여 정수로 표기하시오.
SELECT EMP_NAME, TRUNCATE((SALARY / 30), 1)
FROM EMPLOYEE;

-- 문제 5. 
-- 입사년도가 2000년 이상인 사원들의 사원명, 입사일, 정직원 전환일(입사일 기준 6개월 뒤)을 조회하시오.
SELECT EMP_NAME, HIRE_DATE, DATE_ADD(HIRE_DATE, INTERVAL 6 MONTH) AS '정직원 전환일'
FROM EMPLOYEE;

-- 문제 6. 
-- 사원들의 사원명, 급여, 입사일을 조회하시오. 
-- 단, 급여는 3자리마다 콤마를 찍고, 입사일은 'YYYY년 MM월 DD일' 형식의 문자열로 변환하시오.
SELECT EMP_NAME, FORMAT(SALARY, 0), DATE_FORMAT(HIRE_DATE, '%Y년 %m월 %d일')
FROM EMPLOYEE;

-- 문제 7. 
-- 사원들의 사원명과 관리자사번(MANAGER_ID)을 조회하되, 관리자가 없는 경우 '관리자 없음'으로 출력하시오.
SELECT EMP_NAME, IFNULL(MANAGER_ID, '관리자 없음')
FROM EMPLOYEE;

-- 문제 8. 
-- 사원들의 사원명, 보너스를 조회하고 보너스율이 0.2 이상이면 '우수', 그 미만이거나 NULL이면 '일반'으로 '보너스평가'를 조회하시오.
SELECT EMP_NAME, IF(BONUS >= 0.2, '우수', '일반') AS '보너스 평가'
FROM EMPLOYEE;

-- 문제 9.
-- 사원명, 입사일, '근무형태'를 조회하시오. 
-- '근무형태'는 입사년도가 2000년 이전이면 '창립멤버', 2000년~2010년이면 '핵심멤버', 2011년 이후면 '신규멤버'로 분류하시오.
SELECT EMP_NAME, HIRE_DATE, 
		CASE
			WHEN HIRE_DATE < '2000-01-01' THEN '창립멤버'
            WHEN HIRE_DATE BETWEEN '2000-01-01' AND '2010-12-31' THEN '핵심멤버'
            ELSE '신규멤버'
		END AS '근무형태'
FROM EMPLOYEE;

-- 문제 10. 
-- 전체 사원 중 보너스를 받는 사원의 수(COUNT)와, 이들에게 지급되는 총 보너스 금액 합계(SUM(SALARY * BONUS))를 조회하시오
SELECT COUNT(BONUS), SUM(SALARY * BONUS)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;
