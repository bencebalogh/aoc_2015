-module(aoc).
-export([part1/0, part2/0]).
-define(BOSS, {104, 8, 1}).
-define(WEAPONS, [
    {8, 4, 0},
    {10, 5, 0},
    {25, 6, 0},
    {40, 7, 0},
    {74, 8, 0}
]).
-define(ARMORS, [
    {13, 0, 1},
    {31, 0, 2},
    {53, 0, 3},
    {75, 0, 4},
    {102, 0, 5},
    {0, 0, 0}
]).
-define(RINGS, [
    {25, 1, 0},
    {50, 2, 0},
    {100, 3, 0},
    {20, 0, 1},
    {40, 0, 2},
    {80, 0, 3},
    {0, 0, 0},
    {0, 0, 0}
]).

part1() ->
    {G, player} = hd(lists:keysort(1, lists:filter(fun ({_, O}) -> O == player end, get_outcomes()))),
    G.

part2() ->
    {G, boss} = hd(lists:reverse(lists:keysort(1, lists:filter(fun ({_, O}) -> O == boss end, get_outcomes())))),
    G.

get_outcomes() ->
    Rings = combination(2, ?RINGS, []),
    Options = lists:flatmap(fun (W) ->
        lists:flatmap(fun (A) ->
            lists:map(fun (Rs) ->
                {W, A, Rs}
            end, Rings)
        end, ?ARMORS)
    end, ?WEAPONS),
    lists:map(fun ({{G1, D, 0}, {G2, 0, A}, [{G3, D1, A1}, {G4, D2, A2}]}) ->
        {G1 + G2 + G3 + G4, fight({100, D + D1 + D2, A + A1 + A2}, ?BOSS)}
    end, Options).


fight({Php, Pd, Pa}, {Bhp, Bd, Ba}) ->
    case {Bhp - damage(Pd, Ba), Php - damage(Bd, Pa)} of
        {B, _} when B =< 0 -> player;
        {_, P} when P =< 0 -> boss;
        {B, P} -> fight({P, Pd, Pa}, {B, Bd, Ba})
    end.

damage(D, A) when D =< A -> 1;
damage(D, A) -> D - A.

combination(0, _, Acc) -> [Acc];
combination(_, [], _) -> [];
combination(N, [H | []], Acc) -> combination(N - 1, [], [H | Acc]);
combination(N, [H | T], Acc) -> combination(N - 1, T, [H | Acc]) ++ combination(N, T, Acc).