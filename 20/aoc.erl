-module(aoc).
-export([part1/0, part2/0]).
-define(INPUT, 34000000).

part1() ->
    next_house(1, 10, false).

part2() ->
    next_house(1, 11, true).

next_house(Nr, Deliver, Limit) ->
    E = trunc(math:sqrt(Nr)),
    Ds = lists:flatmap(fun
        (X) when Nr rem X /= 0 -> [];
        (X) when X /= Nr div X -> [X, Nr div X];
        (X) -> [X]
    end, lists:seq(1, E)),
    Ds2 = case Limit of
        false -> lists:sum(Ds);
        true -> lists:sum(lists:filter(fun (D) -> Nr div D =< 50 end, Ds))
    end,
    case Ds2 * Deliver of
        I when I >= ?INPUT -> Nr;
        _ -> next_house(Nr + 1, Deliver, Limit)
    end.