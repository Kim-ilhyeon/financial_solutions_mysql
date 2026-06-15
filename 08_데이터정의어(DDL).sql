/*
	DDL (Data Definition Language) : 데이터 정의어
    - SQL 명령어 중에서 데이터를 저장할 객체의 구조를 정의하거나 변경하는 명령어
    (즉, 실제 데이터 값이 아닌 테이블 구조의 규칙을 정의하는 명령어
    
    객체 : 테이블(table), 뷰(view), 인덱스(index), 프로시저(procedure), 트리거(trigger) 등 . . . 
    
    DDL 명령어 : CREATE(생성), ALTER(수정), DROP(삭제), TRUNCATE(초기화)
*/

/*
	1. 테이블 생성 : CREATE TABLE
    - 행과 열로 구성된 가장 기본적인 데이터베이스 구조
    - 모든 데이터는 테이블을 통해 지정되고, 관리됨.
    
    CREATE TABLE 테이블명(
		컬럼명 자료형(크기) [제약조건], 
        컬럼명 자료형(크기) [제약조건], 
        컬럼명 자료형(크기) [제약조건], 
        . . .
    )
    
    자료형(DBMS마다 명칭이 조금씩 다름)
    - 정수 : int
    - 실수 : decimal
    - 고정길이 문자 : char(글자 수) => 최대 255글자, 고정된 크기
    - 가변길이 문자 : varchar(글자 수) => 가변적인 변경이 가능한 크기
    - 긴 문자열 : text, longtext
    - 날짜/시간 : date(년-월-일), datetime(년-월-일 시:분:초), timestamp(년-월-일 시:분:초, UTC기반)
    
    
*/
use ddltdb;
CREATE TABLE MEMBER(
	member_no INT COMMENT '회원번호',
    member_id VARCHAR(30) COMMENT '회원아이디',
    member_pwd VARCHAR(30) COMMENT '회원비밀번호',
    member_name VARCHAR(21) COMMENT '회원이름',
    gender CHAR(3) COMMENT '성별(남/여)',
    phone VARCHAR(13) COMMENT '전화번호',
    email VARCHAR(50) COMMENT '이메일', 
    create_at DATETIME COMMENT '회원가입일', 
    update_at DATETIME COMMENT '회원수정일'
) COMMENT = '회원 기본 정보 테이블';

-- 생성된 테이블 구조를 확인하는 명령어
SHOW FULL COLUMNS FROM MEMBER;

-- 테스트 데이터를 삽입
INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								'홍길동', 
								'남', 
								'010-1111-2222', 
								'aaa@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
SELECT * FROM MEMBER;

-- 제약조건이 없어서 중요컬럼에 NULL값이 들어가거나 식별자 컬럼에 중복값이 들어가는 등 데이터의 무결성을 보장하지 못하고 있다.
-- > 의도하는 방식대로 데이터가 저장되고 있지 않다.
INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								NULL, 
								NULL, 
								'010-1111-2222', 
								NULL, 
								NULL, 
                                NULL
								);           
SELECT * FROM MEMBER;

-- -------------------------------------------------------------
/*
	제약 조건 : CONSTRANINTS
    - 원하는 데이터 값만 유지하기위해 특정 컬럼에 설정하는 규칙.
    - 데이터 무결성 보장을 목적으로 함. (정확성, 일관성, 신뢰성 유지)
    
    종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
*/

/*
	NOT NULL 제약조건
    : 해당 컬럼에 반드시 값이 존재해야 한다. -> NULL이 허용되지 않는다.
*/
DROP TABLE IF EXISTS member;

CREATE TABLE MEMBER(
	member_no INT NOT NULL COMMENT '회원번호',
    member_id VARCHAR(30) NOT NULL COMMENT '회원아이디',
    member_pwd VARCHAR(30) NOT NULL COMMENT '회원비밀번호',
    member_name VARCHAR(21) NOT NULL COMMENT '회원이름',
    gender CHAR(3) NOT NULL COMMENT '성별(남/여)',
    phone VARCHAR(13) COMMENT '전화번호',
    email VARCHAR(50) COMMENT '이메일', 
    create_at DATETIME COMMENT '회원가입일', 
    update_at DATETIME COMMENT '회원수정일'
) COMMENT = '회원 기본 정보 테이블';

