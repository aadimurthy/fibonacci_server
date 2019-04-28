%%%-------------------------------------------------------------------
%%% @author immidisa
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Apr 2019 23:39
%%%-------------------------------------------------------------------
-module(compute_pool).
-author("immidisa").

%% API
-export([ start/0, compute/1, history_count/0, history/0]).


start() ->
  compute_pool_sup:start_link(?MODULE).

compute(Input) ->
  wpool:call(?MODULE, {compute, Input}).

history_count() ->
  wpool:call(?MODULE, count).

history()->
  wpool:call(?MODULE, history).





%%%===================================================================
%%% private functions
%%%===================================================================



