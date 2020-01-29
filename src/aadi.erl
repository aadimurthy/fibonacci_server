-module(aadi).
-export([test/0]).

test()->
lager:error("Some message").
