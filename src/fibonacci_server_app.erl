%%%-------------------------------------------------------------------
%% @doc fibonacci-server public API
%% @end
%%%-------------------------------------------------------------------

-module(fibonacci_server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Routes = [ {
        '_',
        [
            {"/fibonacci/compute", compute_handler, []},
            {"/fibonacci/history_count", count_handler, []},
            {"/fibonacci/history", history_handler, []}
        ]
    } ],
    Dispatch = cowboy_router:compile(Routes),
    NumAcceptors = 10,
    TransOpts = [ {ip, {0,0,0,0}}, {port, 5001} ],
    ProtoOpts = [{env, [{dispatch, Dispatch}]}],
    {ok,_}  =compute_pool:start(),
    {ok, Pid} = cowboy:start_http(fibonacci_server,
        NumAcceptors, TransOpts, ProtoOpts),

    {ok,Pid}.


%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
