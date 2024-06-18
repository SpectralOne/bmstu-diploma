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

initial_distribution(["начало"-1.0, "утверждение - НР"-0.0, "утверждение - К"-0.0, 
               "проверка секретарём"-0.0, "утверждение - ЗК"-0.0, "рассмотрение в отделе"-0.0, 
               "утверждён"-0.0]).

update_distribution(Dist, NewDist) :-
    findall(S-NewProb, (
        member(S-_, Dist),
        findall(P, (
            member(S1-P1, Dist),
            transition(S1, S, EFT, LFT),
            P is (EFT / LFT) * P1
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

perform_steps(Dist, 0, [Dist]).
perform_steps(Dist, N, [Dist|Rest]) :-
    N > 0,
    update_distribution(Dist, NewDist),
    M is N - 1,
    perform_steps(NewDist, M, Rest).

print_numeric_results([]).
print_numeric_results([H|T]) :-
    findall(Prob, member(_-Prob, H), Probs),
    writeln(Probs),
    print_numeric_results(T).

run :-
    initial_distribution(Initial),
    perform_steps(Initial, 20, Results),
    print_numeric_results(Results).

?- run.

