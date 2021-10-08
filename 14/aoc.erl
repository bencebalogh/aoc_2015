-module(aoc).
-export([part1/0,part2/0]).
-define(TIME, 2503).

part1() ->
    lists:max(lists:map(fun ({{{D, T}, R}, _, _ }) ->
        L = ?TIME rem (T + R),
        C = math:floor(?TIME / (T + R)),
        P = case L of
            I when I >= T -> D * T;
            I -> I * D
        end,
        C * D * T + P
    end , input())).

part2() ->
    Outcome = lists:foldl(fun (Second, Race) ->
        Moved = lists:map(fun ({{{D, T}, R}, Points, Distance}) ->
            NewDistance = case Second rem (T + R) of
                L when (L =< T) and (L > 0) -> Distance + D;
                _ -> Distance
            end,
            {{{D, T}, R}, Points, NewDistance}
        end, Race),
        Furthest = lists:max(lists:map(fun ({_, _, D}) -> D end, Moved)),
        lists:map(fun
            ({R, P, D}) when D == Furthest -> {R, P + 1, D};
            (R) -> R
        end, Moved)
    end, input(), lists:seq(1, ?TIME)),
    lists:max(lists:map(fun ({_, P, _}) -> P end, Outcome)).

input() ->
    {ok, Input} = file:read_file(input),
    {ok, RE} = re:compile("\\w+\\scan\\sfly\\s(\\d+)\\skm\\/s\\sfor\\s(\\d+)\\sseconds,\\sbut\\sthen\\smust\\srest\\sfor\\s(\\d+)\\sseconds."),
    lists:map(fun (L) ->
        {match, [[_, Ds, Ts, Rs]]} = re:run(L, RE, [global, {capture, all, list}]),
        {D, _} = string:to_integer(Ds),
        {T, _} = string:to_integer(Ts),
        {R, _} = string:to_integer(Rs),
        {{{D, T}, R}, 0, 0}
    end, string:split(Input, "\n", all)).