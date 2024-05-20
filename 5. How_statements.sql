show create table author;
show create table post;
select now();
select cast(date_format(created_time, '%m') as unsigned) as 'minute' from post;

-- 흐름 제어 : case 문
select 컬럼1, 컬럼2, 컬럼3,
case 컬럼4
    when [비교값1] then 결과값1
    when [비교값2] then 결과값2
    else 결과값3
END
FROM 테이블명;

-- POST 테이블에서 1번 USER는 FIRST AUTHOR, 2번 USER는 SECOND AUTHOR
select ID, TITLE, contents,
    case author_id
        when 1 then 'first author'
        when 2 then 'second author'
        else 'others'
    END as author_id
from post;

-- author_id가 있으면 그대로 출력 else author_id, 없으면 '익명사용자'로 출력되도록 post 테이블 조회
select ID, TITLE, contents,
    case author_id
        when null then '익명사용자'
        else author_id
    END as author_id
from post;

select ID, TITLE, contents,
    case 
        when author_id is null then '익명사용자'
        else author_id
    END as author_id
from post;

-- 위 case문을 ifnull구문으로 변환
select ID, TITLE, contents,
    ifnull(author_id, 'anonymous') as author_id
from post;
-- if구문으로 변환
select ID, TITLE, contents,
    if(author_id is null, 'anonymous', author_id) as author_id
from post;

-- 프로그래머스
-- 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE,
    CASE 
    WHEN STATUS = 'SALE' THEN '판매중'
    WHEN STATUS = 'RESERVED' THEN '예약중'
    ELSE '거래완료'
END AS STATUS
FROM USED_GOODS_BOARD
WHERE CREATED_DATE='2022-10-05'
ORDER BY BOARD_ID DESC;
-- 12세 이하인 여자 환자 목록 출력하기
SELECT PT_NAME, PT_NO, GEND_CD, AGE,
    IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT
WHERE AGE <=12 AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME; 