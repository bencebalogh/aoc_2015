-module(aoc).
-export([part1/0,part2/0]).
-define(KNOWN, #{
    <<"children">> => 3,
    <<"cats">> => 7,
    <<"samoyeds">> => 2,
    <<"pomeranians">> => 3,
    <<"akitas">> => 0,
    <<"vizslas">> => 0,
    <<"goldfish">> => 5,
    <<"trees">> => 3,
    <<"cars">> => 2,
    <<"perfumes">> => 1
}).

part1() ->
    Input = input(),
    hd(lists:filter(fun (I) ->
        Sue = maps:get(erlang:integer_to_binary(I), Input),
        lists:all(fun (V) ->
            maps:get(V, Sue, maps:get(V, ?KNOWN)) == maps:get(V, ?KNOWN)
        end, maps:keys(?KNOWN))
    end, lists:seq(1,500))).

part2() ->
    Input = input(),
    hd(lists:filter(fun (I) ->
        Sue = maps:get(erlang:integer_to_binary(I), Input),
        lists:all(fun
            (V) when (V == <<"cats">>) or (V == <<"trees">>) ->
                maps:get(V, Sue, maps:get(V, ?KNOWN) + 1) > maps:get(V, ?KNOWN);
            (V) when (V == <<"pomeranians">>) or (V == <<"goldfish">>) ->
                maps:get(V, Sue, maps:get(V, ?KNOWN) - 1) < maps:get(V, ?KNOWN);
            (V) ->
                maps:get(V, Sue, maps:get(V, ?KNOWN)) == maps:get(V, ?KNOWN)
        end, maps:keys(?KNOWN))
    end, lists:seq(1,500))).

input() ->
    {ok, Input} = file:read_file(input),
    lists:foldl(fun (L, Acc) ->
        [<<"Sue">> , Nr | Attrs] = string:lexemes(L, " :,"),
        maps:put(Nr, set_attrs(Attrs, #{}), Acc)
    end, #{}, string:split(Input, "\n", all)).

set_attrs([], M) -> M;
set_attrs([K | [V | T]], M) ->
    {Vi, _} = string:to_integer(V),
    set_attrs(T, maps:put(K, Vi, M)).