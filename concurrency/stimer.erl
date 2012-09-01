-module(stimer).
-export([start/2, cancel/0]).

start(Time, Fun) -> 
	Timer_pid = spawn(fun() -> timer(Time, Fun) end),
	io:write(Timer_pid),
	register(timerpid, Timer_pid).

cancel() -> timerpid ! cancel.

timer(Time, Fun) ->	
	receive
		cancel -> registered()
	after Time ->
		Fun()
	end.
