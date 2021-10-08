-module(aoc).
-export([part1/0,part2/0]).

part1() ->
    solve(40).

part2() ->
    solve(50).

solve(Iterations) ->
    {ok, RE} = re:compile("((\\w)\\2*)"),
    S = lists:foldl(fun (_, W) ->
        {match, L} = re:run(W, RE, [global, {capture, all, list}]),
        string:join(lists:reverse(lists:foldl(fun (M, N) ->
            [hd(lists:reverse(M)) | [erlang:integer_to_list(erlang:length(hd(M))) | N]]
        end, "", L)), "")
    end, "1113122113", lists:seq(0, Iterations)),
    string:length(S).