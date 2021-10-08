-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    Nrs = input(),
    Weight = lists:sum(Nrs) div 3,
    get_qe(Nrs, 0, Weight).

part2() ->
    Nrs = input(),
    Weight = lists:sum(Nrs) div 4,
    get_qe(Nrs, 0, Weight).

input() ->
    {ok, Input} = file:read_file(input),
    lists:map(fun (L) -> erlang:binary_to_integer(L) end, string:split(Input, "\n", all)).

get_qe(Nrs, Length, Weight) ->
    case lists:filter(fun (X) -> lists:sum(X) == Weight end, get_combinations(Nrs, Length)) of
        [] -> get_qe(Nrs, Length + 1, Weight);
        Found ->
            hd(lists:sort(lists:map(fun (Ll) ->
                lists:foldl(fun (X, A) -> X * A end, 1, Ll)
            end, Found)))
    end.

get_combinations(Nrs, Length) ->
    lists:flatmap(fun (N) -> combination(N, Nrs, []) end, lists:seq(0, Length)).

combination(0, _, Acc) -> [Acc];
combination(_, [], _) -> [];
combination(N, [H | []], Acc) -> combination(N - 1, [], [H | Acc]);
combination(N, [H | T], Acc) -> combination(N - 1, T, [H | Acc]) ++ combination(N, T, Acc).