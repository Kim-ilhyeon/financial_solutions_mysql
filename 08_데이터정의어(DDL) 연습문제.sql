use ddltdb;
-- 문제 1. (테이블 생성 - 기본)
-- 부서 정보를 저장할 TB_DEPT 테이블을 생성하시오.
-- 컬럼: DEPT_CD (정수형, 기본키), DEPT_NAME (가변문자 30자, NOT NULL)
DROP TABLE IF EXISTS TB_DEPT;
CREATE TABLE TB_DEPT(
	DEPT_CD INT PRIMARY KEY COMMENT '부서코드', 
    DEPT_NAME VARCHAR(30) NOT NULL COMMENT '부서명'
);

-- 문제 2. (테이블 생성 - 외래키 및 CHECK)
-- 사원 정보를 저장할 TB_EMP 테이블을 생성하시오.
-- 컬럼: EMP_NO (정수형, 기본키), EMP_NAME (가변문자 20자, NOT NULL), 
--       GENDER (고정문자 1자, 'M' 또는 'F'만 허용하도록 CHECK 제약조건 설정),
--       DEPT_CD (정수형, TB_DEPT 테이블의 DEPT_CD를 참조하는 외래키 설정)
DROP TABLE IF EXISTS TB_EMP;
CREATE TABLE TB_EMP(
	EMP_NO INT PRIMARY KEY COMMENT '사원번호', 
    EMP_NAME VARCHAR(20) NOT NULL COMMENT '사원명',
    GENDER VARCHAR(1) CHECK(GENDER IN ('M', "F")) COMMENT '성별(M/F)',
    DEPT_CD INT COMMENT '부서코드',
    FOREIGN KEY(DEPT_CD) REFERENCES TB_DEPT(DEPT_CD)
);

-- 문제 3. (ALTER - 컬럼 추가)
-- TB_EMP 테이블에 전화번호를 저장할 PHONE 컬럼(가변문자 15자)을 추가하시오.
ALTER TABLE TB_EMP ADD PHONE VARCHAR(15);

-- 문제 4. (ALTER - 컬럼 수정)
-- TB_EMP 테이블의 EMP_NAME 컬럼의 크기를 가변문자 50자로 늘리고, NOT NULL 조건을 유지하도록 수정하시오.
ALTER TABLE TB_EMP MODIFY EMP_NAME VARCHAR(50) NOT NULL;

-- 문제 5. (ALTER - 컬럼명 변경)
-- TB_EMP 테이블의 PHONE 컬럼명을 CONTACT로 변경하시오.
ALTER TABLE TB_EMP RENAME COLUMN PHONE TO CONTACT;

-- 문제 6. (ALTER - 제약조건 추가)
-- TB_EMP 테이블의 CONTACT 컬럼에 중복된 값이 들어가지 못하도록 UNIQUE 제약조건을 추가하시오.
-- (제약조건 이름은 'uq_emp_contact' 로 지정할 것)
ALTER TABLE TB_EMP ADD CONSTRAINT uq_emp_contact UNIQUE(CONTACT);

-- 문제 7. (ALTER - 제약조건 삭제) ⭐ MySQL 주의
-- 문제 6에서 추가했던 UNIQUE 제약조건('uq_emp_contact')을 삭제하시오.
ALTER TABLE TB_EMP DROP INDEX uq_emp_contact;

-- 문제 8. (ALTER - DEFAULT 추가) ⭐ MySQL 주의
-- TB_EMP 테이블의 GENDER 컬럼에 기본값(DEFAULT)으로 'M'이 들어가도록 설정하시오.
SELECT * FROM TB_EMP;
ALTER TABLE TB_EMP MODIFY COLUMN GENDER VARCHAR(1) DEFAULT 'M';

-- 문제 9. (TRUNCATE - 데이터 초기화)
-- TB_EMP 테이블의 구조는 그대로 남겨두고, 안의 데이터만 초기화(빠른 전체 삭제) 하시오.
TRUNCATE TABLE TB_EMP;

-- 문제 10. (DROP - 테이블 안전 삭제)
-- 외래키(FK) 참조 관계 때문에 일반적인 삭제가 불가능한 상황이라고 가정하고, 
-- 외래키 검사를 잠시 끄고 TB_EMP와 TB_DEPT 테이블을 안전하게 모두 삭제한 뒤 검사를 다시 켜시오.
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS TB_EMP;
DROP TABLE IF EXISTS TB_DEPT;
SET FOREIGN_KEY_CHECKS = 1;

-- foreign key 제약조건명 확인용--
SELECT CONSTRAINT_NAME, TABLE_NAME, REFERENCED_TABLE_NAME 
FROM information_schema.REFERENTIAL_CONSTRAINTS;
-- ------------------------ --

-- 또는
-- ALTER TABLE TB_EMP DROP FOREIGN KEY tb_emp_ibfk_1;
-- DROP TABLE IF EXISTS TB_EMP;