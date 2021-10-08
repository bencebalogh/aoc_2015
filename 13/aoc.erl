-module(aoc).
-export([part1/0,part2/0]).

part1() ->
    find_happiest_value(input()).

part2() ->
    {Values, Names} = input(),
    NewValues = lists:foldl(fun (N, Acc) -> maps:put({"me", N}, 0, maps:put({N, "me"}, 0, Acc)) end, Values, Names),
    NewNames = ["me" | Names],
    find_happiest_value({NewValues, NewNames}).

find_happiest_value({Values, Names}) ->
    lists:max(lists:map(fun (Seating) ->
        lists:sum(lists:map(fun (N) ->
            [N1, N2] = find_neighbours(N, Seating ++ [hd(Seating)], true, []),
            maps:get({N, N1}, Values) + maps:get({N, N2}, Values)
        end, Seating))
    end, perms(Names))).

input() ->
    {ok, Input} = file:read_file(input),
    {ok, RE} = re:compile("(\\w+)\swould\\s(gain|lose)\\s(\\d+)\\shappiness\\sunits\\sby\\ssitting\\snext\\sto\\s(\\w+)."),
    {V, S} = lists:foldl(fun (L, {Acc, Names}) ->
        {match, [[_, Name, Modifier, Amount, Neighbour]]} = re:run(L, RE, [global, {capture, all, list}]),
        {I, _} = string:to_integer(Amount),
        M = case Modifier of
            "gain" -> 1;
            "lose" -> -1
        end,
        {maps:put({Name, Neighbour}, I * M, Acc), sets:add_element(Name, Names)}
    end, {#{}, sets:new()}, string:split(Input, "\n", all)),
    {V, sets:to_list(S)}.

find_neighbours(Name, [Neighbour | [Name | T]], _, []) ->
    find_neighbours(Name, [Name | T], false, [Neighbour]);
find_neighbours(Name, [Name | [Neighbour | T]], false, []) ->
    find_neighbours(Name, T, false, [Neighbour]);
find_neighbours(Name, [Name | [Neighbour | _]], false, [Neighbour2]) ->
    [Neighbour2, Neighbour];
find_neighbours(Name, [Name | [Neighbour | T]], true, []) ->
    Neighbour2 = hd(tl(lists:reverse(T))),
    [Neighbour, Neighbour2];
find_neighbours(Name, [Neighbour | [Name | _]], false, [Neighbour2]) ->
    [Neighbour2, Neighbour];
find_neighbours(Name, [_ | T], _, Neighboursfound) ->
    find_neighbours(Name, T, false, Neighboursfound).

perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].