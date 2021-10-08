-module(aoc).
-export([part1/0, part2/0]).
-define(SUM, 150).

part1() ->
    length(lists:filter(fun (L) -> lists:sum(L) == ?SUM end, get_combinations(input()))).

part2() ->
    C = lists:filter(fun (L) -> lists:sum(L) == ?SUM end, get_combinations(input())),
    Min = lists:min(lists:map(fun (L) -> length(L) end, C)),
    length(lists:filter(fun (L) -> length(L) == Min end, C)).

input() ->
    {ok, Input} = file:read_file(input),
    lists:foldl(fun (N, Acc) -> {Nr, _} = string:to_integer(N), [Nr | Acc] end, [], string:split(Input, "\n", all)).

get_combinations(Nrs) ->
    lists:flatmap(fun (N) -> combination(N, Nrs, []) end, lists:seq(0, length(Nrs))).

combination(0, _, Acc) -> [Acc];
combination(_, [], _) -> [];
combination(N, [H | []], Acc) -> combination(N - 1, [], [H | Acc]);
combination(N, [H | T], Acc) -> combination(N - 1, T, [H | Acc]) ++ combination(N, T, Acc).