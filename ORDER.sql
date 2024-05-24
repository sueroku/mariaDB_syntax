use order_service;

CREATE TABLE CUSTOMERS(
ID INT AUTO_INCREMENT,
NAME VARCHAR(255) NOT NULL,
EMAIL VARCHAR(255) NOT NULL UNIQUE,
PASSWORD_C VARCHAR(255) NOT NULL,
BIRTH DATE,
PHONE_NUM INT,
ADDRESS VARCHAR(255),
CREATED_TIME DATETIME DEFAULT CURRENT_TIMESTAMP,
DEL_YN CHAR(1) NOT NULL DEFAULT 'N',
PRIMARY KEY (ID)
);

CREATE TABLE SELLERS(
ID INT AUTO_INCREMENT,
NAME VARCHAR(255) NOT NULL,
EMAIL VARCHAR(255) NOT NULL UNIQUE,
PASSWORD_S VARCHAR(255) NOT NULL,
BIRTH DATE,
PHONE_NUM INT,
ADDRESS VARCHAR(255),
CREATED_TIME DATETIME DEFAULT CURRENT_TIMESTAMP,
DEL_YN CHAR(1) NOT NULL DEFAULT 'N',
PRIMARY KEY (ID)
);

CREATE TABLE PRODUCTS(
ID INT AUTO_INCREMENT,
NAME VARCHAR(255) NOT NULL,
STOCK INT NOT NULL DEFAULT 0,
CREATED_TIME DATETIME DEFAULT CURRENT_TIMESTAMP,
MODIFIED_TIME DATETIME DEFAULT CURRENT_TIMESTAMP,
DEL_YN CHAR(1) NOT NULL DEFAULT 'N',
SELLER_ID INT NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (SELLER_ID) REFERENCES SELLERS(ID) ON delete cascade
);

CREATE TABLE ORDERS(
ID INT AUTO_INCREMENT,
CREATED_TIME DATETIME DEFAULT CURRENT_TIMESTAMP,
MODIFIED_TIME DATETIME DEFAULT CURRENT_TIMESTAMP,
ORDER_SET CHAR(1) NOT NULL DEFAULT 'Y',
CUSTOMER_ID INT NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(ID)
);

CREATE TABLE ORDER_DETAIL(
ID INT AUTO_INCREMENT,
SUPPLY INT NOT NULL DEFAULT 0,
PRODUCT_ID INT NOT NULL,
ORDER_ID INT NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(ID),
FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ID) 
);











-- 꼼꼼하게 따지려면 한도 끝도 없어서
-- 그냥 만들었다!

DELIMITER //
CREATE PROCEDURE 구매자회원가입(in 이름 varchar(255), in 이메일 varchar(255),
in 비밀번호 varchar(255), in 생년월일 date, in 전화번호 int, in 주소 varchar(255))
BEGIN
    insert into customers(name, email, password, birth, phone_num, address)
    values(이름, 이메일, 비밀번호, 생년월일, 전화번호, 주소);
END
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE 판매자회원가입(in 이름 varchar(255), in 이메일 varchar(255),
in 비밀번호 varchar(255), in 생년월일 date, in 전화번호 int, in 주소 varchar(255))
BEGIN
    insert into customers(name, email, password, birth, phone_num, address)
    values(이름, 이메일, 비밀번호, 생년월일, 전화번호, 주소);
END
// DELIMITER ;


DELIMITER //
CREATE PROCEDURE 구매자회원탈퇴(in 이메일 varchar(255), in 비밀번호 varchar(255))
BEGIN
	declare passwordCheck varchar(255);
    select password into passwordCheck from customers where email=이메일;
    if passwordCheck = 비밀번호 then
		update customers set DEL_YN='Y' where email=이메일;
	else
		select '회원 탈퇴를 실패하셨습니다.';
	end if;
END
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE 판매자회원탈퇴(in 이메일 varchar(255), in 비밀번호 varchar(255))
BEGIN
	declare passwordCheck varchar(255);
    select password into passwordCheck from sellers where email=이메일;
    if passwordCheck = 비밀번호 then
		update sellers set DEL_YN='Y' where email=이메일;
	else
		select '회원 탈퇴를 실패하셨습니다.';
	end if;
END
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE 판매자상품등록(in 이름 varchar(255), in 재고량 int, in 이메일 varchar(255))
BEGIN
    declare sellerId int;
    select id into sellerId from sellers where email=이메일;
    insert into products(name, stock, seller_id) values(이름, 재고량, sellerId);
END
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE 구매자주문하기(in 이름1 varchar(255), in 재고량1 int, in 이름2 varchar(255), in 재고량2 int,
in 이름3 varchar(255), in 재고량3 int, in 이메일 varchar(255))
BEGIN
    declare customerId int;
    declare productId int;
    declare orderId int;
    select id into customerId from customers where email=이메일;
    insert into orders(customer_id) values(customerId);
    select id into orderId from orders where CUSTOMER_ID=customerId;
    
    -- 사실 해야할게 많다! 재고량이 없으면 실패해야하고 허허허 일단 그냥 만든다!
    -- 서로 다른 판매자가 파는 상품이름이 중복될 수도 있다. 허허허 그냥 꽃밭으로 만든다!
    
	select id into productId from products where name=이름1;
    insert into order_detail(product_id, supply, order_id) values(productId, 재고량1, orderID);
    update products set STOCK = stock-재고량1 where id=productId; 
    select id into productId from products where name=이름2;
    insert into order_detail(product_id, supply, order_id) values(productId, 재고량2, orderID);
	update products set STOCK = stock-재고량2 where id=productId; 
    select id into productId from products where name=이름3;
    insert into order_detail(product_id, supply, order_id) values(productId, 재고량3, orderID);
    update products set STOCK = stock-재고량3 where id=productId; 
END
// DELIMITER ;
