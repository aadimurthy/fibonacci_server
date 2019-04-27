%%%-------------------------------------------------------------------
%%% @author immidisa
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Apr 2019 23:49
%%%-------------------------------------------------------------------
-module(compute_pool_sup).
-author("immidisa").

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link(_PoolName) ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link(PoolName) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, PoolName).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
    MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
    [ChildSpec :: supervisor:child_spec()]
  }} |
  ignore |
  {error, Reason :: term()}).

init(PoolName) ->
  PoolOpt  = [ {overrun_warning, infinity},
    {overrun_handler, {error_logger, warning_report}}
    , {workers, 50}
    , {worker, {febonacci_worker,worker_config()}}
  ],

  Flags = #{ strategy  => one_for_one
    , intensity => 1000
    , period    => 3600
  },

  ets:new(feb_result, [set,public, named_table]),
  ets:new(input_count, [set,public, named_table]),

  Children = [#{ id       => wpool
    , start    => {wpool, start_pool, [PoolName, PoolOpt]}
    , restart  => permanent
    , shutdown => 5000
    , type     => supervisor
    , modules  => [wpool]
  }],

  {ok, {Flags, Children}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

worker_config() ->
  [].