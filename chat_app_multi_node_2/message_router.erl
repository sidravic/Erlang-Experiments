-module(message_router).
-define(SERVER, message_router_pid).
-compile(export_all).

start() -> 
	global:trans({?SERVER, ?SERVER},
		fun() -> 
			case global:whereis_name(?SERVER) of
				undefined ->
					global:register_name(?SERVER, spawn(message_router, route, [dict:new()]));
				_ ->
					ok				
			end
		end).
	% global:register(?SERVER, spawn(message_router, route, [dict:new()]))
	% erlang:register(?SERVER, spawn(message_router, route, [dict:new()])).

send_chat_msg(Addressee, MessageBody) ->
	global:send(?SERVER, {send_chat_msg, Addressee, MessageBody}).
	% ?SERVER ! {send_chat_msg, Addressee, MessageBody}.

register_nick(ClientName, ClientPid) ->
	global:send(?SERVER, {register_nick, ClientName, ClientPid}).
	% ?SERVER ! {register_nick, ClientName, ClientPid}.

unregister_nick(ClientName) ->
	global:send(?SERVER, {unregister_nick, ClientName}).
	% ?SERVER ! {unregister_nick, ClientName}.

stop() ->
	global:trans({?SERVER, ?SERVER}, 
		fun() ->
 			case global:whereis_name(?SERVER) of
 				undefined ->
 					ok;
 				_ ->
 					global:send(?SERVER, stop)			
			end
		end
	).
	
	% ?SERVER ! stop.

route(Clients) ->
	receive
		{send_chat_msg, Addressee, MessageBody} ->
			case dict:find(Addressee, Clients) of 
				{ok, ClientPid} ->
					ClientPid ! {printmsg, MessageBody};
				error ->
					io:format("Could not find NickName ~p~n", [Addressee])
			end,			
			route(Clients);		
		{register_nick, ClientName, ClientPid}  ->
			route(dict:store(ClientName, ClientPid, Clients));
		{unregister_nick, ClientName} ->
			case dict:find(ClientName, Clients) of
				{ok, ClientPid} ->
					ClientPid ! stop,
					route(dict:erase(ClientName, Clients));
				error ->
					ok,
					route(Clients)
			end;			
		stop ->
			ok;
		Oops ->
			io:format("[ERROR] Invalid Message in Router ~p~n", [Oops]),
			route(Clients)
	end.