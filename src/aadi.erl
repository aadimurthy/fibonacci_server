-module(aadi).
-export([test/0]).

test()->
lager:debug("Some message").
