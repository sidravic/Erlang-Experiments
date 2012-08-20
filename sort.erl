-module(sort).
-export([qsort/1]).


qsort([]) -> [];
qsort([Pivot|Tail]) ->
	qsort([X || X <- Tail, X < Pivot])
	++ [Pivot] ++
	qsort([X || X <- Tail, X >= Pivot]).



[3,2,1,4]
3,[2,1,4]

[2,1]