-- 오류 발생 : member_name컬럼은 NOT NULL이므로 에러가 나면서 데이터 추가가 차단됨.
INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								NULL, 
								NULL, 
								'010-1111-2222', 
								NULL, 
								NULL, 
                                NULL
								);   

INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								'홍길동', 
								'남', 
								'010-1111-2222', 
								'aaa@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
SELECT * FROM MEMBER;

-- -------------------------------------------------------
/*
	UNIQUE 제약 조건
    : 해당 컬럼에 중복된 값이 들어가지 못하게 제한.
    단, NULL은 중복을 허용. (NULL은 데이터가 없는 상태이므로 UNIQUE 제약조건이 있어도 여러개를 허용함)
    
    [제약조건명 부여 문법]
    - 컬럼 레벨 방식 : 컬럼명 타입 제약조건
    - 테이블 레벨 방식 : 컬럼정의를 끝낸 후, 제약조건(컬럼명) ex) UNIQUE(email)
*/
DROP TABLE IF EXISTS member;

CREATE TABLE MEMBER(
	member_no INT NOT NULL UNIQUE COMMENT '회원번호',
    member_id VARCHAR(30) NOT NULL UNIQUE COMMENT '회원아이디',
    member_pwd VARCHAR(30) NOT NULL COMMENT '회원비밀번호',
    member_name VARCHAR(21) NOT NULL COMMENT '회원이름',
    gender CHAR(3) NOT NULL COMMENT '성별(남/여)',
    phone VARCHAR(13) COMMENT '전화번호',
    email VARCHAR(50) COMMENT '이메일', 
    create_at DATETIME COMMENT '회원가입일', 
    update_at DATETIME COMMENT '회원수정일',
    UNIQUE(email)
) COMMENT = '회원 기본 정보 테이블';

INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								'홍길동', 
								'남', 
								'010-1111-2222', 
								'aaa@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
SELECT * FROM MEMBER;

-- 오류발생 : member_no가 기존데이터와 중복되므로 UNIQUE제약조건 위반 에러 발생.
INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								'홍길동', 
								'남', 
								'010-1111-2222', 
								'aaa@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
SELECT * FROM MEMBER;

-- --------------------------------------------------------
/*
	CHECK 제약조건
    : 컬럼에 들어올 수 있는 값의 범위나 조건을 직접 지정한다.
    
    * 예전 mySQL에서는 CHECK 제약조건을 무시함.
    -> enum타입사용으로 대체
    
    enum : 미리 정해둔 문자열 값 중 오직 하나만 넣을 수 있는 데이터타입
    -> 간단하다는 장점이 있지만, 컬럼타입의 수정이 어렵다는 치명적인 단점이 있다.
*/
DROP TABLE IF EXISTS member;

CREATE TABLE MEMBER(
	member_no INT NOT NULL UNIQUE COMMENT '회원번호',
    member_id VARCHAR(30) NOT NULL UNIQUE COMMENT '회원아이디',
    member_pwd VARCHAR(30) NOT NULL COMMENT '회원비밀번호',
    member_name VARCHAR(21) NOT NULL COMMENT '회원이름',
    -- gender enum('남', '여') NOT NULL COMMENT '성별(남/여)',
    gender CHAR(3) CHECK(gender IN ('남', '여')) NOT NULL COMMENT '성별(남/여)',
    phone VARCHAR(13) COMMENT '전화번호',
    email VARCHAR(50) COMMENT '이메일', 
    create_at DATETIME COMMENT '회원가입일', 
    update_at DATETIME COMMENT '회원수정일',
    UNIQUE(email)
    -- CHECK(gender IN ('남', '여'))
) COMMENT = '회원 기본 정보 테이블';

INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								'홍길동', 
								'남', 
								'010-1111-2222', 
								'aaa@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
SELECT * FROM MEMBER;

