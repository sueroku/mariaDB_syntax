# redis를 언제 사용해야하는가를 배워야한다.
# redis document

sudo apt-get update
sudo apt-get install redis-server
redis-server --version

# 레디스 접속
# cli : command line interface : 프로그램하고 상호작용할 수 있는 툴
redis-cli
exit

# 레디스는 0-15번 까지의 database 구성
# 데이터베이스 선택 
select 번호(0번이 디폴트)

# 데이터베이스 내 모든 키 조회
keys ke*

# 일반 string 자료구조
# key:value 값 세팅
# key값은 중복되면 안된다.
set key값 value값
set test_key1 test_value1
set user:email:1 hong1@naver.com
# set 할때 key값이 이미 존재하면 덮어쓰기 되는 것이 기본
# map 저장소에서 key값은 유일하게 관리가 되므로
# nx (옵션) : not exist : key값이 없을때만 set
set user:email:1 hong@naver.com nx
# ex (옵션) : 만료시간(Time To Live)-초단위 // 세션 
set user:email:2 hong2@naver.com ex 20

# get을 통해 value 얻기
get test_key1

# 특정 key 삭제
del user:email:1

# 현재 데이터베이스 모든 key값 삭제
flushdb

# 좋아요 기능 구현 (ex-인스타같은 대량트래픽이 있는 경우) rdb보다는 redis같은..
# rdb -> 동시성 이슈 -> lock -> 성능이 떨어진다. -> redis(싱글스레드&&인메모리기반(성능))
set likes:posting:1 0 # 1: id // value값 문자로 저장
incr likes:posting:1 # 특정 key값의 value를 1만큼 증가 // 알아서 계산해줌
decr likes:posting:1 # 특정 key값의 value를 1만큼 감소

# 재고 기능 구현
set product:1:stock 100
decr product:1:stock
get product:1:stock
# bash shell을 활용하여 재고감소 프로그램 작성