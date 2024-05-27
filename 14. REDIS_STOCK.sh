# !/bin/bash # 일반적으로 bash shall 시작할때 작성

# 200번 반복하면서 재고 확인 및 감소시키는 script // RDB 는

for i in {1...200}; do
    quantity=$(redis-cli -h localhost -p 6379 get apple:1:quantity) #redis-cli get apple:1:quantity
    if [ "$quantity" -lt 1 ]; then
        echo "재고가 부족합니다. 현재 재고 : $quantity"
        break;
    fi
    # 재고 감소
    redis-cli -h localhost -p 6379 decr apple:1:quantity
    echo "현재 재고 : $quantity"
done

