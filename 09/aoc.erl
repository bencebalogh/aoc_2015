-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    {Paths, Cities} = input(),
    lists:min(lists:map(fun (C) ->
        get_paths(Paths, C, 0, fun lists:min/1) end,
    sets:to_list(Cities))).

part2() ->
    {Paths, Cities} = input(),
    lists:max(lists:map(fun (C) ->
        get_paths(Paths, C, 0, fun lists:max/1) end,
    sets:to_list(Cities))).

input() ->
    {ok, Input} = file:read_file(input),
    lists:foldl(fun (L, {Paths, Cities}) ->
        [City1, <<"to">>, City2, D] = string:lexemes(L, " ="),
        {Distance, _} = string:to_integer(D),
        {maps:put({City2, City1}, Distance, maps:put({City1, City2}, Distance, Paths)), sets:add_element(City2, sets:add_element(City1, Cities))}
    end, {#{}, sets:new()}, string:split(Input, "\n", all)).

get_paths(Options, _, Counter, _) when map_size(Options) == 0 -> Counter;
get_paths(Options, Location, Counter, CompareFn) ->
    NextCities = maps:filter(fun ({City1, _}, _) -> City1 == Location end, Options),
    NC2 = lists:map(fun ({_Location, City}) -> City end, maps:keys(NextCities)),
    CompareFn(lists:map(fun (NextCity) ->
        NextOptions = maps:remove({NextCity, Location}, maps:remove({Location, NextCity}, Options)),
        NextOptions2 = maps:filter(fun ({City1, City2}, _) -> (City1 /= Location) and (City2 /= Location) end, NextOptions),
        get_paths(NextOptions2, NextCity, Counter + maps:get({Location, NextCity}, Options), CompareFn)
    end, NC2)).