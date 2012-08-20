-module(stacktraces).
-compile(export_all).

demo2() ->
	[demo3(I) || I <- [1,2,3]].

generate_exception(1) ->
	throw(a);
generate_exception(2) -> a;
generate_exception(3) -> erlang:error(5).

demo3(I) ->
	try generate_exception(I)
	catch		
		error:X -> {X, erlang:get_stacktrace()};
		throw:X -> {X, erlang:get_stacktrace()};
		_:_ -> {everythingElse, erlang:get_stacktrace()}
	end.