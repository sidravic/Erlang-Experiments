-module(exception_handling).
-export([demo/0]).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};
generate_exception(5) -> erlang:error(a).

demo() -> [catcher(I) || I <- [1,2,3,4,5]].

catcher(N) ->


