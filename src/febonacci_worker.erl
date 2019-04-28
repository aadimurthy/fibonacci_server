%%%-------------------------------------------------------------------
%%% @author immidisa
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Apr 2019 23:56
%%%-------------------------------------------------------------------
-module(febonacci_worker).
-author("immidisa").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).
init(_) ->
  {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
  {reply, Reply :: term(), NewState :: #state{}} |
  {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_call({compute,Input}, _From, State) when is_list(Input) ->
  case Input=:=lists:sort(Input) of
    true ->
      Result = compute_fibonacci(Input),
      lists:zipwith(fun(IElem,RElem)->
        ets:insert(feb_result,{IElem, RElem}),
        ets:update_counter(input_count, IElem, {2, 1}, {IElem, 0})
                    end,
        Input,Result),
      {reply, Result, State};
    _ ->
      {reply, "Input list should be sorted one", State}
  end;

handle_call({compute,Input}, _From, State) ->
  Result = compute_fibonacci(Input),
  ets:update_counter(input_count, Input, {2, 1}, {Input, 0}),
  ets:insert(feb_result,{Input, Result}),
  {reply, Result, State};

handle_call(history, _From, State) ->
  Count_List = ets:match_object(input_count, {'$0', '$1'}),
  History=
    lists:map(fun({Input,_Count})->
      hd(ets:match_object(feb_result, {Input, '$1'}))
              end,
      Count_List),

  {reply, History, State};

handle_call(count, _From, State) ->
  Result = ets:match_object(input_count, {'$0', '$1'}),
  {reply, Result, State}.




%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

compute_fibonacci(0) -> 0;
compute_fibonacci(1) -> 1;
compute_fibonacci(N) when is_list(N)->
  Res=[compute_fibonacci(X)||X<-lists:reverse(N)], % We always process higher element first to get more results to be cached
  lists:reverse(Res);
compute_fibonacci(N) ->
  Num2 = case ets:lookup(feb_result,N-2) of
           [] ->
             Second_Prev =  compute_fibonacci(N-2),
             ets:insert(feb_result,{N-2, Second_Prev}),
             Second_Prev;
           [{_,Second_Prev}] -> Second_Prev
         end,
  Num1 = case ets:lookup(feb_result,N-1) of
           [] ->
             First_Prev =  compute_fibonacci(N-1),
             ets:insert(feb_result,{N-1, First_Prev}),
             First_Prev;
           [{_,First_Prev}] -> First_Prev
         end,
  Num2 + Num1.