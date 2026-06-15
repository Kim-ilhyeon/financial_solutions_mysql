-- 1. 데이터베이스 생성 (이모지 등 다국어 처리를 위한 utf8mb4 설정)
CREATE DATABASE tdb
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
    
-- 2. 사용자 계정 생성 ('server'라는 계정을 로컬 환경용으로 생성)
CREATE USER 'server'@'localhost' IDENTIFIED BY 'server';
-- CREATE USER 'server'@'*' IDENTIFIED BY 'server';  -- > 외부에서도 접근이 가능하게 함

-- 3. 권한 부여 (방금 만든 tdb 데이터베이스의 모든 테이블(*)에 대한 권한 부여)
GRANT ALL PRIVILEGES ON tdb.* TO 'server'@'localhost';

-- 4. 권한 적용 (메모리에 즉시 반영)
FLUSH PRIVILEGES;

-- 5. 권한 확인 (방금 만든 server 계정의 권한이 잘 들어갔는지 확인)
SHOW GRANTS FOR 'server'@'localhost';


CREATE DATABASE ddltdb 
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

    
