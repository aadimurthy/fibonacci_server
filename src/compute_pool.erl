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
-export([ start/0, compute/1]).


start() ->
  compute_pool_sup:start_link(?MODULE).

compute(Body) ->
  wpool:call(?MODULE, {compute, Body}).

%%%===================================================================
%%% private functions
%%%===================================================================



