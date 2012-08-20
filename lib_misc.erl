-module(lib_misc).
-compile(export_all).

sqrt(X) when X > 0  ->
	erlang:error({invalidsquareRootArgument, X});
sqrt(X) ->
	math:sqrt(X).