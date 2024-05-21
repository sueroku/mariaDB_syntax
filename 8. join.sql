-- inner join
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만 반환 on 조건을 통해 교집합 찾기
select * from post inner join author on author.id=post.author_id;
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
-- 글쓴이가 있는 글목록과 글쓴이의 이메일을 출력하시오. (익명 게시물은 제외)
select p.id, p.title, p.contents, a.email from post p inner join author a on p.author_id=a.id;

-- 모든 글목록을 출력하고, 만약에 글쓴이가 있다면 이메일을 출력
select p.id, p.title, p.contents, a.email from post p 
left outer join author a on p.author_id=a.id;
select p.id, p.title, p.contents, a.email from author a 
left outer join post p on p.author_id=a.id; -- 위 쿼리와 다르다.
select p.*, a.email from post p 
left outer join author a on p.author_id=a.id;
-- outer안써도 된다. right join 도 있다. select * from post left join 

-- join된 상황에서의 where 조건 : on 뒤에 where 조건이 나옴
-- 1) 글쓴이가 있는 글 중에 글의 title과 저자의 email을 출력, 저자의 나이는 25세 이상
select p.title, a.email from post p inner join author a on p.author_id=a.id
where a.age >= 25;
-- 2) 모든 글의 title과 저자가 있다면 email을 출력, 2024-05-01 이후에 만들어진 글만 출력
select p.title, a.email from post p 
left join author a on p.author_id=a.id
where date_format(p.created_time, '%Y-%m-%d') >= '2024-05-01';
-- 프로그래머스
-- 조건에 맞는 도서와 저자리스트 출력
SELECT B.BOOK_ID, A.AUTHOR_NAME, DATE_FORMAT(B.PUBLISHED_DATE,'%Y-%m-%d') 
FROM AUTHOR A INNER JOIN BOOK B ON A.AUTHOR_ID = B.AUTHOR_ID
WHERE B.CATEGORY = '경제' oRDER BY B.PUBLISHED_DATE;

-- UNION : 중복 제외한 두테이블의 SELECT을 결합(세로로)
-- 컬럼의 개수와 타입이 같아야함에 유의
-- UNION ALL : 중복포함
SELECT 컬럼1, 컬럼2 FROM TABLE1 UNION SELECT 컬럼1, 컬럼2 FROM TABLE2
-- AUTHOR 테이블의 NAME, EMAIL 그리고 POST테이블의 TITLE, CONTENTS UNION
SELECT NAME, EMAIL fROM AUTHOR UNION SELECT TITLE, CONTENTS FROM post;

-- 서브쿼리 : SELECT문 안에 또다른 SELECT문을 서브쿼리라 한다.
-- SELECT 절 안에 서브쿼리
-- AUTHOR EMAIL과 해당 AUTHOR가 쓴 글의 개수를 출력
SELECT EMAIL, (SELECT COUNT(*) FROM POST P WHERE P.AUTHOR_ID = A.ID) AS COUNT FROM AUTHOR A;
-- FROM 절 안에 서브쿼리 : 완전 어거지
SELECT A.NAME FROM (SELECT * FROM AUTHOR) AS A;
-- WHERE 절 안에 서브쿼리
SELECT A.* FROM AUTHOR A INNER JOIN POST P ON A.ID = P.AUTHOR_ ID; 
SELECT * FROM author WHERE ID IN (SELECT AUTHOR_ID FROM POST); -- 서브쿼리 남발은 좋지 않다.

--프로그래머스
-- 없어진 기록 찾기 문제 : JOIN 문제, 서브쿼리로도 풀어보자
SELECT OUTS.ANIMAL_ID, OUTS.NAME FROM ANIMAL_OUTS OUTS LEFT JOIN ANIMAL_INS INS
ON OUTS.ANIMAL_ID = INS.ANIMAL_ID
WHERE INS.ANIMAL_ID IS NULL ORDER BY OUTS.ANIMAL_ID;
SELECT OUTS.ANIMAL_ID, OUTS.NAME FROM ANIMAL_OUTS OUTS
WHERE ANIMAL_ID NOT IN(SELECT ANIMAL_ID FROM ANIMAL_INS) ORDER BY OUTS.ANIMAL_ID;

-- 집계함수
SELECT COUNT(*) FROM AUTHOR; -- == SELECT COUNT(ID) FROM AUTHOR;
SELECT SUM(PRICE) FROM POST;
SELECT ROUND(AVG(PRICE), 0) FROM POST;

