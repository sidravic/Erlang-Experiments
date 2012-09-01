-module(receive_with_timeout).
-export([rec/0]).

rec() ->
	receive
		{Pid, Request} ->
			Request,
			rec()
	after 12000 ->
		io:format("Nothing Arrived. Im dying")
	end.
