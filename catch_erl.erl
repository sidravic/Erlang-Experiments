-module(catch_erl).
-compile(export_all).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};
generate_exception(5) -> erlang:error(a).

demo() -> [{I, catch generate_exception(I)} || I <- [1,2,3,4,5]].