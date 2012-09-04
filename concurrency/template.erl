-module(template).
-export([start/0, rpc/2]).


start() -> 
	spawn(fun() -> loop([]) end).

rpc(Pid, Request) ->
	Pid ! Request,
	receive 
		{Pid, Response} -> 
			Response
	end.

loop(X) ->
	receive
		Any -> io:format("Received ~p~n", [Any]),
		
		loop(X)
	end.