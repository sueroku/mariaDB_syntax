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