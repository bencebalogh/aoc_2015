-module(aoc).
-export([part1/0, part2/0]).
-define(BOSS, {71, 10, 0, []}).

part1() ->
    lists:min(lists:filtermap(fun
        ({player, Mana}) -> {true, Mana};
        (_) -> false
    end, lists:flatten(player_turn({50, 500, 0, []}, ?BOSS, 0, false)))).

part2() ->
    lists:min(lists:filtermap(fun
        ({player, Mana}) -> {true, Mana};
        (_) -> false
    end, lists:flatten(player_turn({50, 500, 0, []}, ?BOSS, 0, true)))).

player_turn(Player, Boss, ManaSum, HardMode) ->
    Pm = case {HardMode, Player} of
        {true, {Php, Pmana, Parmor, Pe}} -> {Php - 1, Pmana, Parmor, Pe};
        _ -> Player 
    end,
    {PlayerHp, Mana, Armor, PlayerEffects} = run_effects(Pm),
    {BossHp, BossDamage, 0, BossEffects} = run_effects(Boss),
    Options = get_options({Mana, PlayerEffects}, BossEffects),
    case {BossHp, Options} of
        {Hp, _} when Hp =< 0 -> {player, ManaSum};
        {_, []} -> {boss, ManaSum};
        _ -> lists:map(fun
                (recharge) ->
                    P = {PlayerHp, Mana - 229, Armor, [{recharge, 5} | PlayerEffects]},
                    M = ManaSum + 229,
                    B = {BossHp, BossDamage, 0, BossEffects},
                    boss_turn(P, B, M, HardMode);
                (poison) -> 
                    P = {PlayerHp, Mana - 173, Armor, PlayerEffects},
                    M = ManaSum + 173,
                    B = {BossHp, BossDamage, 0, [{poison, 6}]},
                    boss_turn(P, B, M, HardMode);
                (shield) -> 
                    P = {PlayerHp, Mana - 113, Armor, [{shield, 6} | PlayerEffects]},
                    M = ManaSum + 113,
                    B = {BossHp, BossDamage, 0, BossEffects},
                    boss_turn(P, B, M, HardMode);
                (drain) -> 
                    P = {PlayerHp + 2, Mana - 73, Armor, PlayerEffects},
                    M = ManaSum + 73,
                    B = {BossHp - 2, BossDamage, 0, BossEffects},
                    if
                        BossHp =< 2 -> {player, M};
                        true -> boss_turn(P, B, M, HardMode)
                    end;
                (missle) -> 
                    P = {PlayerHp, Mana - 53, Armor, PlayerEffects},
                    M = ManaSum + 53,
                    B = {BossHp - 4, BossDamage, 0, BossEffects},
                    if
                        BossHp =< 4 -> {player, M};
                        true -> boss_turn(P, B, M, HardMode)
                    end
            end, Options)
    end.


boss_turn(Player, Boss, ManaSum, HardMode) ->
    {PlayerHp, Mana, Armor, PlayerEffects} = run_effects(Player),
    {BossHp, BossDamage, 0, BossEffects} = run_effects(Boss),
    case {BossHp, PlayerHp + Armor - BossDamage} of
        {I, _} when I =< 0 -> {player, ManaSum};
        {_, I} when I =< 0 -> {boss, ManaSum};
        {_, I} -> player_turn({I, Mana, Armor, PlayerEffects}, {BossHp, BossDamage, 0, BossEffects}, ManaSum, HardMode)
    end.

run_effects({Hp, Mana, 0, []}) -> {Hp, Mana, 0, []};
run_effects({Hp, Mana, _, Effects}) ->
    lists:foldl(fun
        ({poison, 1}, {H, M, A, E}) -> {H - 3, M, A, E};
        ({poison, C}, {H, M, A, E}) -> {H - 3, M, A, [{poison, C - 1} | E]};
        ({shield, 1}, {H, M, _, E}) -> {H, M, 7, E};
        ({shield, C}, {H, M, _, E}) -> {H, M, 7, [{shield, C - 1} | E]};
        ({recharge, 1}, {H, M, A, E}) -> {H, M + 101, A, E};
        ({recharge, C}, {H, M, A, E}) -> {H, M + 101, A, [{recharge, C - 1} | E]}
    end, {Hp, Mana, 0, []}, Effects).

get_options({Mana, Effects}, []) when Mana >= 229 ->
    [missle, drain, shield, poison, recharge] -- lists:map(fun ({E, _}) -> E end, Effects);
get_options({Mana, Effects}, _) when Mana >= 229 ->
    [missle, drain, shield, recharge] -- lists:map(fun ({E, _}) -> E end, Effects);
get_options({Mana, Effects}, []) when Mana >= 173 ->
    [missle, drain, shield, poison] -- lists:map(fun ({E, _}) -> E end, Effects);
get_options({Mana, Effects}, _) when Mana >= 113 ->
    [missle, drain, shield] -- lists:map(fun ({E, _}) -> E end, Effects);
get_options({Mana, _}, _) when Mana >= 73 ->
    [missle, drain];
get_options({Mana, _}, _) when Mana >= 53 ->
    [missle];
get_options(_, _) ->
    [].