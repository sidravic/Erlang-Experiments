-module(errors).
-compile(export_all).

start() ->
	APid = spawn(errors, a, []),
	BPid = spawn(errors, b, [APid]).

a() ->
	io:format("Activated Process A ~p~n", [self()]),
	process_flag(trap_exit, true),
	receive
		{'EXIT', Pid, Why} ->			
			io:format("Inside A Processes Dying ~p because ~p~n", [Pid, Why]),
			sleep(10000);
		Any -> {random, Any}

	end.


b(APid) ->
	io:format("Activated Process B ~p~n", [self()]),
	process_flag(trap_exit, true),
	link(APid),
	receive
		{'EXIT', Pid, Why} ->			
			io:format("Inside B Processes Dying ~p because ~p~n", [Pid, Why]),
			sleep(10000);	
		Any -> {random, Any} 			
	end.
	

c(BPid, M) ->
	io:format("Activated Process  C ~p~n", [self()]),
	link(BPid),
	io:format("Linked to ~p~n", [BPid]),
	case M of
		{die, Reason} ->
			exit(Reason);
		{divide, N} ->
			1/N;
		normal -> true
	end.

sleep(Timeout) ->
	receive
	after Timeout ->
		true
	end.

