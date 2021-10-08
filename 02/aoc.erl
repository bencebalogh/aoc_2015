-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    Papers = lists:map(fun ([L, W, H]) ->
        Smallest = lists:min([L*W, W*H, H*L]),
        2*L*W + 2*W*H + 2*H*L + Smallest
    end, parse_input()),
    lists:sum(Papers).

part2() ->
    Ribbons = lists:map(fun ([L, W, H]) ->
        Smallest = lists:min([2*L + 2*W, 2*W + 2*H, 2*H + 2*L]),
        Smallest + L * W * H
    end, parse_input()),
    lists:sum(Ribbons).

parse_input() ->
    {ok, Input} = file:read_file(input),
    Raw = string:split(Input, "\n", all),
    lists:map(fun (R) -> 
        lists:map(fun (N) ->
            {I, _} = string:to_integer(N),
            I
        end, string:split(R, "x", all) )
    end, Raw).