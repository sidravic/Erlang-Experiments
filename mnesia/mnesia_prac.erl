% -module(mnesia_prac).
% -import(lists, [foreach/2]).
% -compile(export_all).

% %% IMPORTANT: The next line must be included
% %%            if we want to call qlc:q(...)

% -include_lib("stdlib/include/qlc.hrl").
% -record(shop, {item, quantity, cost}).
% % -record(cost, {name, price}).
% % -record(design, {id, plan}).

% do_this_once() ->
% 	mnesia:create_schema([node()]),
% 	mnesia:start(),
% 	mnesia:create_table(shop, [{attributes, record_info(fields, shop)}]),
% 	mnesia:stop().

% start() ->
%     mnesia:start(),
%     mnesia:wait_for_tables([shop,cost,design], 20000).



% example_tables() ->
% 	[{shop, apple, 20, 2.3},
% 	 {shop, orange,  100,  3.8},
%      {shop, pear,    200,  3.6},
%      {shop, banana,  420,  4.5},
%      {shop, potato,  2456, 1.2},	
%      {cost, apple,   1.5},
%      {cost, orange,  2.4},
%      {cost, pear,    2.2},
%      {cost, banana,  1.5},
%      {cost, potato,  0.6}
% 	].

% reset_tables() ->
% 	mnesia:clear_table(shop),
% 	mnesia:clear_table(cost),
% 	F = fun() ->
% 			[mnesia:write(X) || X <- mnesia_prac:example_tables()]
% 		end,
% 	mnesia:transaction(F).


% show_table(TableName) ->
% 	do(qlc:q([X || X <- mnesia:table(TableName)])).

% select_item_and_cost() ->
% 	do(qlc:q([{X#shop.item, X#shop.cost} || X <- example_tables()])).

% do(CompiledQuery) ->
% 	F = fun() -> qlc:e(CompiledQuery) end,
% 	{atomic, Val} = mnesia:transaction(F),
% 	Val.


-module(mnesia_prac).
-import(lists, [foreach/2]).
-compile(export_all).

%% IMPORTANT: The next line must be included
%%            if we want to call qlc:q(...)
-include_lib("stdlib/include/qlc.hrl" ).

-record(shop, {item, quatity, cost}).
-record(cost, {name, price}).
-record(design, {id, plan}).

 %Initiate a new schema with an attribute that specifies on which node, or nodes, the database will operate.
 % Start Mnesia itself.

 % The expression record_info(fields, RecordName) is 
 % processed by the Erlang preprocessor and evaluates to a list 
 % containing the names of the different fields for a record.
do_this_once() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(shop, [{attributes, record_info(fields, shop)}, {disc_copies, [node()]}]),
	mnesia:create_table(cost, [{attributes, record_info(fields, cost)}]),
	mnesia:create_table(design, [{attributes, record_info(fields, design)}]),
	mnesia:stop().


start() ->
	mnesia:start(),
	mnesia:wait_for_tables([shop, cost, design], 20000).


demo(TableName) ->
	do(qlc:q([X || X <- mnesia:table(TableName)])).


example_tables() ->
	[{shop, apple, 20, 2.3},
	 {shop, orange,  100,  3.8},
     {shop, pear,    200,  3.6},
     {shop, banana,  420,  4.5},
     {shop, potato,  2456, 1.2},
     %% The cost table
     {cost, apple,   1.5},
     {cost, orange,  2.4},
     {cost, pear,    2.2},
     {cost, banana,  1.5},
     {cost, potato,  0.6}
	].

reset_tables() ->
	mnesia:clear_table(shop),
	F = fun() -> 			
		%foreach(fun mnesia:write/1, example_tables())
		 [mnesia:write(X) || X <- example_tables()]	
	end,
	mnesia:transaction(F).

demo2(TableName) ->
	do(qlc:q([{X#shop.item, X#shop.cost }|| X <- mnesia:table(TableName)])).



add_row(Name, Quantity, Cost) ->
	Row = #shop{item=Name, quatity=Quantity, cost=Cost},
	F= fun() ->
		mnesia:write(Row)
	end,
	mnesia:transaction(F).

remove_row(Item) ->
	Oid = {shop, Item},
	F = fun() ->
		mnesia:delete(Oid)
	end,
	mnesia:transaction(F).


do(CompiledQuery) ->
	F = fun() -> qlc:e(CompiledQuery) end,
	{atomic, Val} =  mnesia:transaction(F),
	Val.

	



