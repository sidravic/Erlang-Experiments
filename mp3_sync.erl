-module(mp3_sync).
-compile(export_all).

find_sync(Bin, N) ->
	case is_header(N, Bin) of
		{ok, Len1, _} -> 
			case is_header(N + Len1, Bin) of
				{ok, Len2, _} ->
					case is_header(N + Len2 + Len1, Bin) of
						{ok, _, _} -> 
							{ok, N};
						error ->
							find_sync(Bin, N+1)
					end;
				error ->
					find_sync(Bin, N+1)
			end;
		error -> 
			find_sync(Bin, N+1)
	end.

is_header(N, Bin) -> {ok, FrameLength, Info} | error.
