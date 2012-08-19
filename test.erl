-module(test).
-export([test/1,test/2]).

test([H|T]) -> {H,T};
test(X) -> X.

test(X, Y) -> {X,Y}.