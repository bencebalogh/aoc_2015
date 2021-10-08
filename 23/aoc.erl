-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    {_, B} = process(input(), 1, {0, 0}),
    B.

part2() ->
    {_, B} = process(input(), 1, {1, 0}),
    B.

process(D, I, {A, B}) ->
    case dict:is_key(I, D) of
        false -> {A, B};
        true ->
            case dict:fetch(I, D) of
                {hlf, a} -> process(D, I + 1, {A div 2, B});
                {hlf, b} -> process(D, I + 1, {A, B div 2});
                {tpl, a} -> process(D, I + 1, {A * 3, B});
                {tpl, b} -> process(D, I + 1, {A, B * 3});
                {inc, a} -> process(D, I + 1, {A + 1, B});
                {inc, b} -> process(D, I + 1, {A, B + 1});
                {jmp, N} -> process(D, I + N, {A, B});
                {jie, a, N} when A rem 2 == 0 -> process(D, I + N, {A, B});
                {jie, b, N} when B rem 2 == 0 -> process(D, I + N, {A, B});
                {jie, _, _} -> process(D, I + 1, {A, B});
                {jio, a, N} when A == 1 -> process(D, I + N, {A, B});
                {jio, b, N} when B == 1 -> process(D, I + N, {A, B});
                {jio, _, _} -> process(D, I + 1, {A, B})
            end
    end.

input() ->
    {ok, Input} = file:read_file(input),
    {D, _} = lists:foldl(fun
        (<<"hlf ", R/binary>>, {D, I}) -> {dict:store(I, {hlf, binary_to_atom(R)}, D), I + 1};
        (<<"tpl ", R/binary>>, {D, I}) -> {dict:store(I, {tpl, binary_to_atom(R)}, D), I + 1};
        (<<"inc ", R/binary>>, {D, I}) -> {dict:store(I, {inc, binary_to_atom(R)}, D), I + 1};
        (<<"jmp ", R/binary>>, {D, I}) -> {dict:store(I, {jmp, binary_to_integer(R)}, D), I + 1};
        (<<"jie ", B/binary>>, {D, I}) ->
            [R, O] = string:lexemes(binary:bin_to_list(B), ", "),
            {Offset, _} = string:to_integer(O),
            {dict:store(I, {jie, list_to_atom(R), Offset}, D), I + 1};
        (<<"jio ", B/binary>>, {D, I}) ->
            [R, O] = string:lexemes(binary:bin_to_list(B), ", "),
            {Offset, _} = string:to_integer(O),
            {dict:store(I, {jio, list_to_atom(R), Offset}, D), I + 1}
    end, {dict:new(), 1}, string:split(Input, "\n", all)),
    D.