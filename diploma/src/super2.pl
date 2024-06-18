% Определение переходов и вероятностей
transition("p0", "p1", 1, 4).
transition("p1", "p0", 1, 4).
transition("p1", "p2", 1, 2).
transition("p2", "p0", 1, 10).
transition("p2", "p3", 1, 2).
transition("p3", "p4", 1, 2).
transition("p4", "p5", 1, 2).
transition("p5", "p6", 1, 2).
transition("p6", "p0", 1, 2).

% Инициализация начального распределения
initial_distribution(["p0"-1.0, "p1"-0.0, "p2"-0.0, 
"p3"-0.0, "p4"-0.0, "p5"-0.0,"p6"-0.0]).

% Обновление распределения вероятностей на каждом шаге
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

% Нормализация вероятностей
normalize_distribution(Dist, Normalized) :-
    sum_list(Dist, Total, 0),
    maplist(normalize_prob(Total), Dist, Normalized).

normalize_prob(Total, S-P, S-NormP) :- NormP is P / Total.

sum_list([], Total, Total).
sum_list([_-P|T], Total, Acc) :- NewAcc is Acc + P, sum_list(T, Total, NewAcc).

% Выполнение 20 шагов моделирования
perform_steps(Dist, 0, [Dist]).
perform_steps(Dist, N, [Dist|Rest]) :-
    N > 0,
    update_distribution(Dist, NewDist),
    M is N - 1,
    perform_steps(NewDist, M, Rest).

% Вывод только числовых значений вероятностей
print_numeric_results([]).
print_numeric_results([H|T]) :-
    findall(Prob, member(_-Prob, H), Probs),
    writeln(Probs),
    print_numeric_results(T).

% Запуск моделирования
run :-
    initial_distribution(Initial),
    perform_steps(Initial, 20, Results),
    print_numeric_results(Results).

?- run.

