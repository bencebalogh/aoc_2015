-module(aoc).
-export[part1/0,part2/0].
-define(SIZE, 100).

part1() ->
    R = lists:foldl(fun (_, G) -> step(G, false) end, input(), lists:seq(1, 100)),
    count(maps:values(R)).

part2() ->
    R = lists:foldl(fun (_, G) -> step(G, true) end, set_corners(input()), lists:seq(1, 100)),
    count(maps:values(R)).

step(Grid, Corners) ->
    G = lists:foldl(fun (X, Acc) ->
        lists:foldl(fun (Y, A) ->
            case maps:get({X, Y}, Grid) of
                off ->
                    case count(get_neighbours(Grid, {X, Y})) of
                        I when I == 3 -> maps:put({X, Y}, on, A);
                        _ -> maps:put({X, Y}, off, A)
                    end;
                on ->
                    case count(get_neighbours(Grid, {X, Y})) of
                        I when (I == 2) or (I == 3) -> maps:put({X, Y}, on, A);
                        _ -> maps:put({X, Y}, off, A)
                    end
            end
        end, Acc, lists:seq(1, ?SIZE))
    end, #{}, lists:seq(1, ?SIZE)),
    case Corners of
        true -> set_corners(G);
        false -> G
    end.

set_corners(Grid) ->
    maps:put({100, 1}, on,
        maps:put({100, 100}, on,
            maps:put({1,100}, on,
                maps:put({1, 1}, on, Grid)
            )
        )
    ).

count(List) ->
    length(lists:filter(fun (V) -> V == on end, List)).

get_neighbours(Grid, {X, Y}) ->
    [
        maps:get({X - 1, Y - 1}, Grid, off),
        maps:get({X, Y - 1}, Grid, off),
        maps:get({X + 1, Y - 1}, Grid, off),
        maps:get({X + 1, Y + 1}, Grid, off),
        maps:get({X, Y + 1}, Grid, off),
        maps:get({X - 1, Y + 1}, Grid, off),
        maps:get({X + 1, Y}, Grid, off),
        maps:get({X - 1, Y}, Grid, off)
    ].

input() ->
    {ok, Input} = file:read_file(input),
    Lines = string:split(Input, "\n", all),
    Val = fun
        ($#) -> on;
        ($.) -> off
    end,
    lists:foldl(fun ({Line, X}, Acc) -> 
        lists:foldl(fun ({C, Y}, A) -> maps:put({X, Y}, Val(C), A) end, Acc, lists:zip(binary:bin_to_list(Line), lists:seq(1, string:length(Line))))
    end, #{}, lists:zip(Lines, lists:seq(1, length(Lines)))).