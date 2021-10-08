-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    Input = input(),
    lists:max(lists:map(fun (Variant) ->
        V1 = calculate(1, Input, Variant),
        V2 = calculate(2, Input, Variant),
        V3 = calculate(3, Input, Variant),
        V4 = calculate(4, Input, Variant),
        V1 * V2 * V3 * V4
    end, combinations())).

part2() ->
    Input = input(),
    lists:max(lists:map(fun (Variant) ->
        V1 = calculate(1, Input, Variant),
        V2 = calculate(2, Input, Variant),
        V3 = calculate(3, Input, Variant),
        V4 = calculate(4, Input, Variant),
        case calculate(5, Input, Variant) of
            500 -> V1 * V2 * V3 * V4;
            _ -> 0
        end
    end, combinations())).

input() ->
    {ok, RE} = re:compile("\\w+:\\scapacity\\s(-?\\d+),\\sdurability\\s(-?\\d+),\\sflavor\\s(-?\\d+),\\stexture\\s(-?\\d+),\\scalories\\s(-?\\d+)"),
    {ok, Input} = file:read_file(input),
    lists:map(fun (L) ->
        {match, [[_, C, D, F, T, Cl]]} = re:run(L, RE, [global, {capture, all, list}]),
        {Ci, _} = string:to_integer(C),
        {Di, _} = string:to_integer(D),
        {Fi, _} = string:to_integer(F),
        {Ti, _} = string:to_integer(T),
        {Cli, _} = string:to_integer(Cl),
        [Ci, Di, Fi, Ti, Cli]
    end, string:split(Input, "\n", all)).

calculate(Index, List, [A, B, C, D]) ->
    [E, F, G, H] = lists:map(fun (L) -> lists:nth(Index, L) end, List),
    case A * E + B * F + C * G + D * H of
        I when I >= 0 -> I;
        _ -> 0
    end.

combinations() ->
    {_, _, R} = lists:foldl(fun
        (N, {3, Acc, All}) ->
            {0, [], [[N | Acc] | All]};
        (N, {I, Acc, All}) ->
            {I + 1, [N | Acc], All}
    end, {0, [], []}, lists:flatten(
    lists:map(fun (A) ->
        lists:map(fun (B) ->
            lists:map(fun (C) ->
                lists:map(fun (D) ->
                    case A + B + C + D of
                        I when I == 100 -> [A, B, C, D];
                        _ -> []
                    end
                end, lists:seq(0, 100 - A - B - C))
            end, lists:seq(0, 100 - A - B))
        end, lists:seq(0, 100 - A))
    end, lists:seq(0, 100)))),
    R.