-module(message_store).
-compile([export_all]).
-define(SERVER, message_store).
-include_lib("stdlib/include/qlc.hrl").

-record(chat_message, {addressee, body, created_on}).

start() ->
	server_util:start(?SERVER, {message_store, run, [true]}).

stop() ->
	server_util:stop(?SERVER).

save_message(Addressee, Message) ->
	global:send(?SERVER, {save_msg, Addressee, Message}).

find_message(Addressee) ->
	global:send(?SERVER, {find_msg, Addressee, self()}),
	receive
		{ok, Messages} ->
			Messages
	end.

run(FirstTime) ->
	if 
		FirstTime == true ->
			message_store:init_store(),
			run(false);
		true ->			
			receive
				{save_msg, Addressee, MessageBody} ->
					store_message(Addressee, MessageBody),
					run(FirstTime);
				{find_msg, Addressee, Pid} ->
					Messages = get_messages(Addressee),
					Pid ! {ok, Messages},
					run(FirstTime);
				shutdown ->
					mnesia:stop(),
					io:format("Late Bitches... ")
			end
	end.

delete_messages(Messages) ->
	F = fun() ->
			% [mnesia:delete_object(X) || X <- Messages ]
			lists:foreach(fun(Msg) -> mnesia:delete_object(Msg)  end, Messages)
		end,
	mnesia:transaction(F).

get_messages(Addressee) ->
	F = fun()->
			Query =	qlc:q([X || X <- mnesia:table(chat_message),
					   			X#chat_message.addressee =:= Addressee]),
		Result = qlc:e(Query),		
		io:format("~p~n is", [Result]),		
		delete_messages(Result),
		Result
	end,		
	{atomic, Messages} = mnesia:transaction(F),
	ChatMessageBodies = [Msg#chat_message.body || Msg <- Messages],
	io:format("RESULTS from CHATMESSAGE BODIES ~p~n", [ChatMessageBodies]),
	ChatMessageBodies.


store_message(Addressee, MessageBody) ->
	F = fun() ->
			{_,CreatedOn,_} = erlang:now(),
			Msg = #chat_message{addressee=Addressee, body=MessageBody, created_on=CreatedOn},
			mnesia:write(Msg)
		end,
	mnesia:transaction(F).



init_store() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	try
		mnesia:table_info(chat_message, type)
	catch
		exit:_ ->
			mnesia:create_table(chat_message, [{attributes, record_info(fields, chat_message)}, {type, bag}, {disc_copies, [node()]}])
	end.