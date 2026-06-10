/*
	함수(Function)
    전달된 컬럼 값을 읽어서 함수(기능)를 실행한 결과를 반환
    - 단일행 함수 : N개의 값을 읽어서 N개의 결과 값을 반환 (행마다 실행 결과를 반환)
    - 그룹 함수 : N개의 값을 읽어서 1개의 결과 값을 반환 (그룹별로 함수 실행 결과를 반환)
*/

-- ------------ 단일행 함수 ------------
/*
	문자처리 함수
    CHAR_LENGTH(컬럼 | 문자열) : 해당 문자열의 글자수를 반환
    LENGTH(컬럼 | 문자열) : 해당 문자열의 바이트 수를 반환
    
    MYSQL (UTF-8 기준) 한글은 글자당 3바이트, 영어/숫자/특수문자는 1바이트를 사용
*/

SELECT CHAR_LENGTH('오라클'), LENGTH('오라클');
SELECT CHAR_LENGTH('ORACLE'), LENGTH('ORACLE');

SELECT 
    EMP_NAME, CHAR_LENGTH(EMP_NAME), LENGTH(EMP_NAME)
FROM
    EMPLOYEE;
    
/*
	INSTR / LOCATE
    문자열로부터 특정 문자의 시작위치를 찾아서 반환
    INSTR(문자열, '찾고자하는 문자')
    LOCATE('찾고자하는 문자', 문자열, [시작위치])
*/

SELECT INSTR('AACACBACACBAS', 'B');
SELECT LOCATE('C', 'AACACBACACBAS');
SELECT LOCATE('C', 'AACACBACACBAS', 4);

SELECT 
    EMAIL, LOCATE('@', EMAIL)
FROM
    EMPLOYEE;

/*
	SUBSTR / SUBSTRING
    문자열에서 특정 문자열을 주출해서 반환
    
	SUBSTRING(컬럼 | 문자열, 추출 시작위치, [추출 글자수])
*/
SELECT SUBSTR('SHOWMETHEMONEY', 7);
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2);
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6);
SELECT SUBSTR('SHOWMETHEMONEY', 7, 3);
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3);

SELECT SUBSTRING('SHOWMETHEMONEY', 7);
SELECT SUBSTRING('SHOWMETHEMONEY', 5, 2);
SELECT SUBSTRING('SHOWMETHEMONEY', 1, 6);
SELECT SUBSTRING('SHOWMETHEMONEY', 7, 3);
SELECT SUBSTRING('SHOWMETHEMONEY', -8, 3);

-- 사원들의 성별 판별
SELECT 
    EMP_NAME, EMP_NO, SUBSTRING(EMP_NO, 8, 1) AS '성별'
FROM
    EMPLOYEE;

-- 사원들 중 여자 사원들만 이름과 주민등록번호를 조회
SELECT 
    EMP_NAME, EMP_NO
FROM
    EMPLOYEE
WHERE
    SUBSTRING(EMP_NO, 8, 1) IN ('2' , '4');

-- 함수 중첩 사용 가능 (이메일 아이디 부분만 추출)
SELECT 
    EMP_NAME,
    EMAIL,
    SUBSTRING(EMAIL,
        1,
        (LOCATE('@', EMAIL) - 1)) AS '아이디'
FROM
    EMPLOYEE;

/*
	LPAD / RPAD
    문자열을 조회할 때 통일감 있게 조회하고자 정렬하는 함수
    
    LPAD/RPAD(문자열, 최종 반환 길이, [빈공간을 대체할 문자])
*/
-- LPAD / RPAD -> 대체 문자를 ''로 설정 시 더한 길이가 목표길이가 되지못해 무한반복을 이루기 때문에 자체적으로 아무것도 없는 값을 반환하게 됨. = 에러임
SELECT 
    EMAIL, LPAD(EMAIL, 30, '')
FROM
    EMPLOYEE;

