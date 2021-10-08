-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    {ok, Input} = file:read_file(input),
    Lines = lists:map(fun (L) -> binary:bin_to_list(L) end, string:split(Input, "\n", all)),
    L = lists:filter(fun (L) -> not_allowed(L) and vowels(L) and double_char(L) end, Lines),
    erlang:length(L).

part2() ->
    {ok, Input} = file:read_file(input),
    Lines = lists:map(fun (L) -> binary:bin_to_list(L) end, string:split(Input, "\n", all)),
    L = lists:filter(fun (L) -> double_pair(L) and sandwhich(L) end, Lines),
    erlang:length(L).

double_pair([_ | []]) -> false;
double_pair([H1 | [H2 | T]]) ->
    case string:str(T, binary:bin_to_list(<<H1, H2>>)) of
        0 -> double_pair([H2 | T]);
        _ -> true
    end.

sandwhich([_ | [_ | []]]) -> false;
sandwhich([H1 | [_ | [H1 | _]]]) -> true;
sandwhich([_ | [H2 | T]]) -> sandwhich([H2 | T]).

vowels(S) ->
    O = lists:map(fun (V) ->
        erlang:length(lists:filter(fun (SC) -> SC == V end, S))
    end, [$a, $e, $i, $o, $u]),
    lists:sum(O) >= 3.

not_allowed(S) ->
    lists:all(fun (X) -> string:str(S, X) == 0 end, ["ab", "cd", "pq", "xy"]).

double_char([_ | []]) -> false;
double_char([H | [H | _]]) -> true;
double_char([_ | T]) -> double_char(T).