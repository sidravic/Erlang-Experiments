-module(server_util).
-compile([export_all]).

start(ServerName, {Module, Function, Args}) ->	
	global:trans({ServerName, ServerName},
		fun() -> 
			case global:whereis_name(ServerName) of
				undefined ->
					global:register_name(ServerName, spawn(Module, Function, Args));
				_ ->
					ok				
			end
		end).

stop(ServerName) ->	
	global:trans({ServerName, ServerName}, 
		fun() ->
 			case global:whereis_name(ServerName) of
 				undefined ->
 					ok;
 				_ ->
 					global:send(ServerName, stop)			
			end
		end
	).
