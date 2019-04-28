%%%-------------------------------------------------------------------
%%% @author immidisa
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Apr 2019 23:36
%%%-------------------------------------------------------------------
-module(compute_handler).
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
  {[ <<"POST">>], Req, Opts}.

content_types_provided(Req, Opts) ->
  {[{<<"application/json">>, router}], Req, Opts}.

content_types_accepted(Req, Opts) ->
  {[{<<"application/json">>, router}], Req, Opts}.

router(Req, Opts) ->
  send_to_compute_pool(cowboy_req:has_body(Req),Req,Opts).

send_to_compute_pool(_,Req,Opts) ->
  {ok,Body,_} = cowboy_req:body(Req),
  [{<<"input">>,Number}] =jsx:decode(Body),
  Fibonacci_Number =compute_pool:compute(Number),
  Res = cowboy_req:set_resp_body(jsx:encode(Fibonacci_Number), Req),
  {true, Res, Opts}.


