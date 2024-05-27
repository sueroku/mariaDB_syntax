# redis를 언제 사용해야하는가를 배워야한다.
# redis document

sudo apt-get update
sudo apt-get install redis-server
redis-server --version

# 레디스 접속
# cli : command line interface : 프로그램하고 상호작용할 수 있는 툴
redis-cli
exit

# 레디스는 0-15번 까지의 database 구성 // 파티션 // 목적에 따라 사용
# 데이터베이스 선택 
select 번호(0번이 디폴트)

# 데이터베이스 내 모든 키 조회
keys *

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
set user:email:2 34hong2@naver.com ex 20

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

# 캐싱 기능 구현
# 1번 author 회원 정보 조회
# select name, email, age from author where id=1;
# 위 데이터의 결과값을 redis로 캐싱 : json 데이터 형식으로 저장
set user:1:detail "{\"name\":\"hong\",\"email\":\"hong@naver.com\",\"age\":30}" ex 10

# list
# redis 의 list는 java의 deque와 같은 구조, 즉 double-ended queue구조
# 데이터 왼쪽 삽입
LPUSH KEY VALUE # LPUSHH 키이름 키값
# 데이터 오른쪽 삽입
RPUSH KEY VALUE
# 데이터 왼쪽 부터 꺼내기
LPOP KEY
# 데이터 오른쪽부터 꺼내기
RPOP KEY

LPUSH hongs hong1
LPUSH hongs hong2
LPUSH hongs hong3
# lpop 시 hong3 (꺼내서 없앰)

# 꺼내서 없애는게 아니라, 꺼내서 보기만.
lrange hongs -1 -1
lrange hongs 0 0

# 데이터 개수 조회
llen key
# list의 요소 조회시에는 범위 지정
lrange hongs 0 -1 # 처음부터 끝까지
# start부터 end까지 조회
lrange hongs start end # 숫자 넣는다. 0부터 시작
# TTL 적용
expire hongs 20
# TTL 조회
ttl hongs

# pop과 push 를 동시에
# a리스트에서 pop, b리스트에 push
rpoplpush a리스트 b리스트 # a리스트에서 빼서 b리스트로 넣는다. 이거만 있단다

# 어떤 목적으로 사용될 수 있을까?
# 5개 정도 데이터 push
# 최근 방문한 페이지 3개 정도 보여주는
rpush recent:website www.naver.com
rpush recent:website www.google.com
rpush recent:website www.daum.net
rpush recent:website www.kakao.com
rpush recent:website www.netmarble.com
llen recent:website
lrange recent:website 2 -1
# 위 방문페이지를 5개서 뒤로가기 앞으로가기 구현
# 뒤로가기 페이지를 누르면 뒤로가기 페이지가 뭔지 출력
# 다시 앞으로가기 누르면 앞으로간 페이지가 뭔지 출력
rpoplpush recent:website next:website
lrange recent:website -1 -1
#lpoprpush next:website recent:website # lpoprpush 없다구 한다.
#lrange recent:website -1 -1
# 강사님 # 결론 : 만드려면 힘들엉. 프로그램 차원에서 가능
rpush forward www.naver.com
rpush forward www.google.com
rpush forward www.daum.net
rpush forward www.kakao.com
rpush forward www.netmarble.com
lrange forward -1 -1
rpoplpush forward backward
# 동기분 : range 값을 조절

# set 자료구조 : 중복이 없다.
# set 자료구조에 멤버 추가
sadd members member1
sadd members member2
sadd members member1

# set 조회
smembers members
# set 에서 멤버 삭제
srem members member2
# set 멤버 개수 변환
scard members
# 특정 멤버가 set안에 있는지 존재 여부 확인 // 있으면 1반환
sismember members member3

# 매일 방문자수 계산 // 조회수 // 좋아요
sadd visit:2024-05-27 hong1@naver.com

# rpush 사과
# rpush 배 
# rpush 사과 (중복 발생시 문제) # 그냥으로는 구조적으로 좀 어려움 // 중복제거 및 순서 면에서
# 최근 본 상품목록 => sorted set(zset)을 활용하는 것이 적절 

# zset(sorted set)
zadd zmembers 3 member1
zadd zmembers 4 member2
zadd zmembers 1 member3
zadd zmembers 2 member4

# score 기준 오름차순 정렬
zrange zmembers 0 -1
# score 기준 내림차순 정렬
zrevrange zmembers 0 -1

# zset 삭제
zrem zmembers member2
# zrank 는 해당 멤버가 index 몇번째인지 출력
zrank zmembers member4

zadd zmembers 0 member2 # 갈아끼워진다.

# 최근 본 상품목록 3개 조회
zadd recent:products 192411 apple
zadd recent:products 192413 apple # score가 큰게 남는 것인지... 늦게 들어가는 게 들어갈 것인지..
zadd recent:products 192415 banana
zadd recent:products 192420 orange
zadd recent:products 192425 apple
zadd recent:products 192430 apple
zrevrange recent:products 0 2


# hashes
# 해당 자료구조에서는 문자, 숫자가 구분
hset product:1 name "apple" price 1000 stock 50
hget product:1 name
hgetall product:1 # 모든 객체 값 get
# 특정 요소값 수정
hset product:1 stock 40

# 특정 요소의 값을 증가
hincrby product:1 stock 5
hincrby product:1 stock -5 # 감소

