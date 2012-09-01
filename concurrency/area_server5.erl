-module(area_server5).
-export([start/0, loop/0, rpc/2]).

start() -> spawn(fun loop/0).

rpc(Pid, Request) ->
	Pid ! {self(), Request},
	receive
		{Pid, Response} -> evaluateResponse(Response)
	end.

evaluateResponse({Value}) ->
						Value;
evaluateResponse({error, Value2}) ->
				Value2.


loop() ->
	receive
		{From, {rectange, Height, Width}} ->
			From ! {self(), {Height * Width}},
			loop();
		{From, {circle, Radius}} ->
			From ! {self(), {3.14159 * Radius * Radius}},
			loop();
		{From, Other} ->
			From ! {self(), {error, Other}},
			loop()
	end.
