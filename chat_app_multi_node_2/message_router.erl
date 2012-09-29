-module(message_router).
-compile(export_all).
-define(SERVER, message_router).

start() -> 
	server_util:start(?SERVER, {message_router, route, [dict:new()]}),
	message_store:start().
	% global:trans({?SERVER, ?SERVER},
	% 	fun() -> 
	% 		case global:whereis_name(?SERVER) of
	% 			undefined ->
	% 				global:register_name(?SERVER, spawn(message_router, route, [dict:new()]));
	% 			_ ->
	% 				ok				
	% 		end
	% 	end).
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
	server_util:stop(?SERVER),
	message_store:stop().
	% global:trans({?SERVER, ?SERVER}, 
	% 	fun() ->
 	%		case global:whereis_name(?SERVER) of
 	%			undefined ->
 	% 				ok;
 	%			_ ->
 	%				global:send(?SERVER, stop)			
	% 		end
	% 	end
	% ).
	
	% ?SERVER ! stop.

route(Clients) ->
	receive
		{send_chat_msg, Addressee, MessageBody} ->
			case dict:find(Addressee, Clients) of 
				{ok, ClientPid} ->
					ClientPid ! {print_msg, MessageBody};
				error ->
					message_store:save_message(Addressee, MessageBody),
					io:format("Offline Message Store... ~p~n", [Addressee])
			end,			
			route(Clients);		
		{register_nick, ClientName, ClientPid}  ->			
			Messages = message_store:find_message(ClientName),
			lists:foreach(fun(Msg) ->  ClientPid ! {print_msg, Msg} end, Messages),
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