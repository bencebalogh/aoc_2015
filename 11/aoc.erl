-module(aoc).
-export([part1/0,part2/0]).
-define(INPUT, "vzbxkghb").

part1() ->
    next_password(?INPUT).

part2() ->
    next_password(next_password(?INPUT)).

next_password(Password) ->
    P = new_password(Password, 0),
    case double_pair(P, 0) and increasing_three(P) of
        true -> P;
        false -> next_password(P)
    end.

new_password(Password, I) ->
    {Keep, [H | T]} = lists:split(I, lists:reverse(Password)),
    Incremented = increment(H),
    P = lists:reverse(Keep ++ [Incremented] ++ T),
    case Incremented of
        $a -> new_password(P, I + 1);
        _ -> P
    end.

increment($z) -> $a;
increment($h) -> $j;
increment($n) -> $p;
increment($k) -> $m;
increment(A) -> A + 1.

double_pair([], _) -> false;
double_pair([H | [H | _]], 1) -> true;
double_pair([H | [H | T]], 0) -> double_pair(T, 1);
double_pair([_ | T], C) -> double_pair(T, C).

increasing_three([_ | [_ | []]]) -> false;
increasing_three([Ha | [Hb | [Hc | _]]]) when (Hb == Ha + 1) and (Hc == Hb + 1) -> true;
increasing_three([_ | T]) -> increasing_three(T).