-module(mixed).
-export([total/1]).
%-import(lists, [map/2, sum/1]).


total(L) ->
	lists:sum(lists:map(fun({What, Count}) -> shop:cost(What) * Count end, L)).