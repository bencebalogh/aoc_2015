-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    {ok, Input} = file:read_file(input),
    count(Input).

part2() ->
    {ok, Input} = file:read_file(input),
    {ok, RE1} = re:compile("\\{[^\\{}]*:\"red\"[^\\{}]*\\}"),
    {ok, RE2} = re:compile("\\{([^\\{}]*)\\}"),
    R = replace_reds(Input, RE1, RE2),
    count(R).

count(Str) ->
    {ok, RE} = re:compile("-?[0-9]\\d*(\\.\\d+)?"),
    {match, Nrs} = re:run(Str, RE, [global, {capture, all, list}]),
    lists:foldl(fun ([X], Acc) -> {I, _} = string:to_integer(X), Acc + I end, 0, Nrs).

replace_reds(Str, RE1, RE2) ->
    case re:run(Str, RE1) of
        {match, _} ->
            S = re:replace(Str, RE1, "\"r\"", [global]),
            replace_reds(S, RE1, RE2);
        _ -> re:replace(Str, RE2, "[\1]")
    end.