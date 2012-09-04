-module(appending).
%-export([append/2, fib/1]).
-export([fib/1]).


% append([H|T], Tail) ->
% 	[H| append(T, Tail)];
% append([], Tail) -> Tail.


% fib(0) -> 0;
% fib(1) -> 1;
% fib(N) when N > 1 -> fib(N - 1) + fib(N - 2).
	
fib(N) ->
	fib(0, 1, N).

fib(Previous, Current, Limit) when Current < Limit ->
	[Current | fib(Current, Previous + Current, Limit)];
fib(Previous, Current, Limit) when Current > Limit -> [].



