-- insert into : 데이터 삽입
insert into 테이블명(컬럼명1, 컬럼2, 컬럼3) values(데이터1, '문자', 데이터3);
-- id, name, email -> author 1건 추가
insert into author(id, name, email) values(1, 'hong1', 'hong1@naver.com');

-- select : 데이터 조회, * : 모든 컬럼 조회
select * from author(테이블명);
select * from 스키마명.테이블명;

-- id, title, content, author_id -> posts에 1건 추가
insert into posts(id, title, content, author_id) values(1, 'hong1-1', 'hong1-1 good', 1);
select * from posts;

-- 테이블 제약조건 조회
select * from information_schema.key_column_usage where table_name = 'posts';
-- information_schema : 시스템데이터베이스 // key_column_usage : 테이블

--inser문을 통해 author데이터 4개 추가 post 5개 추가 (1개는 익명)
insert into author(id, name, email) values(2,'hong2','hong2@naver.com');
insert into author(id, name, email) values(3,'hong3','hong3@naver.com');
insert into author(id, name, email) values(4,'hong4','hong4@naver.com');
insert into author(id, name, email) values(5,'hong5','hong5@naver.com');

insert into post(id, title, contents, author_id) values(2,'hong1-2','hong1-2 hello', 1);
insert into post(id, title, contents, author_id) values(3,'hong2-1','hong2-1 hello', 2);
insert into post(id, title, contents, author_id) values(4,'hong2-2','hong2-2 hello', 2);
insert into post(id, title, contents, author_id) values(5,'hong3-1','hong3-1 hello', 3);
insert into post(id, title, contents) values(6,'hong','hong hello');

-- update 테이블명 set 컬럼명1=데이터1, 컬럼명2=데이터2 where id=1;
-- where 문을 빠뜨리게 될 경우, 모든 데이터에 update문이 실행됨에 유의  (where 조건 아주 중요 in update, delete)
update author set name='abc', email='abc@test.com' where id=1;
update author set email='abc2@test.com' where id=2;

-- delete from 테이블명 where 조건
-- where 조건이 생략될 경우, 모든 데이터가 삭제됨에 유의
delete from author where id = 5;

-- SELECT 의 다양한 조회 방법
SELECT * from author;
select * from author where id=1;
select * from author where id>2;
select * from author where id>2 and name='hong3';

-- 특정 컬럼만을 조회할 떼
SELECT name, email from author where id=3;

-- 중복제거하고 조회
select DISTINCT title from post;

-- 정렬 : order by 데이터의 출력결과를 특정 기준으로 정렬
-- 아무런 정렬 조건 없이 조회할 경우 pk기준으로 오름차순 정렬
-- asc : 오름차순 , desc :내림차순
select * from author order by name desc;

-- 멀티컬럼 order by : 여러 컬럼으로 정렬, 먼저 쓴 컬럼 우선 정렬. 중복시, 그 다음 정렬옵션 적용
select * from post order by title;  -- asc, desc 생략시 오름차순
select * from post order by title, id desc;

-- limit number : 특정 숫자로 결과값 개수 제한
select * from author order by id desc limit 1; -- 최신 등록된 사용자 중 한명만 보겠다.
select * from author limit 1;

-- alias(별칭)을 이용한 select : as 키워드 사용
select name as 이름, email as 이메일 from author;
select a.name as 이름, a.email as 이메일 from author as a;
-- 테이블 두개 이상 엮어서(join) 조회할 때, 컬럼명이 동일하게 있을 때, 테이블명이 길 때...

-- null을 조회조건으로
select * from post where author_id is null;
select * from post where author_id is not null;



-- 프로그래머스 MYSQL
-- 여러 기준으로 정렬하기
-- 상위 n개 레코드