-- 이메일을 동일하게 길이 30으로 출력
SELECT 
    EMAIL, LPAD(EMAIL, 30, '#')
FROM
    EMPLOYEE;

SELECT 
    EMAIL, RPAD(EMAIL, 30, '#')
FROM
    EMPLOYEE;

-- 사원들의 사원명, 주민등록 번호 블라인드 처리 (123456-1XXXXXX)
SELECT EMP_NAME, RPAD(SUBSTRING(EMP_NO, 1, 8), 14, 'X') AS '주민등록 번호'
FROM EMPLOYEE;

SELECT 
    EMP_NAME, CONCAT(SUBSTRING(EMP_NO, 1, 8), 'XXXXXX')
FROM
    EMPLOYEE;

/*
	LTRIM / RTRIM / TRIM
    문자열에서 특정 문자를 제거한 나머지를 반환
    
    LTRIM / RTRIM -> 공백만 제거 가능
    
    TRIM([LEADING | TRAILING | BOTH] 제거할 문자열 FROM 원본문자열)
*/
SELECT LTRIM('    K H    ');
SELECT RTRIM('    K H    ');

SELECT TRIM('    K H    ');	-- 기본적으로 양쪽의 공백 제거
SELECT TRIM(BOTH '#' FROM '####K#H####');
SELECT TRIM(LEADING '#' FROM '####K#H####');
SELECT TRIM(TRAILING '#' FROM '####K#H####');

/*
	LOWER / UPPER
    - LOWER : 모든 문자열을 소문자로 변경
    - UPPER : 모든 문자열을 대문자로 변경
*/

SELECT LOWER('Hello');
SELECT UPPER('Hello');

/*
	CONCAT / CONCAT_WS
    CONCAT : 2개 이상의 문자열을 하나로 합해서 반환
    CONCAT_WS : 지정한 구분자를 포함하여 합해서 반환
*/

SELECT CONCAT('자바', 'SQL', 'DB', 'WEB');
SELECT CONCAT_WS(', ', '자바', 'SQL', 'DB', 'WEB');
SELECT 
    CONCAT_WS('/', EMP_NAME, JOB_CODE, DEPT_CODE)
FROM
    EMPLOYEE;

/*
	REPLACE
    : 특정 문자열에서 특정 부분을 치환
    
    REPLACE(문자열, 타겟 문자, 치환할 문자)
*/
SELECT 
    EMAIL, REPLACE(EMAIL, 'kh.co.kr', 'gmail.com') AS EMAIL
FROM
    EMPLOYEE;

-- ---------------- 숫자처리 함수 ----------------
-- ABS : 절대 값 반환
SELECT ABS(-10), ABS(-20.5);

-- MOD : 나머지 값 반환
SELECT MOD(10, 4);
SELECT MOD(11.8, 2);

-- ROUND(숫자, 위치값) : 반올림/반내림하여 반환 (위치 값이 양수면 소숫점 뒤로, 음수면 소숫점 앞 정수부를 기준으로 하게됨)
SELECT ROUND(123.456);
SELECT ROUND(123.456, 1);	-- 소숫점 1번째 자리까지는 표시
SELECT ROUND(123.456, -1);	-- 소숫점 앞 정수부에서 반올림을 하겠다.

-- CEIL : 올림 / FLOOR : 버림
-- 따로 위치값 설정없이 무조건 소수점 기준
SELECT CEIL(123.456);
SELECT FLOOR(123.456);

-- TRUNCATE(숫자, 위치값) : 버림처리 함수 (자릿수 지정이 필수)
SELECT TRUNCATE(123.456, 0);
SELECT TRUNCATE(123.456, 1);
SELECT TRUNCATE(123.456, -1);

-- --------------- 날짜 처리 함수 ---------------
-- NOW() / SYSDATE() / CUDATE() : 현재 날짜 및 시간 반환

SELECT NOW(), SYSDATE();	-- 년 월 일 시 분 초
SELECT CURDATE();	-- 년 월 일

