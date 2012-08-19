-module(accum).
-export([odds_and_evens/1]).

odds_and_evens(L) -> 
	odds_and_evens_with_accum(L, [], []).

odds_and_evens_with_accum([H|T], Odds, Evens) -> 
	case (H rem 2) of
		1 -> odds_and_evens_with_accum(T, [H|Odds], Evens);
		0 -> odds_and_evens_with_accum(T, Odds, [H|Evens])
	end;

odds_and_evens_with_accum([], Odds, Evens) ->
	{lists:reverse(Odds), lists:reverse(Evens)}.
	