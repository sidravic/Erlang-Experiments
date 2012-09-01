% -module(area_server0).
% -export([loop/0]).

% loop() ->
% 	receive
% 		{rectangle, Width, Ht} ->
% 			io:format("Area of the rectange is ~n", [Width * Ht]),
% 			loop();
% 		{circle, R} ->
% 			io:format("Area of the circle is ~p~n", [3.14159 * R * R]),
% 			loop();
% 		Other ->
% 			io:format("I don't know what the fuck to do with this shit ~p is ~n ", [Other]),
% 			loop()
% 	end.


-module(area_server0).
-export([loop/0]).

loop() ->
	receive
		{rectangle, Width, Ht} -> 
			io:format("Area of the rectangle is ~p~n", [Width * Ht]),
			loop();
		{Circle, R} ->
			io:format("Area of the circle is ~p~n", [Circle * R * R]),
			loop();
		Other ->
			io:format("Im a totally fucked up Erlang Programmer"),
			loop()
	end.