-- 오류발생 : gender가 CHECK(gender IN ('남', '여'))제약조건 위반 에러 발생. ('남','여'만 추가가능)
INSERT INTO 
	MEMBER VALUES(2, 
								'user02', 
								'pass01', 
								'홍길동', 
								'무', 
								'010-1111-2222', 
								'aaa@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
SELECT * FROM MEMBER;

-- ---------------------------------------------------------------
/*
	PRIMARY KEY(PK) : 기본키 제약조건
    : 테이블에서 각 행을 식별하기위해 지정하는 컬럼.
    (여러 개의 식별가능한 컬럼(후보키) 중 딱 하나만 지정해서 부여.)
    
    특징 : UNIQUE + NOT NULL
    
    mySQL에서는 기본키 유일성을 편하게 유지하기 위해서 기본키 설정 시 자동으로 값을 1씩 증가하게 만들어주는 옵션을 사용한다. -> (옵션 : auto_increment)
    => 종속형 시퀀스
*/
DROP TABLE IF EXISTS member;

CREATE TABLE MEMBER(
	-- AUTO_INCREAMENT 옵션 설정 시 데이터가 추가될 때마다 해당 컬럼을 생략해도 자동으로 번호를 부여한다.
	member_no INT AUTO_INCREMENT PRIMARY KEY COMMENT '회원번호',
    member_id VARCHAR(30) NOT NULL UNIQUE COMMENT '회원아이디',
    member_pwd VARCHAR(30) NOT NULL COMMENT '회원비밀번호',
    member_name VARCHAR(21) NOT NULL COMMENT '회원이름',
    -- gender enum('남', '여') NOT NULL COMMENT '성별(남/여)',
    gender CHAR(3) CHECK(gender IN ('남', '여')) NOT NULL COMMENT '성별(남/여)',
    phone VARCHAR(13) COMMENT '전화번호',
    email VARCHAR(50) COMMENT '이메일', 
    create_at DATETIME COMMENT '회원가입일', 
    update_at DATETIME COMMENT '회원수정일',
    UNIQUE(email)
    -- CHECK(gender IN ('남', '여'))
) COMMENT = '회원 기본 정보 테이블';

INSERT INTO 
	MEMBER VALUES(1, 
								'user01', 
								'pass01', 
								'홍길동', 
								'남', 
								'010-1111-2222', 
								'aaa@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
                                
INSERT INTO 
	MEMBER VALUES(NULL, 
								'user02', 
								'pass01', 
								'홍길동', 
								'남', 
								'010-1111-2222', 
								'bbb@naver,com', 
								'2026-06-15 00:00:00', 
								'2026-06-15 00:00:00'
								);
SELECT * FROM MEMBER;

-- 복합 키 : 두 개 이상의 컬럼을 합해서 하나의 PRIMARY KEY로 묶는 것
-- > 무조건 테이블레벨 방식으로만 선언이 가능

-- 좋아요 테이블
CREATE TABLE TB_LIKE(
	member_no INT, -- 누가
    product_no INT, -- 어떤 상품을
    like_date DATETIME, -- 언제
    PRIMARY KEY(member_no, product_no)	-- 두 컬럼의 조합을 식별자로 사용
);

INSERT INTO TB_LIKE VALUES(1, 2, NOW());		-- 1번 사용자가 2번상품을 좋아요 누름
INSERT INTO TB_LIKE VALUES(1, 3, NOW());		-- 1번 사용자가 3번상품을 좋아요 누름
INSERT INTO TB_LIKE VALUES(2, 2, NOW());		-- 2번 사용자가 2번상품을 좋아요 누름
-- 2번 사용자가 2번상품을 좋아요 누른 데이터는 이미 존재하므로 중복에러가 발생!!
INSERT INTO TB_LIKE VALUES(2, 2, NOW());		-- 2번 사용자가 2번상품을 좋아요 누름
SELECT * FROM TB_LIKE;

/*
	FOREIGN KEY : 외래키 제약조건
    다른 테이블의 기본키(PK) 또는 식별키(UNIQUE제약조건)를 참조하여 관계를 맺는 제약 조건.
    - 외래키로 지정된 컬럼에는 부모 테이블에 실제 존재하는 값만 들어올 수 있다. (데이터 불일치를 방지)
    
    FOREIGN KEY(참조하는 컬럼) REFERENCES 참조할테이블명[(참조당할 컬럼)]
    => 참조당할 컬럼을 생략 시 해당 테이블의 PK를 자동으로 참조하게 됨
    
    * 부모 테이블 : 참조를 당하는 기준의 테이블 (ex. DEPARTMENT)
    * 자식 테이블 : 부모를 참조를 하는 테이블 (ex. EMPLOYEE)
*/

-- MEMBER_GREADE : 부모테이블 예시 (참조 당하는 테이블)
CREATE TABLE member_grade(
	grade_no INT PRIMARY KEY,
    grade_name VARCHAR(30) NOT NULL
);

INSERT INTO member_grade VALUES (10, '일반회원'), (20, '우수회원'), (30, '특별회원'), (40, 'VIP회원');

-- MEM : 자식테이블 예시 (부모테이블을 참조를 하는 테이블
CREATE TABLE mem(
	mem_no INT PRIMARY KEY,
    mem_id VARCHAR(30) NOT NULL UNIQUE,
    mem_pwd VARCHAR(30) NOT NULL,
    grade_no INT,
    FOREIGN KEY(grade_no) REFERENCES member_grade(grade_no)
);

INSERT INTO mem VALUES(1, 'user01', 'pass01', 10);
-- 부모 테이블(member_grade)에 50이라는 grade_code가 없으므로 외래키 제약조건 위반 에러 발생.
INSERT INTO mem VALUES(2, 'user02', 'pass02', 50);

-- 부모테이블의 10번등급 삭제 시 참조하고 있는 값이 있기 때문에 삭제 불가 에러가 발생함.
DELETE FROM member_grade WHERE grade_no = 10;

/*
	외래키 삭제 옵션
    부모 테이블 데이터가 삭제될 때, 이를 참조하고 있는 자식테이블의 데이터를 어떻게 처리할 것인가?
    
    - ON DELETE RESTRICT (= 기본값) : 삭제 제한. 참조중인 값이 있다면 삭제 불가.
    - ON DELETE SET NULL : 부모테이블의 데이터를 삭제 시, 자식테이블의 외래키 값은 NULL로 변경.
    - ON DELETE CASCADE : 부모테이블의 데이터를 삭제 시, 자식테이블의 데이터도 함께 삭제
*/
drop table if exists mem;
CREATE TABLE mem(
	mem_no INT PRIMARY KEY,
    mem_id VARCHAR(30) NOT NULL UNIQUE,
    mem_pwd VARCHAR(30) NOT NULL,
    grade_no INT,
    -- 부모 삭제 시 자식의 등급칸을 자동으로 NULL로 비우겠다.
    FOREIGN KEY(grade_no) REFERENCES member_grade(grade_no) ON DELETE SET NULL
);
INSERT INTO mem VALUES(1, 'user01', 'pass01', 10);
-- 정상적으로 제거되고, 참조하던 user01의  grade_no는 NULL이 됨.
DELETE FROM member_grade WHERE grade_no = 10;
SELECT * FROM mem;

-- ----------------------------------------------
/*
	DEFAULT : 기본값 설정
    제약조건은 아니고, 값을 명시하지 않았을 때 자동으로 채워질 값을 지정할 수 있음.
*/
drop table if exists mem;
CREATE TABLE mem(
	mem_no INT AUTO_INCREMENT PRIMARY KEY,
    mem_id VARCHAR(30) NOT NULL UNIQUE,
    mem_pwd VARCHAR(30) NOT NULL,
    grade_no INT,
    hobby VARCHAR(20) DEFAULT '코딩',
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 또는 NOW() 하지만 보통 DEFAULT 값으로 넣을 떄에는 CURRENT_TIMESTAMP를 사용. -> ansi구문
    FOREIGN KEY(grade_no) REFERENCES member_grade(grade_no) ON DELETE SET NULL
);
INSERT INTO mem VALUES(1, 'user01', 'pass01', 20, DEFAULT ,DEFAULT);
SELECT * FROM mem;
INSERT INTO mem(mem_id, mem_pwd) VALUES ('user02', 'pass02');

-- --------------------------------------------
/*
	테이블 복제
    : 기존 테이블의 구조와 데이터를 한번에 카피해서 새 테이블을 만드는 방법.
    (컬럼명만 복사가 되고, 제약조건은 복사가 되지 않는다.)
*/
-- 구조 + 데이터 복사
CREATE TABLE mem_copy AS (SELECT * FROM mem);

SELECT * FROM mem_copy;

-- 의도적으로 조건을 불일치 하여 테이블의 구조만 복사, 데이터X
CREATE TABLE mem_copy2 AS (SELECT * FROM mem WHERE 1=0);
SELECT * FROM mem_copy2;

-- ------------------------------------------------
/*
	ALTER TABLE : 테이블 구조 변경
    이미 생성된 테이블의 컬럼이나 제약조건을 추가/수정/삭제하는 구문이다.
    
    - 컬럼변경 : ADD(추가), MODIFY(수정), RENAME COLUMN(이름변경), DROP(삭제)
    - 제약조건 변경 : ADD(추가), DROP(삭제)
    * NOT NULL은 제약조건이 아닌 컬럼의 속성으로 취급.
*/
use ddltdb;
CREATE TABLE employee_copy AS SELECT * FROM tdb.employee;

CREATE TABLE department_copy AS SELECT * FROM tdb.department;

SELECT * FROM EMPLOYEE_COPY;

--  ----------------------------------------
-- 컬럼을 추가/수정/삭제/이름변경

-- 컬럼 추가
ALTER TABLE EMPLOYEE_COPY ADD age INT;
ALTER TABLE EMPLOYEE_COPY ADD address VARCHAR(30) DEFAULT '미입력';
-- > 새로운 컬럼은 기본적으로 가장 마지막에 추가됨
SELECT * FROM EMPLOYEE_COPY;

-- 컬럼 수정
ALTER TABLE EMPLOYEE_COPY MODIFY age VARCHAR(10);
ALTER TABLE EMPLOYEE_COPY MODIFY email VARCHAR(100);

ALTER TABLE EMPLOYEE_COPY MODIFY email VARCHAR(10);
-- > 기존 데이터가 들어있는 경우, 크기를 줄이면 데이터 손상이나 에러가 발생할 수 있음.

-- 컬럼 이름 변경
ALTER TABLE EMPLOYEE_COPY RENAME COLUMN phone to phone_number;
SELECT * FROM EMPLOYEE_COPY;

-- 컬럼삭제
ALTER TABLE EMPLOYEE_COPY DROP COLUMN age;
-- > 컬럼 삭제 시 해당 컬럼의 데이터를 복구할 수 없으므로 조심
ALTER TABLE EMPLOYEE_COPY DROP COLUMN email;

-- ------------------------------------------------------
/*
	제약조건 추가/수정/삭제
    제약조건 종류에 따라서 삭제하는 키워드가 구분되어있음.
    
    [CONSTRAINT 제약조건명] 제약조건
    모든 제약조건에는 제약조건명 입력가능, 입력 안할 시 자동으로 생성함.
*/

-- 제약조건 추가 ADD
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(emp_id);
ALTER TABLE DEPARTMENT_COPY ADD PRIMARY KEY(dept_id);
-- PK이거나 UNIQUE제약조건이 없는 값을 FK로 사용불가
ALTER  TABLE EMPLOYEE_COPY ADD FOREIGN KEY(dept_code) REFERENCES department_copy(dept_id);

ALTER TABLE EMPLOYEE_COPY ADD UNIQUE(EMP_NO);


-- NOT NULL 제약조건은 추가 및 수정 (MODIFY)
-- > NOT NULL은 제약조건이 아니라 컬럼의 속성이므로 컬럼 자체를 수정하는 개념이다.
ALTER TABLE EMPLOYEE_COPY MODIFY EMP_NAME VARCHAR(20) NOT NULL;
ALTER TABLE EMPLOYEE_COPY MODIFY EMP_NAME VARCHAR(20) NULL;

-- 제약조건 삭제 : DROP
ALTER TABLE EMPLOYEE_COPY DROP PRIMARY KEY;
ALTER TABLE EMPLOYEE_COPY DROP FOREIGN KEY employee_copy_ibfk_1;
-- > 외래키 제약조건을 삭제할 때에는 제약조건명을 통해서 삭제한다.
ALTER TABLE EMPLOYEE_COPY DROP INDEX EMP_NO;
-- > mySQL은 UNIQUE제약조건을 인덱스 형태로 관리하므로 삭제 시에는 drop index 키워드를 사용.

-- 테이블의 대한 정보 확인
SHOW CREATE TABLE EMPLOYEE_COPY;

-- -------------------------------------------
-- 테이블명 수정
ALTER TABLE EMPLOYEE_COPY RENAME TO emp_copy;


