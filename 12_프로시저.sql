/*
	프로시저
    : 데이터베이스 내에 쿼리문을 하나의 함수처럼 묶어서 저장해두고, 필요할 때 호출해서 사용하는 DB객체
    
    특징
    1. 재사용성 : 복잡한 로직을 한번 만들어두면 이름으로만 호출해서 반복 사용 가능하다.
    2.  성능 : 여러 개의 SQL문을 한번의 네트워크로 처리하기 때문에 속도가 빠르다
    3. 보안성 : 테이블에 직접 접근하는 권한을 주지않고, 프로시저 실행 권한만 주면 데이터를 안전하게 관리할 수 있다.
    4. 유지보수 : 로직을 DB에 모아두어 관리 편리하다.
    
    프로시저 사용 시 구분자(; -> //)를 먼저 변경해야 한다.
    ;을 만나면 SQL을 즉시 실행함. 프로시저 내부에는 여러 개의 ;이 들어가야 한다.
    그래서 프로시저를 만드는 동안에 세미콜론을 만나도 실행이 되지 않기 위해 임시로 끝나는 구문자를 변경해야 한다.
    -> DELIMETER 구분자
*/

-- 기본적인 프로시저

-- 1. 시작 전 구분자 변경 세미콜론(;) -> //로 변경
DELIMITER //

-- 2. 프로시저 생성
CREATE PROCEDURE pro_all_emp()
BEGIN
		-- 내부에서 자유롭게 SQL문을 사용
	SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
    FROM EMPLOYEE;
    
END //

-- 3. 생성 후 구분자 다시 복원 // -> 세미콜론(;)으로 변경
DELIMITER ;

-- 저장된 프로시저 호출 방법
-- CALL 프로시저명()

CALL PRO_ALL_EMP();

-- 프로시저 삭제 방법
-- DROP PROCEDURE IF EXISTS 프로시저명;
DROP PROCEDURE IF EXISTS PRO_ALL_EMP;

/*
	매개 변수가 있는 프로시저
    : 외부에서 값을 전달받아 쿼리에 사용하는 방법
*/

DELIMITER //

CREATE PROCEDURE PRO_SAL_RAISE(
	IN P_DEPT_CODE VARCHAR(3), 
    IN P_RAISE_RATE DECIMAL(3, 2)
)
BEGIN
	UPDATE EMPLOYEE
    SET SALARY = SALARY * (1 + P_RAISE_RATE)
    WHERE DEPT_CODE = P_DEPT_CODE;
    
    SELECT EMP_NAME, DEPT_CODE, SALARY
    FROM EMPLOYEE
    WHERE DEPT_CODE = P_DEPT_CODE;
END //

DELIMITER ;

CALL PRO_SAL_RAISE('D5', 0.1);

/*
	반환값이 있는 프로시저
*/
DELIMITER //

CREATE PROCEDURE PRO_EMP_COUNT(
	IN P_DEPT_CODE VARCHAR(3), 
    OUT P_EMP_COUNT INT
)
BEGIN
	SELECT COUNT(*)
    INTO P_EMP_COUNT
    FROM EMPLOYEE
    WHERE DEPT_CODE = P_DEPT_CODE;
END //

DELIMITER ;

CALL PRO_EMP_COUNT('D5', @res_count);

SELECT @res_count AS 'DEPT_EMP_COUNT';

/*
	제어문 (IF ~ THEN ~ ELSE) 사용 가능 프로시저
*/

-- 보너스를 지급받는 사원인지 확인 후
-- 보너스를 받는 사람이면 ~~~사원의 보너스율은 ~입니다.
-- 보너스를 받지 않는 사람이면 ~~~사원은 보너스 지급대상이 아닙니다.
DELIMITER //

