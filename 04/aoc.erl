-module(aoc).
-export([part1/0, part2/0]).

part1() ->
    find("bgvyzdsv", 1, true).

part2() ->
    find("bgvyzdsv", 1, false).

find(Input, I, Short) ->
    S = hex_beginning(crypto:hash(md5, Input ++ erlang:integer_to_list(I)), ""),
    if
    Short ->
        Sub = string:sub_string(S, 1, 5),
        if
        Sub == "00000" ->
            I;
        true ->
            find(Input, I + 1, Short)
        end;
    true ->
        if
        S == "000000" ->
            I;
        true ->
            find(Input, I + 1, Short)
        end
    end.

hex_beginning(Binary, Hex) ->
    << H, T/binary >> = Binary,
    Hex2 = Hex ++ to_hex(H),
    Length = string:length(Hex2),
    if
    Length == 6 ->
        Hex2;
    true ->
        hex_beginning(T, Hex2)
    end.

hex(N) when N < 10 ->
    $0+N;
hex(N) when N >= 10, N < 16 ->
    $a+(N-10).

to_hex(N) when N < 256 ->
    [hex(N div 16), hex(N rem 16)].