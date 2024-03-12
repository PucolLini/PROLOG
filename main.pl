% Przypadek bazowy: posortowana wersja pustej listy to pusta lista
sortowanie_przez_wybieranie([], []).

% Przypadek rekurencyjny: aby posortować listę, znajdź największy element, usuń go z listy i dołącz do posortowanej wersji reszty listy
sortowanie_przez_wybieranie(Lista, [Max|Posortowana]) :-
    wybierz_max(Lista, Max, Reszta),
    sortowanie_przez_wybieranie(Reszta, Posortowana).

% Szukanie maksymalnego elementu do wstawienia 
% Gdy nie ma jak iść głębiej, ten element jest największy 
wybierz_max([Max], Max, []).

% Szukamy rekurencyjnie 
wybierz_max([Glowa|Ogon], Max, [Glowa|Reszta]) :-
    wybierz_max(Ogon, MaxOgon, Reszta),
    MaxOgon >= Glowa,
    Max = MaxOgon.

wybierz_max([Glowa|Ogon], Glowa, Ogon) :-
    wybierz_max(Ogon, MaxOgon, _),
    MaxOgon < Glowa.

% Przypadek bazowy: długość pustej listy wynosi 0
dlugosc([], 0).
% Przypadek rekurencyjny: długość listy wynosi 1 plus długość ogona listy
dlugosc([_|Ogon], Dlugosc) :-
    dlugosc(Ogon, DlugoscOgon),
    Dlugosc is DlugoscOgon + 1.

% Przypadek bazowy: inkrementacja pustej listy to pusta lista
inkrementacja([], []).

% Przypadek rekurencyjny: inkrementacja listy to inkrementacja głowy, a następnie inkrementacja ogona
inkrementacja([Glowa|Ogon], [NowaGlowa|NowyOgon]) :-
    NowaGlowa is Glowa + 1,
    inkrementacja(Ogon, NowyOgon).

% Przypadek bazowy: pusta lista jest ciągiem graficznym
jest_ciagiem_graficznym([], true).

% Przypadek rekurencyjny: lista jest ciągiem graficznym, jeśli można ją zredukować do ciągu graficznym
jest_ciagiem_graficznym([Glowa|Ogon], Odp) :-
    % Jeśli Glową jest równa 1, sprawdź parzystość sumy elementów listy
    (   Glowa =:= 1
    ->  sum_list([Glowa|Ogon], Suma),
        (   Suma mod 2 =:= 0
        ->  Odp = true
        ;   Odp = false
        )
    ;   % Jeśli Glową jest większa niż długość ogona, ciąg nie jest graficzny
        length(Ogon, Dlugosc),
        (   Glowa =< Dlugosc
        ->  % Usuń pierwsze Glową elementy z ogona
            length(Front, Glowa),
            nowy_append(Front, Tyl, Ogon),
            % Zdekrementuj pierwsze Glową elementy
            maplist(dekrement, Front, ZdekrementowaneFront),
            % Dołącz zdekrementowane elementy do końca ciągu
            nowy_append(ZdekrementowaneFront, Tyl, NowyCiag),
            % Posortuj nowy ciąg w porządku nierosnącym
            sortowanie_przez_wybieranie(NowyCiag, PosortowanyNowyCiag),
            % Sprawdź, czy posortowany nowy ciąg jest ciągiem graficznym
            jest_ciagiem_graficznym(PosortowanyNowyCiag, Odp)
        ;   Odp = false
        )
    ).

% Pomocniczy predykat do dekrementacji liczby
dekrement(X, Y) :-
    Y is max(0, X - 1).

% Implementacja alternatywnego predykatu do append
nowy_append([], L, L).
nowy_append([X|Rest1], L2, [X|Result]) :-
    nowy_append(Rest1, L2, Result).

% Base case: an empty list does not contain a zero
czyNiePosiadaZera([], true).

% Recursive case: a list contains a zero if the head is zero or if the tail contains a zero
czyNiePosiadaZera([0|_], false) :- !.
czyNiePosiadaZera([_|Tail], Result) :-
    czyNiePosiadaZera(Tail, Result).

czy_spojny(StopienWierzcholkowy, Odp2) :-
    write('StopienWierzcholkowy: '), write(StopienWierzcholkowy), nl,
    jest_ciagiem_graficznym(StopienWierzcholkowy, JestGraficzny),
    write('JestGraficzny: '), write(JestGraficzny), nl,
    czyNiePosiadaZera(StopienWierzcholkowy, NiePosiadaZera),
    write('NiePosiadaZera: '), write(NiePosiadaZera), nl,
    sum_list(StopienWierzcholkowy, Suma),
    write('Suma: '), write(Suma), nl,
    warunek(JestGraficzny, NiePosiadaZera, Suma, Odp2),
    write('CzySpojny: '), write(Odp2), nl.

warunek(JestGraficzny, NiePosiadaZera, Suma, Odp2) :-
    (   JestGraficzny == true,
        NiePosiadaZera == true,
        Suma mod 2 =:= 0
    ->  Odp2 = true
    ;   Odp2 = false
    ).

zacznij(List, SortedList, Odp1, Odp2) :-
    sortowanie_przez_wybieranie(List, SortedList),
    jest_ciagiem_graficznym(List, Odp1),
    czy_spojny(List, Odp2).

%zacznij([6,5,2,9,6,3,1,0,3,2,0], SortedList, Odp1, Odp2)
