-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    Grid = lists:foldl(fun ({Action, {{Sx, Sy}, {Ex, Ey}}}, Grid) ->
        lists:foldl(fun (X, GridI) ->
            lists:foldl(fun (Y, GridIi) ->
                case Action of
                    on ->
                        case maps:get({X,Y}, GridIi, off) of
                            on -> GridIi;
                            off -> maps:put({X, Y}, on, GridIi)
                        end;
                    off ->
                        case maps:get({X,Y}, GridIi, off) of
                            on -> maps:put({X, Y}, off, GridIi);
                            off -> GridIi
                        end;
                    toggle ->
                        case maps:get({X,Y}, GridIi, off) of
                            on -> maps:put({X, Y}, off, GridIi);
                            off -> maps:put({X, Y}, on, GridIi)
                        end
                end
            end, GridI, lists:seq(Sy, Ey))
        end, Grid, lists:seq(Sx, Ex))
    end, maps:new(), parse_input()),
    erlang:length(lists:filter(fun (X) -> X == on end, maps:values(Grid))).

part2() ->
    Grid = lists:foldl(fun ({Action, {{Sx, Sy}, {Ex, Ey}}}, Grid) ->
        lists:foldl(fun (X, GridI) ->
            lists:foldl(fun (Y, GridIi) ->
                case Action of
                    on ->
                        maps:put({X, Y}, maps:get({X,Y}, GridIi, 0) + 1, GridIi);
                    off ->
                        case maps:get({X,Y}, GridIi, 0) -1 of
                            I when I >= 0 -> maps:put({X,Y}, I, GridIi);
                            _ -> GridIi
                        end;
                    toggle ->
                        maps:put({X, Y}, maps:get({X,Y}, GridIi, 0) + 2, GridIi)
                end
            end, GridI, lists:seq(Sy, Ey))
        end, Grid, lists:seq(Sx, Ex))
    end, maps:new(), parse_input()),
    lists:sum(maps:values(Grid)).

parse_input() ->
    {ok, Input} = file:read_file(input),
    Lines = lists:map(fun (L) ->
        binary:bin_to_list(L)
    end, string:split(Input, "\n", all)),
    {ok, RE} = re:compile("(\\d+),(\\d+)\sthrough\\s(\\d+),(\\d+)"),
    Commands = lists:map(fun
        ("turn on " ++ Coords) ->
            {on, parse_coords(Coords, RE)};
        ("turn off " ++ Coords) ->
            {off, parse_coords(Coords, RE)};
        ("toggle " ++ Coords) ->
            {toggle, parse_coords(Coords, RE)}
    end, Lines),
    Commands.

parse_coords(Str, RE) ->
    {match, [_, {Sxs, Sxe}, {Sys, Sye}, {Exs, Exe}, {Eys, Eye}]} = re:run(Str, RE),
    {
        {
            erlang:list_to_integer(string:substr(Str, Sxs + 1, Sxe)),
            erlang:list_to_integer(string:substr(Str, Sys + 1, Sye))
        },
        {
            erlang:list_to_integer(string:substr(Str, Exs + 1, Exe)),
            erlang:list_to_integer(string:substr(Str, Eys + 1, Eye))
        }
    }.