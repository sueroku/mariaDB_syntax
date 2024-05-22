# local 컴퓨터의 board DB -> 마이그레이션 -> 리눅스 이전
# 스키마와 데이터 전체를 쿼리 형태로
# ==> CREATE DATABASE BOARD; ~~~~~~~~~
# 리눅스에 DB 설치 -> 로컬의 덤프 작업 후 SQL쿼리 생성 -> 깃헙에 업로드 -> 깃 클론 -> 리눅스에서 해당 쿼리 실행

# local에서 sql 덤프파일 생성 
mysqldump -u root -p --default-character-set=utf8mb4 board > dumpfile.sql
mysqldump -u root -p board > dumpfile.sql
# 한글 깨질때
mysqldump -uroot -p board -r dumpfile.sql

# dump파일을 github에 업로드

# 리눅스에서 mariadb 서버 설치
sudo apt-get install mariadb-server

# mariadb 서버 시작
sudo systemctl start mariadb

# mariadb 접속 테스트
sudo mariadb -u root -p

# git 설치
sudo apt install git

# git을 통해 repo clone
git clone 레파지토리 주소

sudo mysql -u root -p board < dumpfile.sql