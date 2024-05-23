-- 사용자 관리

-- 사용자 목록 조회
select * from mysql.user;

-- 사용자 생성
-- '%' 는 원격 포함한 anywhere 접속
create user 'test1'@'localhost' identified by '4321'; -- 그냥 생성시 권한이 없다.

-- 터미널 접속시 : mariadb -u test1 -p
-- 워크벤치에서 접속시 새로운 connection 만들고 user이름을 바꾼다.

-- 사용자에게 select 권한 부여 (테이블 단위로 가능?)
GRANT select on board.author to 'test1'@'localhost';
-- GRANT 주고싶은권한(update) on board.author to 'test1'@'localhost';
-- test1으로 로그인 후
select * from board.author;

-- 사용자 권한 회수
revoke select on board.author from 'test1'@'localhost';

-- 환경설정(DCL작업)을 변경 후 확정짓는 : 해야하는 개발환경도 있고, 습관적으로 해줘야하긴 한다.
flush privileges;

-- 권한 조회
show GRANTs for 'test1'@'localhost';
show GRANTs for 'root'@'localhost';

-- 사용자 계정 삭제
drop user 'test1'@'localhost';


-- 정보 제공에 제한을 두고 싶다
-- (이건 그냥 첨언) 별도테이블을 만들든지(거의 안한다), 특정 쿼리를 만들어서 그 쿼리만 쓸 수 있도록 하든지.
-- view
-- view 생성 : 가상의 테이블..?  보기에는 view라는 요소에 쿼리를 저장한 느낌
-- 쿼리레벨보다는 테이블 레벨쪽(권한부여가능) 암튼 실제 데이터를 참조하는 것!
create view author_for_view as
select name, age, role from author;

-- view 조회
select * from author_for_view; -- 해당 DB 내에서는 BOARD. 안넣어도 된다.

-- view에 권한 부여 // test 계정 view select 권한 부여 // 테이블이랑 이름중복안되는게 좋을듯.
grant select on board.author_for_view to (권한 줄 사용자);
select * from board.author_for_view;

-- view 변경(대체)
create or replace view author_for_view as
select name, email, age, role from author;

-- view 삭제
drop view author_for_view;


-- procedure 생성
DELIMITER //
CREATE PROCEDURE TEST_PROCEDURE()
BEGIN
    select 'HELLO WORLD';
END
// DELIMITER ;

-- PROCEDURE 호출
CALL TEST_PROCEDURE();

-- PROCEDURE 삭제
DROP PROCEDURE TEST_PROCEDURE;

-- 게시글 목록 조회 프로시저 생성
DELIMITER //
CREATE PROCEDURE 게시글목록조회()
BEGIN
    select * FROM POST;
END
// DELIMITER ;
CALL 게시글목록조회();

-- 게시글 1건 조회
DELIMITER //
CREATE PROCEDURE 게시글단건조회(IN postId INT)
BEGIN
    select * FROM POST WHERE ID=postId;
END
// DELIMITER ;
CALL 게시글단건조회(6); -- 워크벤치에서 쉽게 가능

-- 게시글 1건 조회
DELIMITER //
CREATE PROCEDURE 게시글단건조회_(IN 저자ID INT, IN 제목 VARCHAR(255))
BEGIN
    select * FROM POST WHERE author_ID=저자ID AND TITLE=제목;
END
// DELIMITER ;
CALL 게시글단건조회_(7, 'hong');

-- 글쓰기 // 컬럼명과 변수명이 같은경우에는? 문제없긴해도 다르게 하셔
DELIMITER //
CREATE PROCEDURE 글쓰기(IN 제목 VARCHAR(255), in 내용 VARCHAR(300), IN 저자ID INT)
BEGIN
    INSERT INTO POST(TITLE, CONTENTS, author_ID) VALUES(제목, 내용, 저자ID);
END
// DELIMITER ;
CALL 글쓰기('HONG', 'HELLO hong', 10);
-- : author_id는 현실성이 떨어진다. email을 알면 알았지

-- 글쓰기
DELIMITER //
CREATE PROCEDURE 글쓰기2(IN 제목 VARCHAR(255), in 내용 VARCHAR(300), IN 이메일 VARCHAR(255))
BEGIN
    declare authorId int;
    select id into authorId from author WHERE email = 이메일;
    INSERT INTO POST(TITLE, CONTENTS, author_ID) VALUES(제목, 내용, authorId);
END
// DELIMITER ;
CALL 글쓰기2('HONG16 go', 'HELLO hong16', 'hong16@naver.com');

-- sql 문자열 합치는 concat('hello', 'java');
-- 글 상세 조회 input : postId // output : title, contents, name+님
DELIMITER //
CREATE PROCEDURE 글상세조회(in postId int)
BEGIN
    declare authorId int;
    declare authorname varchar(255);
    select author_id into authorId from post WHERE id=postId;
    select name into authorname from author where id=authorId;
    select title, contents, concat(authorname, '님') as authorName from post where id=postId;
END
// DELIMITER ;
CALL 글상세조회(6);
-- join
DELIMITER //
CREATE PROCEDURE 글상세조회2(in postId int)
BEGIN
    select p.title, p.contents, concat(a.name,'님') from post p inner join author a on p.author_id = a.id where p.id=postId;
END
// DELIMITER ;
CALL 글상세조회2(6);
-- 강사님
DELIMITER //
CREATE PROCEDURE 글상세조회(in postId int)
BEGIN
    declare authorName varchar(255);
    select name into authorName from author where id = (select author_id from post where id=postId);
    select title, contents, concat(authorname, '님') as authorName from post where id=postId;
END
// DELIMITER ;
CALL 글상세조회(6);

-- 등급조회
-- 글을 100개 이상 쓴 사용자는 고수입니다. 출력
-- 10개 이상 100개 미만이면 중수입니다.
-- 그 외는 초보입니다.
-- input : email
-- 강사님
DELIMITER //
CREATE PROCEDURE 등급조회(in emailInput varchar(255))
BEGIN
    declare authorId int;
    declare count int;
    select id into authorId from author where email=emailInput;
    select count(*) into count from post where author_id=authorId;
    if count >=100 then
        select '고수입니다.';
    ELSEIF count>= 10 and count<100 then
        select '중수입니다.';
    ELSE
        select '초보입니다.';
    end if;
END
// DELIMITER ;
CALL 등급조회(6);
-- 다른분은 이거 사용
-- select ID, TITLE, contents,
--     case 
--         when author_id is null then '익명사용자'
--         else author_id
--     END as author_id
-- from post;
DELIMITER //
CREATE PROCEDURE 등급조회2(in emailInput varchar(255))
BEGIN
    declare authorId int;
    declare count int;
    select id into authorId from author where email=emailInput;
    select count(*) into count from post where author_id=authorId;

END
// DELIMITER ;

-- 반복문을 통해 post 대량 생성
-- 사용자가 입력한 반복 횟수에 따라 글이 도배되는데,
-- title은 '안녕하세요'
DELIMITER //
CREATE PROCEDURE 글도배서비스(in count int)
BEGIN
    declare num int; -- declare num int default 0;
    set num = 0;
    while num < count do
        insert into post(title) VALUES ('안녕하세요.');
        set num = num+1;
    end while;
END
// DELIMITER ;
CALL 글도배서비스(5);
-- procedure kill id

-- 프로시저 생성문 조회
show create procedure 프로시저명;

-- 프로시저 권한 부여 // 뷰는 테이블 영역, 프로시저는 프로그램 영역
grant excute on board.글도배서비스 to 'test1'@'localhost';