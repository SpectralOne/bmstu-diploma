transition("начало", "утверждение - НР", 1, 2).
transition("утверждение - НР", "начало", 1, 2).
transition("утверждение - НР", "утверждение - К", 1, 4).
transition("утверждение - К", "начало", 1, 2).
transition("утверждение - К", "проверка секретарём", 1, 2).
transition("проверка секретарём", "начало", 1, 5).
transition("проверка секретарём", "утверждение - ЗК", 1, 2).
transition("утверждение - ЗК", "начало", 1, 8).
transition("утверждение - ЗК", "рассмотрение в отделе", 1, 2).
transition("рассмотрение в отделе", "начало", 1, 2).
transition("рассмотрение в отделе", "утверждён", 1, 2).

adaptive_LFT(BaseLFT, Step, NewLFT) :-
    NewLFT is max(1, BaseLFT - Step // 2).

update_distribution(Step, Dist, NewDist) :-
    findall(S-NewProb, (
        member(S-_, Dist),
        findall(P, (
            member(S1-P1, Dist),
            transition(S1, S, EFT, BaseLFT),
            adaptive_LFT(BaseLFT, Step, NewLFT),
            P is (EFT / NewLFT) * P1
        ), Probs),
        sum_list(Probs, TotalProb),
        NewProb is TotalProb
    ), TempDist),
    normalize_distribution(TempDist, NewDist).

normalize_distribution(Dist, Normalized) :-
    sum_list(Dist, Total, 0),
    maplist(normalize_prob(Total), Dist, Normalized).

normalize_prob(Total, S-P, S-NormP) :- NormP is P / Total.

sum_list([], Total, Total).
sum_list([_-P|T], Total, Acc) :- NewAcc is Acc + P, sum_list(T, Total, NewAcc).

perform_steps(_, 0, []).
perform_steps(Dist, Step, [Dist|Rest]) :-
    Step > 0,
    NextStep is Step - 1,
    update_distribution(Step, Dist, NewDist),
    perform_steps(NewDist, NextStep, Rest).

run :-
    initial_distribution(Initial),
    perform_steps(Initial, 20, Results),
    maplist(writeln, Results).

initial_distribution(["начало"-1.0, "утверждение - НР"-0.0, "утверждение - К"-0.0, 
                      "проверка секретарём"-0.0, "утверждение - ЗК"-0.0, "рассмотрение в отделе"-0.0, 
                      "утверждён"-0.0]).

?- run.
