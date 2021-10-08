-module(aoc).
-export([part1/0,part2/0]).

part1() ->
    {ok, Input} = file:read_file("input"),
    lists:sum(lists:map(fun (L) ->
        string:length(L) - no_escaped_length(binary:bin_to_list(L), 0)
    end, string:split(Input, "\n", all))).

part2() ->
    {ok, Input} = file:read_file("input"),
    lists:sum(lists:map(fun (L) ->
        escaped_length(binary:bin_to_list(L), 0) - string:length(L)
    end, string:split(Input, "\n", all))).

no_escaped_length([], L) -> L - 2;
no_escaped_length([$\\, $" | T], L) -> no_escaped_length(T, L + 1);
no_escaped_length([$\\, $\\ | T], L) -> no_escaped_length(T, L + 1);
no_escaped_length([$\\, $x, _, _ | T], L) -> no_escaped_length(T, L + 1);
no_escaped_length([_ | T], L) -> no_escaped_length(T, L + 1).

escaped_length([], L) -> L + 2;
escaped_length([$" | T], L) -> escaped_length(T, L + 2);
escaped_length([$\\ | T], L) -> escaped_length(T, L + 2);
escaped_length([_ | T], L) -> escaped_length(T, L + 1).