CREATE PROCEDURE PRO_CHECK_BONUS(
	IN P_EMP_ID VARCHAR(3)
)
BEGIN
	-- 프로시저 내부에서 사용할 지역변수는 DECLARE로 선언 가능
    DECLARE V_BONUS DECIMAL(3, 2);
    DECLARE V_EMP_NAME VARCHAR(20);

	SELECT EMP_NAME, BONUS
    INTO V_EMP_NAME, V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
    
    IF V_BONUS IS NULL
		THEN SELECT CONCAT('"', V_EMP_NAME, '"사원은 보너스 지급대상이 아닙니다.') AS RESULT;
	ELSE 
		SELECT CONCAT('"', V_EMP_NAME, '"사원의 보너스율은' , V_BONUS, '입니다') AS RESULT;
	END IF;
    /*
		IF 조건
			THEN 조건 만족 시 실행할 코드
		ELSE
			불만족 시 실행할 코드
		END IF;
    */
END//

DELIMITER ;

CALL PRO_CHECK_BONUS(200);
CALL PRO_CHECK_BONUS(201);
CALL PRO_CHECK_BONUS(209);

/*
	프로시저 반복문 (WHILE)
*/

CREATE TABLE IF NOT EXISTS TEST_LOOP_TB(
	ID INT AUTO_INCREMENT PRIMARY KEY, 
    MEMO VARCHAR(50)
);

DELIMITER //
CREATE PROCEDURE PRO_INSERT_DUMMY(
	IN P_COUNT INT
)
BEGIN 
	-- 반복에 사용할 변수(초기값) 생성
    DECLARE V_COUNT INT DEFAULT 1;
    
    -- 반복문을 통해서 P_COUNT만큼 더미데이터를 추가
    WHILE V_COUNT <= P_COUNT DO
    
		-- 반복해서 실행할 코드
		INSERT INTO TEST_LOOP_TB(MEMO)
        VALUES (CONCAT('더미데이터 : ', V_COUNT));
        
        -- 반복 종료를 위한 증감식
        SET V_COUNT = V_COUNT + 1;
	END WHILE;	-- 반복문 종료
    /*
		WHILE 조건 DO
			반복할 코드
		END WHILE;
    */
    SELECT CONCAT(P_COUNT, '개의 더미데이터 추가 완료') AS MSG;
END //
DELIMITER ;

CALL PRO_INSERT_DUMMY(100);

SELECT * FROM TEST_LOOP_TB;

/*
	프로시저를 예외 처리, 트랜잭션을 함께 사용하는 경우가 많음
    -> 프로시저 도중 에러가 발생하면 전부 롤백하거나 커밋하여야 하기 때문에
    
    예외처리
    DECLARE 처리방식 HANDLER FOR 예외조건
    BEGIN 
		-- 예외 발생 시 실행할 대체쿼리
	END;
    
    
    처리방식 : EXIT(종료), CONTINUE(에러가 발생한 다음줄부터 다시 시작)
    
    예외조건 : SQLException(문법 오류), SQLWarning(오류는 아닌 경고 수준), NOT FOUND(결과 값 없음)
*/
DELIMITER //
CREATE PROCEDURE PRO_SAFE_TRANSFER()
BEGIN 
	-- 만약 DB에러(SQLException)가 발생하면 특정 코드를 실행하고 종료. (EXIT)
    DECLARE EXIT HANDLER FOR SQLException
    BEGIN
		ROLLBACK;
        SELECT '오류가 발생해서 모두 RollBack처리함' AS 'MSG';
	END;
    
    -- 트랜잭션 시작
    START TRANSACTION;
    
    DELETE FROM EMPLOYEE WHERE EMP_ID = 200;
    INSERT INTO DEPARTMENT VALUES ('D10', '에러관리부', 'L1');	-- 고의적 에러발생
    
    COMMIT;
    
    SELECT '모든 작업 완료 후 COMMIT' AS MSG;
END //
DELIMITER ;

CALL PRO_SAFE_TRANSFER();

SELECT * FROM EMPLOYEE WHERE EMP_ID = 200;