-- GROUP BY 와 집계함수
SELECT AUTHOR_ID FROM POST GROUP BY AUTHOR_ID;
SELECT AUTHOR_ID, COUNT(*), SUM(PRICE), ROUND(AVG(PRICE), 0), MIN(PRICE), MAX(PRICE) FROM POST GROUP BY AUTHOR_ID;

-- 저자 EMAIL, 해당 저자가 작성한 글 수를 출력
SELECT A.ID, IF(P.ID IS NULL, 0, COUNT(*)) FROM AUTHOR A LEFT JOIN POST P ON A.ID=P.AUTHOR_ID GROUP BY A.ID;

-- WHERE와 GROUP BY
-- 연도별 POST 글 출력, 연도가 NULL인 데이터는 제외
SELECT DATE_FORMAT(P.created_time, '%Y') AS Y, COUNT(*) FROM POST P
WHERE P.created_time IS NOT NULL GROUP BY Y;

-- 프로그래머스
-- 자동차 종류별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE, COUNT(*) AS CARS FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%통풍시트%' OR OPTIONS LIKE '%열선시트%' OR OPTIONS LIKE '%가죽시트%'
GROUP BY CAR_TYPE ORDER BY CAR_TYPE;
-- 입양시각 구하기(1)
SELECT CAST(DATE_FORMAT(DATETIME, '%H')AS UNSIGNED) AS HOUR, COUNT(*) AS COUNT
FROM ANIMAL_OUTS 
WHERE DATE_FORMAT(DATETIME, '%H:%i') BETWEEN '09:00' AND '19:59'
GROUP BY HOUR ORDER BY HOUR;

-- HAVING : GROUP BY 를 통해 나온 통계에 대한 조건
SELECT AUTHOR_ID, COUNT(*) FROM POST GROUP BY AUTHOR_ID;
-- 글을 두개 이상 쓴 사람에 대한 통계정보
SELECT AUTHOR_ID, COUNT(*) as count FROM POST 
where author_id is not null
GROUP BY AUTHOR_ID having count>=2;
-- (실습) 포스트 price가 2000원 이상인 글을 대상으로, 작성자별로 몇건인지와
-- 평균 price를 구하되, 평균 price가 3000원 이상인 데이터를 대상으로만 통계 출력
select author_id, avg(price) as avg_price, count(*) as count from post
where price >= 3000
GROUP by author_id having avg_price>=3000;
-- 프로그래머스 : 동명 동물 수 찾기
SELECT NAME, COUNT(*) AS COUNT FROM ANIMAL_INS
GROUP BY NAME
HAVING COUNT>=2 AND NAME IS NOT NULL
ORDER BY NAME;
-- 강사님
SELECT NAME, COUNT(*) AS COUNT FROM ANIMAL_INS
WHERE NAME IS NOT NULL
GROUP BY NAME
HAVING COUNT>=2
ORDER BY NAME;

-- (실습) 2건 이상의 글을 쓴 사람의 ID와 EMAIL, 글의 수을 구할건데,
-- 나이는 25세 이상인 사람만 통계에 사용하고, 가장 나이 많은 사람 1명의 통계만 출력
SELECT P.AUTHOR_ID, A.EMAIL, COUNT(*) AS COUNT FROM POST P INNER JOIN AUTHOR A ON A.ID = P.AUTHOR_ID
WHERE A.AGE >=25
GROUP BY P.AUTHOR_ID
HAVING COUNT>=2
ORDER BY A.AGE DESC LIMIT 1;
-- 강사님
SELECT A.ID, A.EMAIL, COUNT(A.ID) AS COUNT FROM AUTHOR A INNER JOIN POST P ON A.ID=P.AUTHOR_ID
WHERE A.AGE >= 25
GROUP BY A.ID HAVING COUNT >= 2 ORDER BY MAX(A.AGE) DESC LIMIT 1;
-- 다른분 : 사진
 
-- 다중열 GROUP BY
SELECT AUTHOR_ID, TITLE, COUNT(*) FROM POST GROUP BY AUTHOR_ID, TITLE;
-- 프로그래머스 : 재구매가 일어난 상품과 회원 리스트 구하기
SELECT USER_ID, PRODUCT_ID FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(USER_ID)>=2 AND COUNT(PRODUCT_ID)>=2
ORDER BY USER_ID, PRODUCT_ID DESC;
-- 강사님
SELECT USER_ID FROM ONLINE_SALE
GROUP BY USER_ID
HAVING COUNT(*)>=2; -- 같은 유저가 재구매를 한것은 맞다. 그러나 같은 상품을 재구매한건 아니다.

SELECT USER_ID, PRODUCT_ID FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*)>=2
ORDER BY USER_ID, PRODUCT_ID DESC;