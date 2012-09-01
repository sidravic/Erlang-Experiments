-module(anontest).
-export([start/0]).

start() -> spawn(fun() -> anon() end).

anon() -> 
	io:format("This is active no bitch"),
	receive	
		{X} -> X
	end.