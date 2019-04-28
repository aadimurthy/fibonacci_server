%%%-------------------------------------------------------------------
%%% @author immidisa
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Apr 2019 05:09
%%%-------------------------------------------------------------------
-module(count_handler).
-author("immidisa").

%% API
-export([init/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).
-export([allowed_methods/2]).
-export([router/2]).

init(Req, Opts) ->
  {cowboy_rest, Req, Opts}.

allowed_methods(Req, Opts) ->
  {[ <<"GET">>], Req, Opts}.

content_types_provided(Req, Opts) ->
  {[{<<"application/json">>, router}], Req, Opts}.

content_types_accepted(Req, Opts) ->
  {[{<<"application/json">>, router}], Req, Opts}.

router(Req, Opts) ->
  {ok,Count}=compute_pool:history_count(),
  {ok, Req2} = cowboy_req:reply(200,
    [{<<"content-type">>, <<"application/json">>}],jsx:encode(Count),
    Req),
  {ok, Req2, Opts}.

