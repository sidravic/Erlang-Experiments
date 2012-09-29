-module(server_code_swap).
-export([start/2, rpc/2, swap_code/2, loop/3]).

start(Name, Mod) ->
	erlang:register(Name, spawn(server_code_swap, loop, [Name, Mod, Mod:init()])),
	io:format("Server started...").

swap_code(Name, Mod) -> rpc(Name, {swap_code, Mod}).

rpc(Name, Request) ->
	io:format("~p ~p  ~n Came in", [Name, Request]),
	Name ! {self(), Request},
	receive
		{Name, Response} ->
			Response
	end.


loop(Name, Mod, OldState) ->
	receive
		{From, {swap_code, NewMod}} ->
			From ! {Name, ack},
			loop(Name, NewMod, OldState);
		{From, Request} ->
			io:format("Request is ~p", [Request]),
			{Response, NewState} = Mod:handle(Request, OldState),
			From ! {Name, Response},
			loop(Name, Mod, NewState)
	end.
