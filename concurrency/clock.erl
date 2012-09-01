-module(clock).
-export([start/3, cancel/0]).

start(Time, TimeElapsed, Fun) -> 
	register(clock_pid, spawn(fun() -> tick(Time, TimeElapsed, Fun) end)).

cancel() -> clock_pid ! cancel.

tick(Time, TimeElapsed, Fun) ->
	receive
		cancel -> void
	after Time ->
		Fun(),
		TimeElapsed2 = TimeElapsed + 10,
		tick(Time, TimeElapsed2,Fun)
	end.
