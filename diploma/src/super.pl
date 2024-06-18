% Определение переходов и базовых вероятностей
transition("p0", "p1", 1, 2).
transition("p1", "p2", 1, 2).
transition("p2", "p3", 1, 2).
transition("p0", "p0", 1, 2).

% Динамическое изменение LFT в зависимости от шага
adaptive_LFT(BaseLFT, Step, NewLFT) :-
    NewLFT is max(1, BaseLFT - Step // 2).  % Уменьшаем LFT по мере приближения к 20-му шагу

% Расчет вероятностей на каждом шаге с учетом динамического изменения LFT
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

% Нормализация вероятностей
normalize_distribution(Dist, Normalized) :-
    sum_list(Dist, Total, 0),
    maplist(normalize_prob(Total), Dist, Normalized).

normalize_prob(Total, S-P, S-NormP) :- NormP is P / Total.

sum_list([], Total, Total).
sum_list([_-P|T], Total, Acc) :- NewAcc is Acc + P, sum_list(T, Total, NewAcc).

% Выполнение 20 шагов моделирования
perform_steps(_, 0, []).
perform_steps(Dist, Step, [Dist|Rest]) :-
    Step > 0,
    NextStep is Step - 1,
    update_distribution(Step, Dist, NewDist),
    perform_steps(NewDist, NextStep, Rest).

% Запуск моделирования и вывод результатов
run :-
    initial_distribution(Initial),
    perform_steps(Initial, 20, Results),
    maplist(writeln, Results).

% Начальное распределение вероятностей
initial_distribution(["p0"-1.0, "p1"-0.0, "p2"-0.0, 
                      "p3"-0.0]).

?- run.

