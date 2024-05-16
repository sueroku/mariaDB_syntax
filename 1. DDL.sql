-- 데이터베이스 접속
mariadb -u root -p

-- 스키마(데이터베이스) 목록 조회
show databases;

-- (board)스키마 생성 / db이름은 대문자 안된다
CREATE DATABASE board; -- 명령어 대문자원칙 (소문자도 가능)

-- 끝내기 : 컨트롤 c

-- 데이터베이스 선택
use board;

-- 테이블 조회
show tables;

-- author 테이블 생성 //  INT부여 순간 메모리가 쓸 수 있는 범위 고정 
-- 컬럼이름 타입(VARCHAR(크기)) 속성
CREATE table author(id INT PRIMARY KEY, name VARCHAR(225), email VARCHAR(255), password VARCHAR(225));

-- 테이블 컬럼조회
describe author;

-- 컬럼 상세 조회
show full columns from author;

-- 테이블 생성문 조회
show CREATE table author;

-- posts 테이블 신규 생성
-- 컬럼 뒤에 붙이면 컬럼에 대해
-- 마지막에 붙이면 테이블에 대해 // 마지막에 , 테이블차원의 제약조건
CREATE table posts(id INT PRIMARY KEY, title VARCHAR(225), content VARCHAR(225), author_id int, foreign key(author_id) references author(id));

-- 테이블 index 조회
show index from author;
show index from posts;

-- ALTER문 : 테이블의 구조를 변경
-- 테이블 이름 변경
ALTER table posts rename post;
-- 테이블 컬럼 추가
ALTER table author add column test1 VARCHAR(50);
-- 테이블 컬럼 삭제
ALTER table author drop column test1;
-- 테이블 컬럼명 변경
ALTER table post change column content contents VARCHAR(255);
-- 테이블 컬럼 타입과 제약조건 변경 
ALTER table author modify column email VARCHAR(255) not null;

-- 실습 : author 테이블에 address 컬럼 추가.
ALTER table author add column address VARCHAR(255);

-- 실습 : post 테이블에 title은 not null 제약조건 추가, contents는 3000자로 변경
ALTER table post modify column title VARCHAR(255) not null;
ALTER table post modify column contents VARCHAR(3000);

 CREATE TABLE `post` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `contents` varchar(3000) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `author` (`id`)
);

-- 테이블 삭제
drop table 테이블명;

