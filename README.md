# Fibonacci-Server
Erlang Based Cached Fibonacci Server 

To Start Server: 
```
rebar3 run
```

To Request Febonacci numbber:
```
> compute_pool:compute(100).
354224848179261915075

> compute_pool:compute([4,57,89]).  // list sholud be ordered 
[3,365435296162,1779979416004714189]

> compute_pool:compute([57,89,100]).
[365435296162,1779979416004714189,354224848179261915075]

> compute_pool:compute([4]). 
[3]

> compute_pool:compute([0,1,3,10]). 
[0,1,2,55]

> compute_pool:compute(100).        
354224848179261915075

```
To get Input Count : 
```

> compute_pool:history_count().     
[{57,2},{89,2},{1,1},{3,1},{10,1},{4,2},{0,1},{100,3}]

```
To get Input Result History 
```
> compute_pool:history().
[{57,365435296162},
 {89,1779979416004714189},
 {1,1},
 {3,2},
 {10,55},
 {4,3},
 {0,0},
 {100,354224848179261915075}]

```


Server API : 

History Count API : 
```
> curl -H 'Content-Type: application/json' http://localhost:5001/fibonacci/history_count
{"57":2,"89":2,"1":1,"3":1,"10":1,"4":2,"0":1,"100":3}
```
History API : 
```
> curl -H 'Content-Type: application/json' http://localhost:5001/fibonacci/history
{"57":365435296162,"89":1779979416004714189,"1":1,"3":2,"10":55,"4":3,"0":0,"100":354224848179261915075}
```

Fibonacci API with Number as Input:  
```
> curl -X POST -H 'Content-Type: application/json' -i http://localhost:5001/fibonacci/compute --data '{"input": 99}'  
218922995834555169026
```
Fibonacci API with List as Input
```
> curl -X POST -H 'Content-Type: application/json' -i http://localhost:5001/fibonacci/compute --data '{"input": [10,34,37,100]}'

[55,5702887,24157817,354224848179261915075]
```














