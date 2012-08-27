-module(shop_update).
-export([total_update/1]).

total_update([{What, Count}| T]) -> shop:cost(What) * Count + total_update(T);
total_update([]) -> 0.