-- DATEDIFF(기준일, 뺼날짜) : 두 날짜 사이의 일 수 차이
SELECT 
    EMP_NAME, HIRE_DATE, DATEDIFF(NOW(), HIRE_DATE) AS '근무일 수'
FROM
    EMPLOYEE;

-- TIMESTAMPDIFF(단위, 뺼 날짜, 기준일) : 두 날짜 사이의 지정된 단위(년, 월, ...) 차이 반환
SELECT 
    EMP_NAME,
    HIRE_DATE,
    TIMESTAMPDIFF(MONTH, HIRE_DATE, NOW()) AS '근무월 수'
FROM
    EMPLOYEE;

SELECT 
    EMP_NAME,
    HIRE_DATE,
    TIMESTAMPDIFF(YEAR, HIRE_DATE, NOW()) AS '근무년 수'
FROM
    EMPLOYEE;

SELECT 
    EMP_NAME,
    HIRE_DATE,
    TIMESTAMPDIFF(DAY, HIRE_DATE, NOW()) AS '근무일 수'
FROM
    EMPLOYEE;

SELECT 
    EMP_NAME,
    HIRE_DATE,
    TIMESTAMPDIFF(WEEK, HIRE_DATE, NOW()) AS '근무주 수'
FROM
    EMPLOYEE;

-- DATE_ADD / DATE_SUB : 특정 날짜에 값을 더하거나 뺴는 함수
-- DATE_ADD(기준날짜, INTERVAL 값 단위)
SELECT DATE_ADD(NOW(), INTERVAL 7 MONTH);	-- 7개월 더하기
SELECT DATE_SUB(NOW(), INTERVAL 7 MONTH);	-- 7개월 빼기

-- 사원명, 수습기간 종료일
SELECT EMP_NAME, DATE_ADD(HIRE_DATE, INTERVAL 3 MONTH) AS '수습 종료일'
FROM EMPLOYEE;

-- LAST_DAY(날짜) : 해당 월의 마지막 날짜를 반환
SELECT LAST_DAY(NOW());

/*
	YEAR / MONTH / DAY
    : 특정 날짜의 년.월.일 값을 추출
*/
SELECT 
    EMP_NAME,
    HIRE_DATE,
    YEAR(HIRE_DATE),
    MONTH(HIRE_DATE),
    DAY(HIRE_DATE)
FROM
    EMPLOYEE;

--  ----------------- 형 변환 함수 -----------------
-- FORMAT(숫자, 소숫점 자릿수) : 숫자에 3자리마다 콤마(,)를 찍어 문자열로 반환
SELECT FORMAT(200000, 0);
SELECT FORMAT(200000, 3);

-- DATE_FORMAT(날짜데이터, 포멧형식) : 날짜타입 데이터를 원하는 형태의 문자열로 변환
-- %Y(4자리 연도), %y(2자리 연도), %M(2자리 월), %d(2자리 일), %H(24시간), %h(12시간), %i(분), %s(초)
SELECT DATE_FORMAT(NOW(), '%Y년 %M월 %d일 %h시 %i분 %s초');
SELECT DATE_FORMAT(NOW(), '%Y-%M-%d %h:%i:%s');

-- STR_TO_DATE(문자열, 문자열의 형식) : 문자열을 날짜 타입으로 변경
SELECT STR_TO_DATE('20260101', '%Y %m %d');
SELECT STR_TO_DATE('2026년 01월 01일 13시 32분 20초', '%Y년 %M월 %d일 %h시 %i분 %s초');


-- CAST(변환할 값 AS 변경할 데이터타입) : 표준 형 변환
-- UNSIGNED(양수), SIGNED(음수 포함 정수), CHAR(문자열), DATE(날짜), DATETIME(날짜 + 시간) . . .
SELECT CAST('1000' AS UNSIGNED);
SELECT CAST('2025-12-31' AS DATE);

