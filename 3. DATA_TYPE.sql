-- tinyint는 -128~127 까지 표현
-- author 테이블에 age컬럼 추가.
alter table author add column age tinyint;
insert into author(id, name, email, age) values(6,'hong6','hong6@naver.com', 38);
insert into author(id, name, email, age) values(7,'hong7','hong7@naver.com', 333);
-- unsigned : 0~255으로 표현범위 이동
alter table author modify column age tinyint unsigned;
insert into author(id, name, email, age) values(8,'hong8','hong8@naver.com', 200);

-- DECIMAL 실수 실습
ALTER TABLE post add column price DECIMAL(10,3);
describe post;
insert into post(id, title, price) values(7,'hong7-1',3.123123); -- 소수점 초과값 입력 후 짤림 확인
update post set price=1234.1 where id=7;

--  blob  바이너리데이터 실습
-- author 테이블에 profile_image 컬럼을  blob형식으로 추가
alter table author add column profile_image blob;
insert into author(id, name, email, profile_image) values (8, 'hong8','hong8@naver.com', LOAD_FILE('C:\\cat1.jpg'));
insert into author(id, name, email, profile_image) values (8, 'hong8','hong8@naver.com', LOAD_FILE('C:\\Users\\Playdata\\Desktop\\cat1.jpg'));

-- enum : 삽입될 수 있는 데이터 종류를 한정하는 데이터 타입
-- role 컬럼
ALTER TABLE author ADD COLUMN role varchar(10); -- 다르다
ALTER TABLE author ADD COLUMN role ENUM('user', 'admin') not null;
ALTER TABLE author modify COLUMN role ENUM('admin', 'user') not null; -- not null로 인해 enum의 첫번째 값을 알아서 디폴트 값으로 준다.
ALTER TABLE author modify COLUMN role ENUM('user', 'admin') not null DEFAULT 'user'; -- 보통 디폴트값을 같이 준다. // NOT NULL 없어도 될거 같다.
-- 이미 데이터가 들어가 있을 경우 (user --> myuser로 바꾸고 싶다면)
-- 바꾸고 싶은 데이터 넣고, 들어있는 데이터 바꾸고, 들어있는 데이터 지우고
ALTER TABLE author modify COLUMN role ENUM('user', 'admin', 'myuser') not null DEFAULT 'user';
-- enum 컬럼 실습
-- user1을 insert
insert into author (id,name,email,role) values (9, 'hong9', 'hong9@naver.com', 'user1');
-- user 혹은 admin insert
insert into author (id,name,email,role) values (10, 'hong10', 'hong10@naver.com', 'admin');

-- date 타입
-- author 테이블에 birth 컬럼 date로 추가
-- 날짜 타입의 insert는 문자열('2024-05-17') 형식으로 insert
alter table author add column birth date;
insert into author (id, email, birth) values (11, 'hong11@naver.com', '1996-11-11');

-- datetime 타입 / datetime(4)
-- author, post 테이블에  created_time 컬럼 datetime 로 추가
-- 날짜 타입의 insert는 문자열('2024-05-17 12:01:01') 형식으로 insert
-- 현재 시각 자바 프로그래밍으로 넣거나 db가 넣거나 // 유의미하게 차이가 있지는 않다
alter table author add column created_time datetime -- not null DEFAULT current_timestamp;
alter table post add column created_time datetime -- not null DEFAULT current_timestamp;
insert into author (id, email, created_time) values (12, 'hong12@naver.com', '2023-11-11 12:01:00');
insert into post (id, title, created_time) values (8, 'hong8-1', '2023-11-11 12:01:00');

alter table author modify column created_time datetime DEFAULT current_timestamp;
alter table post modify column created_time datetime DEFAULT current_timestamp;
insert into author (id, email) values (13, 'hong13@naver.com');
insert into post (id, title) values (9, 'hong8-2');

-- 비교연산자 (오라클과 차이가 있다)
-- and 또는 && 
select * from post where id>=2 and id<=4;
select * from post where id between 2 and 4;
-- or 또는 ||
-- not 또는 !
select * from post where not(id<2 or id>4);
select * from post where !(id<2 or id>4);
-- null인지 아닌지
select * from post where contents is null;
select * from post where contents is not null;
-- in(리스트 형태)과 not in(리스트 형태)
select * from post where id in(1,2,3,4);
select * from post where id not in(1,2,3,4);

-- like : 특정 문자를 포함하는 데이터를 조회하기 위해 사용하는 키워드
select * from post where title like '%1'; -- 1로 끝나는 title 검색
select * from post where title like 'h%'; -- h로 시작하는 title 검색
select * from post where title like '%g2%'; -- 단어 중간에 g2 있는 title 검색
select * from post where title like '%ong%';
select * from post where title not like '%1%'; -- 1로 끝나지 않는 title 검색

-- ifnull(a,b) : 만약에 a가 null이면 b 반환, null이 아니면 a 반환
select title, contents, ifnull(author_id,'익명') as 저자 from post;

-- 프로그래머스 경기도에 위치한 식품창고 목록 출력하기

-- REGEXP : 정규표현식([가-힣])을 활용한 조회  예)한글로만 된 이름, 영어로만 된 이름
-- 기본 원리를 알고 검색(이메일 정규표현식) 혹은 챗GPT 활용
SELECT * FROM author WHERE Name REGEXP '[가-힣]';
SELECT * FROM author WHERE Name REGEXP '[a-z]';

-- 날짜 변환 : 숫자->날짜 / 문자->날짜
-- cast 와 convert
select cast(20200101 as date);  -- 테이블의 데이터 쓰는게 아니라 그냥 결과값만 화면에
select cast('20200101' as date);
select convert(20200101 date); 
select convert('20200101' date);

-- datetime 조회 방법
select * from post where created_time like '2024-05%';
select * from post where created_time <='2024-12-31' and created_time>='1999-01-01';
select * from post where created_time between '1999-01-01' and '2024-12-31';
-- date_format
select date_format(created_time, '%Y-%m') as created_time from post;
-- (실습) post를 조회할때 date_format을 활용하여 2024년 데이터 조회, 결과는 *
select * from post where date_format(created_time, '%Y')='2024';

-- 오늘 날짜
SELECT NOW();

-- 프로그래머스 흉부외과 또는 일반외과 의사 목록 출력하기
SELECT DR_NAME, DR_ID, MCDP_CD, DATE_FORMAT(HIRE_YMD,'%Y-%m-%d') AS HIRE_YMD
FROM DOCTOR WHERE MCDP_CD ='CS' OR MCDP_CD='GS' ORDER BY HIRE_YMD DESC, DR_NAME;
SELECT DR_NAME, DR_ID, MCDP_CD, DATE_FORMAT(HIRE_YMD,'%Y-%m-%d') AS HIRE_YMD
FROM DOCTOR WHERE MCDP_CD IN('CS','GS') ORDER BY HIRE_YMD DESC, DR_NAME;

