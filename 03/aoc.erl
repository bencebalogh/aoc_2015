-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    {ok, Input} = file:read_file(input),
    {_, Path} = lists:foldl(fun
        (Direction, {Coord, Path}) ->
            Moved = new_coord(Direction, Coord),
            {Moved, [Moved | Path]}
    end, {{0, 0}, [{0, 0}]}, binary:bin_to_list(Input)),
    sets:size(sets:from_list(Path)).

part2() ->
    {ok, Input} = file:read_file(input),
    {_, _, _, Path} = lists:foldl(fun
        (Direction, {Santa, Robo, Index, Path}) when Index rem 2 == 1 ->
            Moved = new_coord(Direction, Santa),
            {Moved, Robo, Index + 1, [Moved | Path]};
        (Direction, {Santa, Robo, Index, Path}) ->
            Moved = new_coord(Direction, Robo),
            {Santa, Moved, Index + 1, [Moved | Path]}
    end, {{0, 0}, {0, 0}, 1, [{0, 0}]}, binary:bin_to_list(Input)),
    sets:size(sets:from_list(Path)).

new_coord($^, {X, Y}) -> {X, Y + 1};
new_coord($>, {X, Y}) -> {X + 1, Y};
new_coord($v, {X, Y}) -> {X, Y - 1};
new_coord($<, {X, Y}) -> {X - 1, Y}.