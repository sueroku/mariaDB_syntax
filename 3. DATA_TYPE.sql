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

