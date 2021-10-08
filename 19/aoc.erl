-module(aoc).
-export([part1/0,part2/0]).
-define(MEDICINE, "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF").

part1() ->
    sets:size(sets:from_list(lists:foldl(fun ({From, To}, M) ->
        M ++ all_combinations({From, To}, ?MEDICINE)
    end, [], input()))).

part2() ->
    "solved by hand, following reddit explanation".

all_combinations({From, To}, Str) ->
    Indexes = find_indexes(Str, From, 0, []),
    lists:map(fun (I) ->
        Pre = case I of
            1 -> "";
            _ -> string:substr(Str, 1, I - 1)
        end,
        Post = string:substr(Str, I + length(From), length(Str)),
        Pre ++ To ++ Post
    end, Indexes).


find_indexes(Str, Sub, P, Indexes) ->
    case string:str(Str, Sub) of
        0 -> Indexes;
        I ->
            M = I + length(Sub),
            find_indexes(string:substr(Str, M, length(Str)), Sub, P + M - 1, [P + I | Indexes])
    end.

input() ->
    {ok, Input} = file:read_file(input),
    {ok, RE} = re:compile("(\\w+)\s=>\s(\\w+)"),
    lists:map(fun (L) ->
        {match, [[_, From, To]]} = re:run(L, RE, [global, {capture, all, list}]),
        {From, To}
    end, string:split(Input, "\n", all)).