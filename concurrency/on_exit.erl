-module(on_exit).
-compile(export_all).

keep_alive(Name, Fun) ->	
	register(Name, Pid = spawn(Fun)),	
	io:format("Called to activate ~p", [Pid]),
	on_exit(Pid, self(), Fun),
	Pid.


on_exit(Pid, SystemPid, Fun) ->
	spawn(fun() -> 
			process_flag(trap_exit, true),
			link(Pid),
			receive
				{'EXIT', Pid, Why} ->
					io:format("Process ~p is dying because ~p~n", [Pid, Why]),
					keep_alive(alive, Fun)
			end
		end
		).


