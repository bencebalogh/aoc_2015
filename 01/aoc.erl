-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    {ok, Input} = file:read_file(input),
    lists:foldl(fun
        ($), Acc) -> Acc - 1;
        ($(, Acc) -> Acc + 1
    end, 0, binary:bin_to_list(Input) ).

part2() ->
    {ok, Input} = file:read_file(input),
    floor_check({0, 0}, binary:bin_to_list(Input) ).

floor_check({Floor, Index}, _) when Floor == -1 ->
    Index;
floor_check({Floor, Index}, [$( | Tail]) ->
    floor_check({Floor + 1, Index + 1}, Tail);
floor_check({Floor, Index}, [$) | Tail]) ->
    floor_check({Floor - 1, Index + 1}, Tail).