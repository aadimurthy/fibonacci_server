# Fibonacci-Server
This Fibonacci Server is written in Erlang and used ETS storage to get the optimized way of performing the computations by storing the previous computations results.

Components used:
Cowboy: Cowboy aims to provide a complete HTTP stack in a small code base. It is optimised for low latency and low memory usage, in part because it uses binary strings.

worker_pool(https://github.com/inaka/worker_pool): The goal of worker pool is pretty straightforward: To provide a transparent way to manage a pool of workers and do the best effort in balancing the load among them distributing the tasks requested to the pool

Below are the things I have considered choosing worker pool for implementing Fibonacci Server

1) Worker_Timeout that controls how many milliseconds is the client willing to spend in that, regardless of the global Timeout for the call). This ensures that, if a task takes too long, that doesn't block other tasks since, as soon as other worker is free it can pick up the next task in the list --> This is really important for service which do mathematical computation like Fibonacci and also it has risk of getting very larger inputs from users.

2) The number of workers in the pool and work pool strategy -> We can always limit or increase the resources  and strategy to adjust to serve the computation requests. 

Jsx: Erlang Json Parser


Known Issues/ Needed Improvements :
1) You might see some warnings/errors during cowboy run, this is because you might using OTP that cowboy not fully supported. Mine is OTP 21 and I experienced same :)   
2) I could use mnesia instead of ets to persist the computational results over the service restarts. 
3) Put limit on ETS storage or some algorithm to
3) What if, group of clients request to calculate same large Fibonacci numbers, same time and concurrently (kind DoS attack)?. To prevents this we can use the flag mechanism i.e we can rise the falg for ongoing computation so that we can prevent another computation and worker allocation for same computation.  
4) Separate modules for ETS and Fibonacci functions 
5) Config file to supply config to Cowboy, Worker Pool 







## To Start Server: 
```
rebar3 run
```

## To Request Febonacci numbber:
```
> compute_pool:compute(100).
{ok,354224848179261915075}

> compute_pool:compute([4,57,89]).  // list sholud be ordered 
{ok,[3,365435296162,1779979416004714189]}

> compute_pool:compute([57,89,100]).
{ok,[365435296162,1779979416004714189,
     354224848179261915075]}

> compute_pool:compute([4]). 
{ok,[3]}

> compute_pool:compute([0,1,3,10]). 
{ok,[0,1,2,55]}

> compute_pool:compute(100).        
{ok,354224848179261915075}

```
## To get Input Count : 
```

> compute_pool:history_count().     
{ok,[{57,2},{89,2},{1,1},{3,1},{10,1},{4,2},{0,1},{100,3}]}

```
## To get Input Result History 
```
> compute_pool:history().
{ok,[{57,365435296162},
 {89,1779979416004714189},
 {1,1},
 {3,2},
 {10,55},
 {4,3},
 {0,0},
 {100,354224848179261915075}]}

```


### Server API : 

### History Count API : 
```
> curl -H 'Content-Type: application/json' http://localhost:5001/fibonacci/history_count
{"57":2,"89":2,"1":1,"3":1,"10":1,"4":2,"0":1,"100":3}
```
### History API : 
```
> curl -H 'Content-Type: application/json' http://localhost:5001/fibonacci/history
{"57":365435296162,"89":1779979416004714189,"1":1,"3":2,"10":55,"4":3,"0":0,"100":354224848179261915075}
```

### Fibonacci API with Number as Input:  
```
> curl -X POST -H 'Content-Type: application/json' -i http://localhost:5001/fibonacci/compute --data '{"input": 99}'  
218922995834555169026
```
### Fibonacci API with List as Input
```
> curl -X POST -H 'Content-Type: application/json' -i http://localhost:5001/fibonacci/compute --data '{"input": [10,34,37,100]}'

[55,5702887,24157817,354224848179261915075]
```














