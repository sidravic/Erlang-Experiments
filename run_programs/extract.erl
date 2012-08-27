% -module(extract).
% -export([attribute/2]).

% attribute(File, Key) ->
% 	case beam_lib:chunks(File, [attributes]) of
% 		{ok, {Module, [attributes, L]}} ->
% 			case lookup(Key, L) of
% 				{_, Val} -> Val;
% 				error -> exit(badAttribute)
% 			end;
% 		_ -> exit(badFile)
% 	end.


% lookup(Key, [{Key, Val}| _]) -> {ok, Val};
% lookup(Key, [_|T]) -> lookup(Key, T);
% lookup(_, []) -> error.

% {ok,{attrs,[{attributes,[{author,[{joe,armstrong}]},
%                          {purpose,"example of attributes"},
%                          {vsn,[1234]}]}]}}

-module(extract).
-export([attribute/2]).

attribute(File, Key) ->
	case beam_lib:chunks(File, [attributes]) of
		{ok, {Module, [{attributes, L}]}} ->
			case lookup(Key, L) of
				{_, Val} -> Val;
				error -> exit(badAttribute)
			end;

		_ -> exit(badFile)
	end.

lookup(Key,[{Key, Val} | T]) -> {ok, Val};
lookup(Key, [_|T]) -> lookup(Key, T);
lookup(_, []) -> error.