-- -------------------------- NULL처리 함수 --------------------------
-- IFNULL(컬럼, NULL대체값) : NULL일 경우 대체 값으로 치환
SELECT 
    EMP_NAME, BONUS
FROM
    EMPLOYEE;

SELECT 
    EMP_NAME, IFNULL(BONUS, 0)
FROM
    EMPLOYEE;

-- COALESCE() : 입력받은 인자들 중에서 처음으로 NULL이 아닌 값을 반환
SELECT COALESCE(NULL, NULL, '대체값', '두번째값');
SELECT 
    EMP_NAME, COALESCE(BONUS, 0)
FROM
    EMPLOYEE;

-- NULLIF(비교대상1, 비교대상2) : 두 값이 일치하면 NULL, 불일치 비교대상1 반환
SELECT NULLIF('123', '123');
SELECT NULLIF('123', '456');

-- -------------------- 조건분기 함수 --------------------
-- IF(조건, 참일때 결과, 거짓일때 결과)
SELECT 
    EMP_NAME, BONUS, IF(BONUS IS NOT NULL, 'O', 'X') AS ISBONUS
FROM
    EMPLOYEE;

-- 사원들 성별 판별
SELECT 
    EMP_NAME,
    EMP_NO,
    IF(SUBSTRING(EMP_NO, 8, 1) IN ('1' , '3'),
        '남',
        '여') AS '성별'
FROM
    EMPLOYEE;

/*
	CASE문 : 복잡한 다중 조건처리 시 사용
    
    CASE 
		WHEN 조건1 THEN 결과1
        WHRN 조건2 THEN 결과2
		. . .
        ELSE 기본 결과
	END
*/
-- 급여 수준에 따른 직급 분류 (if문처럼 사용)
SELECT EMP_NAME, SALARY, 
	CASE
		WHEN SALARY >= 5000000 THEN '시니어'
        WHEN SALARY >= 3500000 THEN '미들'
        ELSE '주니어'
	END AS '등급'
FROM EMPLOYEE;

-- 직급별 차등 급여인상 (switch문처럼 사용)
SELECT EMP_NAME, JOB_CODE, SALARY, 
	CASE JOB_CODE
		WHEN 'J7' THEN SALARY * 1.1
        WHEN 'J6' THEN SALARY * 1.15
        ELSE SALARY * 1.2
	END AS '인상 후'
FROM EMPLOYEE;

-- ------------------ 그룹 함수 ------------------
-- 특정 그룹에 함수를 적용해서 하나의 결과를 반환

-- SUM(컬럼) : 총 합계
SELECT 
    SUM(SALARY)
FROM
    EMPLOYEE;

-- 남자사원들의 총 급여
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTRING(EMP_NO, 8, 1) IN ('1', '3');

-- AVG(컬럼) : 평균
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- MIN(컬럼) : 최솟값
SELECT MIN(SALARY)
FROM EMPLOYEE;

-- MAX(컬럼) : 최댓값
SELECT MAX(SALARY)
FROM EMPLOYEE;

SELECT AVG(SALARY), MIN(EMP_NAME), MAX(HIRE_DATE)
FROM EMPLOYEE;

-- COUNT(* | 컬럼 | DISTINCT 컬럼) : 행의 갯수
-- COUNT(*) : NULL포함 모든 행의 갯수
-- COUNT(컬럼) : 해당컬럼이 NULL이 아닌 데이터의 갯수
-- COUNT(DISTINCT 컬럼) : 고유한 컬럼값의 갯수

-- 전체 사원 수
SELECT COUNT(EMP_NAME)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE;

SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- 보너스를 받지 않는사람
SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- 부서의 종류 갯수
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- SELECT문의 기본 실행 순서
/*
	SELECT 컬럼, 컬럼...		-- 3
    FROM 테이블명				-- 1
    WHERE 조건식;				-- 2
*/
