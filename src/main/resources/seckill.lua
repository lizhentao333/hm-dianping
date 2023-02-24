---
--- Generated by Luanalysis
--- Created by lizhentao.
--- DateTime: 2023/2/24 19:05
---

--- 参数列表
local voucherId = ARGV[1]
local userId = ARGV[2]

--- 数据key
local stockKey = 'seckill:stock:' .. voucherId
local orderKey = 'seckill:order:' .. voucherId

--- 1.判断库存是否充足
if (tonumber(redis.call('get', stockKey)) <= 0) then
    -- 库存不足
    return 1
end
--- 2.判断用户是否下单 sismember orderKey userId
if (redis.call('sismember', orderKey, userId) == 1) then
    -- 用户已经下单，就不再允许下单
    return 2
end

--- 3. 走到这说明有足够的库存，且该用户未下过单， 可以直接开一个新订单
-- 扣库存 incrby stockKey -1
redis.call('incrby', stockKey, -1)
-- 下单 sadd orderKey userId
redis.call('sadd', orderKey, userId)
return 0


