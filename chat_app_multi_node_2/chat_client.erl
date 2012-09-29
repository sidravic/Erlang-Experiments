-module(chat_client).
-compile(export_all).

start_router() ->
	message_router:start().

stop() ->
	message_router:stop().

register_nick(NickName) ->
	Pid = spawn(chat_client, print_msg, [NickName]),
	message_router:register_nick(NickName, Pid).

unregister_nick(NickName) ->
	message_router:unregister_nick(NickName).

send_message(NickName, MessageBody) ->
	message_router:send_chat_msg(NickName, MessageBody).


print_msg(NickName) ->
	receive
		{print_msg, MessageBody} ->			
			io:format("~p received ~p~n", [NickName, MessageBody]),
			print_msg(NickName);
		stop ->
			ok;
		Oops ->
			io:format("[ERROR] Invalid Message to print msg ~p~n", [Oops]),
			print_msg(NickName)

	end.

