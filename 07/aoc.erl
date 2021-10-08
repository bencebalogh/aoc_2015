-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    input(),
    get_circuit(<<"a">>).

part2() ->
    input(),
    B = get_circuit(<<"a">>),
    input(),
    put(<<"b">>, B),
    get_circuit(<<"a">>).

input() ->
    {ok, Input} = file:read_file("input"),
    lists:foreach(fun(Expr) ->
        put(hd(lists:reverse(Expr)), lists:droplast(Expr))
    end, [ string:lexemes(Str, "-> ") || Str <- string:split(Input, "\n", all) ]).

get_circuit(Circuit) ->
    V = case string:to_integer(Circuit) of
        {error, _} ->
                case get(Circuit) of
                    Val when is_integer(Val) -> Val;
                    C when is_list(C) -> calculate(C)
                end;
        {Val, _} -> Val
    end,
    put(Circuit, V),
    V.

calculate([A]) -> get_circuit(A);
calculate([<<"NOT">>, A]) -> bnot get_circuit(A);
calculate([A, <<"AND">>, B]) -> get_circuit(A) band get_circuit(B);
calculate([A, <<"OR">>,  B]) -> get_circuit(A) bor  get_circuit(B);
calculate([A, <<"LSHIFT">>, B]) -> get_circuit(A) bsl get_circuit(B);
calculate([A, <<"RSHIFT">>, B]) -> get_circuit(A) bsr get_circuit(B).