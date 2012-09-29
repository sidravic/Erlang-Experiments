-module(server2).
-export([start/2, rpc/2, loop/3]).


start(Name, Module) ->
	erlang:register(Name, spawn(server2, loop, [Name, Module, Module:init()])).

% (name_server, {add, Name Place}})
rpc(Name, Request) ->
	Name ! {request, self(), Request},
	receive
		{Name, ok, Response} ->
			Response;
		{Name, crash} -> exit(rpc)
	end.

loop(Name, Mod, OldState) ->
	receive
		{request, From, Request} ->
			try Mod:handle(Request, OldState) of
				{Response, NewState} ->
					From ! {Name, ok, Response},
					loop(Name, Mod, NewState)
			catch
				_:Why ->
					log_error(Name, Request, Why),
					From ! {Name, crash},
					loop(Name, Mod, OldState)
			end
	end.

log_error(Name, Request, ErrorReason) ->
	io:format("Server ~p request ~p ~n caused an exception ~p ~n",[Name, Request, ErrorReason]).