-- not null 조건 추가
alter table 테이블명 modify column 컬럼명 타입 not null;

-- auto_increment
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;
-- post에서 author.id에 제약조건을 가지고 있다보니,
-- author.id에 새로운 제약조건을 추가하는 부분에서 문제 발생
-- > author.id에 제약조건 추가시 fk로 인해 문제 발생시
-- fk 먼저 제거 이후에 author.id에 제약조건 추가.
select * from information_schema.key_column_usage where table_name = 'post';
-- 삭제 : 잘 쓰이는 방식은 아니다.
ALTER TABLE post DROP FOREIGN KEY post_ibfk_1;
ALTER TABLE post modify COLUMN author_id bigint;
-- 삭제된 제약조건 다시 추가
alter table post add CONSTRAINT post_author_fk foreign key(author_id) references author(id);
delete from author where id=2; -- 제약조건 확인
insert into author(email) values ('hong14@naver.com');
insert into post(title) values ('hong hello');

-- uuid : 공부해보는 게 좋다.
alter table post add column user_id char(36) DEFAULT (UUID()); -- column 추가시 채워넣는다. / 수정은 채워넣지 않는다.
insert into post(title) values('hong hello2');

-- unique : 제약조건
alter table author modify column email varchar(255) unique;

-- on delete cascade 테스트 -> 부모테이블의 id를 수정하면? 수정안됨
ALTER TABLE post DROP FOREIGN KEY  post_author_fk;
alter table post add CONSTRAINT post_author_fk foreign key(author_id) references author(id) on delete cascade;
delete from author where id=2; -- 삭제는 되지만 수정은 안된다.

ALTER TABLE post DROP FOREIGN KEY  post_author_fk;
alter table post add CONSTRAINT post_author_fk foreign key(author_id) references author(id) on delete cascade on update cascade;

-- (실습) on delete set null, on update cascade
ALTER TABLE post DROP FOREIGN KEY  post_author_fk;
alter table post add CONSTRAINT post_author_fk foreign key(author_id) references author(id) on delete set null on update cascade;