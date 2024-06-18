% Определение переходов с EFT и LFT
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


transition_probability(EFT, LFT, Probability) :-
    Probability is (LFT - EFT) / LFT.

find_path(Start, End, Path, Probability, Steps) :- 
    travel(Start, End, [Start], 1, 0, RevPath, Probability, Steps),
    reverse(RevPath, Path).

travel(Start, End, Visited, CurrentProb, CurrentSteps, [End|Visited], FinalProb, FinalSteps) :- 
    transition(Start, End, EFT, LFT),
    transition_probability(EFT, LFT, StepProb),
    FinalProb is CurrentProb * StepProb,
    FinalSteps is CurrentSteps + 1.

travel(Start, End, Visited, CurrentProb, CurrentSteps, Path, FinalProb, FinalSteps) :-
    transition(Start, Mid, EFT, LFT),
    Mid \= End,
    \+member(Mid, Visited),
    transition_probability(EFT, LFT, StepProb),
    NewProb is CurrentProb * StepProb,
    NewSteps is CurrentSteps + 1,
    travel(Mid, End, [Mid|Visited], NewProb, NewSteps, Path, FinalProb, FinalSteps).

% Пример запроса
% ?- find_path(черновик, опубликован, Path, Probability, Steps).

