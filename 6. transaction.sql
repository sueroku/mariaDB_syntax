insert into author(email) values('hong15@naver.com');
-- 지금까지는 mariadb에서 알아서 commit까지 해줬다. (토글버튼)
-- 지금까지 모든 쿼리는 기본이 auto_commit이었기 때문에 즉시 반영 => 자동이 아니면 쿼리;+commit;
commit;

--author테이블에 post_count라고 컬럼(int) 추가
alter table author add column post_count int;
alter table author modify column post_count int default 0;

-- post에 글 쓴 후에, author 테이블에 post_count값에 +1 => 트랜잭션
start transaction;
update author set post_count = post_count+1 where id=14;
insert into post(title, author_id) values('hello java', 15); -- 정상 13 실패 15
-- 위 쿼리들이 정상 실행했으면 x, 실패했으면 y, -> 분기 처리 procedure
commit;
-- 또는
rollback;
-- 나중에는 지금처럼 직접 쿼리를 이런 식으로 날리는게 아니라 프로그램에서 알아서 처리


-- stored procedure를 활용한 트랜잭션 테스트
DELIMITER //
CREATE PROCEDURE InsertPostAndUpdateAuthor()
BEGIN
    -- 트랜잭션 시작
    START TRANSACTION;
    -- UPDATE 구문
    UPDATE author SET post_count = post_count + 1 WHERE id = 14;
    -- UPDATE가 실패했는지 확인하고 실패 시 ROLLBACK 및 오류 메시지 반환
    IF (ROW_COUNT() = 0) THEN
        ROLLBACK;
    END IF;
    -- INSERT 구문
    INSERT INTO post (title, author_id) VALUES ('hello', 15); -- 정상 13 실패 15
    -- INSERT가 실패했는지 확인하고 실패 시 ROLLBACK 및 오류 메시지 반환
    IF (ROW_COUNT() = 0) THEN
        ROLLBACK;
    END IF;
    -- 모든 작업이 성공했을 때 커밋
    COMMIT;
END //
DELIMITER ;    -- 실패

-- stored 프로시저를 활용한 트랜잭션 테스트  -- 수정
DELIMITER //
CREATE PROCEDURE InsertPostAndUpdateAuthor()
BEGIN
    DECLARE exit handler for SQLEXCEPTION -- sqlexception이 터지면 rollback 실행
    BEGIN
        ROLLBACK();
    END;
    -- 트랜잭션 시작
    START TRANSACTION;
    -- UPDATE 구문
    UPDATE author SET post_count = post_count + 1 where id = 14;
    -- INSERT 구문
    insert into post(title, author_id) values('hello world java', 15); -- 정상 13 실패 15
    -- 모든 작업이 성공했을 때 커밋
    COMMIT;
END //
DELIMITER ;

-- 프로시저 호출
CALL InsertPostAndUpdateAuthor();