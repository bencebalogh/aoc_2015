-module(aoc).
-export([part1/0]).
-define(FIRST, 20151125).
-define(ROW, 3029).
-define(COLUMN, 2947).

part1() ->
    next(1, 1, ?FIRST).

next(?ROW, ?COLUMN, I) -> I;
next(X, 1, I) ->
    next(1, X + 1, (I * 252533) rem 33554393);
next(X, Y, I) ->
    next(X + 1, Y - 1, (I * 252533) rem 33554393).
