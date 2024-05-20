-- dirty read 실습
-- 워크벤치(트랜잭션)에서 auto_commit을 해제 후 아무거나 update실행 == commit안된상태
-- 터미널(또다른 트랜잭션)을 열어서 select 했을 때, 위 변경사항이 변경됐는지 확인
-- 변경 안됐다 == dirty read 발생하지 않았다.
UPDATE `board`.`author` SET `profile_image` = ? WHERE (`id` = '8');
update author set name='hong14' where id=14;

-- phantom read 동시성 이슈 실습
-- 워크벤치에서 시간을 두고 2번의 select가 이뤄지고,
-- 터미널에서 중간에 insert 실행 -> 두번의 select 결과값이 동일한지 확인
start transaction;
select count(*) from author;
DO SLEEP(15);
select count(*) from author;
commit;
-- 터미널에서 아래 insert문 실행
insert into author(name, email) values('kim', 'hong16@naver.com');

-- lost update 이슈를 해결하기 위한 공유락(shared rock)
-- 워크벤치에서 아래 코드 실행;
start transaction;
select post_count from author where id=7 lock in share mode;
do sleep(15);
select post_count from author where id=7 lock in share mode;
commit;
-- 터미널에서 아래
select post_count from author where id=7 lock in share mode;
update author set post_count=0 where id=7;

-- 배타적 잠금(exclusive lock) : select for update
-- select부터 lock
start transaction;
select post_count from author where id=7 for update;
do sleep(15);
select post_count from author where id=7 for update;
commit;
-- 터미널에서 아래
select post_count from author where id=7 for update;
update author set post_count=0 where id=7;