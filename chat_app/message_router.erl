-module(message_router).
-define(SERVER, message_router).
-compile(export_all).


start() -> 
	Pid = spawn(message_router, route_message, [dict:new()]),
	erlang:register(?SERVER, Pid).	

stop() ->
	?SERVER ! shutdown.

send_chat_message(Addressee, MessageBody) ->
	?SERVER ! {send_chat_msg, Addressee, MessageBody}.

register_nickname(ClientName, PrintFun) ->
	?SERVER ! {register_nick, ClientName, PrintFun}.

unregister_nickname(ClientName) ->
	?SERVER ! {unregister_nick, ClientName}.

route_message(Clients) ->
	receive 
		{send_chat_msg, ClientName, MessageBody} ->			
			?SERVER ! {recv_chat_msg, ClientName, MessageBody},
			route_message(Clients);
		{recv_chat_msg, ClientName, MessageBody} ->
			case dict:find(ClientName, Clients) of
				{ok, PrintFun} ->
					PrintFun(MessageBody);
				error -> 
					io:format("Unknown Client")
			end,						
			route_message(Clients);
		{register_nick, ClientName, PrintFun} ->
			route_message(dict:store(ClientName, PrintFun, Clients)),
			route_message(Clients);
		{unregister_nick, ClientName} ->
			route_message(dict:erase(ClientName, Clients)),
			route_message(Clients);
		shutdown -> 
			io:format("Shutting Down");
		Oops -> 
			io:format("[WARNING!] Received ~p~n", [Oops]),
			route_message(Clients)
	end.
	