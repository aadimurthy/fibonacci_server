# Fibonacci-Server
Erlang Based Cached Fibonacci Server 

To Start Server: 
```
> {ok,Pid}=febonnacy_server:start_link().
```

To Request Febonacci numbber:
```
> gen_server:call(Pid,{compute,10}).        
55

> gen_server:call(Pid,{compute,1}). 
1

> gen_server:call(Pid,{compute,0}).
0

> gen_server:call(Pid,{compute,3}).
2

> gen_server:call(Pid,{compute,10}).        
55

> gen_server:call(Pid,{compute,[0,1,3,10]}).  // list Shoud be Ordered List
[0,1,2,55]


```
To get Input Count : 
```
> gen_server:call(Pid,count).               
[{1,2},{3,2},{10,3},{0,2}]
```
To get Input Result History 
```
> gen_server:call(Pid,history).             
[{1,1},{3,2},{10,55},{0,0}]
```

Again Request Febonacci number :
```
> gen_server:call(Pid,{compute,100}).       
354224848179261915075
```

Check Count and History: 
```
> gen_server:call(Pid,count).        
[{1,2},{3,2},{10,3},{0,2},{100,1}]

> gen_server:call(Pid,history).             
[{1,1},{3,2},{10,55},{0,0},{100,354224848179261915075}]
```





