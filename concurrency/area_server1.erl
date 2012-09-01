-module(area_server1).
-export([loop/0, rpc/2]).

rpc(Pid, Request) ->
	Pid ! {self(), Request},
	receive
		{Pid, Response} -> 
					Response		
	end.

loop() ->
	receive
		{From, {rectange, Width, Height}} ->
			From ! {self(), {Width * Height}},
			loop();
		{From, {circle, Radius}} ->
			From ! {self(), {3.14159 * Radius * Radius}},
			loop();
		{From, Other} ->
			From ! {self(), {error, Other}},
			loop()
	end.


