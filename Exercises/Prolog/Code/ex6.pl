:- use_module(library(clpfd)).


% Trees - represent them as :
% [] is tree
% [L|R] is tree if L is tree and R is tree
%
% Second representation :
% nil is tree
% node(Value, Left, Right) is tree if Left is tree and Right is tree

% Helpers
nat(0).
nat(N):-nat(N1),N #= N1 + 1.

between1(A,B,A):-A #=< B.
between1(A,B,X):-A#<B, A1 #= A + 1, between1(A1,B,X).

genKS(1,S,[S]).
genKS(K, S, [Ni|Rest]):-K #> 1, K1 #= K - 1, between1(0, S, Ni),
    S1 #= S - Ni, genKS(K1, S1, Rest).
% End helpers


% Check if input is binary tree (first def)
tree1([]).
tree1([Left,Right]):-tree1(Left),tree1(Right).

% Check if input is binary tree (second def)
tree2(nil).
tree2(node(Left,Right)):-tree2(Left),tree2(Right).

% We can add values in nodes
% Check if input is binary tree (first def)
tree_value1([]).
tree_value1([_,Left,Right]):-tree_value1(Left),tree_value1(Right).

% Check if input is binary tree (second def)
tree_value2(nil).
tree_value2(node(_,Left,Right)):-tree2(Left),tree2(Right).

/*
 * We can't generate trees directly with those definitions,
 * because we are extending only the right successors.
 */

is_tree1(Tree) :-
    nat(Nodes),
    is_tree1(Tree, Nodes).

is_tree1(nil, 0).
is_tree1(node(_,TreeL,TreeR), N) :-
    N #> 0,
    NL + NR #= N - 1,
    NL #>= 0, NR #>= 0,
    is_tree1(TreeL, NL),
    is_tree1(TreeR, NR).

% Second way of generating them
is_tree2(Tree) :-
    nat(Nodes),
    is_tree2(Tree, Nodes).

is_tree2(nil, 0).
is_tree2(node(_,TreeL,TreeR), N):-
    N #> 0,
    NNext #= N - 1,
    between1(0, NNext, NLeft),
    NRight #= NNext - NLeft,
    is_tree2(TreeL,NLeft),
    is_tree2(TreeR,NRight).


% Generate with 3 successors
is_tree3(Tree) :-
    nat(Nodes),
    is_tree3(Tree, Nodes).

is_tree3(nil, 0).
is_tree3(node(_,TreeL,TreeM, TreeR), N):-
    N #> 0,
    NNext #= N - 1,
    genKS(3,NNext,[NL,NM,NR]),
    is_tree3(TreeL,NL),
    is_tree3(TreeR,NR),
    is_tree3(TreeM,NM).

% Generate with n successors
generate_tree_n(Tree, N) :-
    nat(Nodes),
    gen_tree_n(Tree, N, Nodes).

gen_tree_n(nil, _, 0).
gen_tree_n(node(_,S), N, Nodes) :-
    Nodes #> 0,
    NodesNext #= Nodes - 1,
    genKS(N,NodesNext,SNodes),
    genSuccessors(S, N, SNodes).

gen_successors([], _, []).
gen_successors([Successor|Rest], N, [Nodes|SNodes]):-
    gen_tree_n(Successor, N, Nodes),
    gen_successors(Rest, N, SNodes).



% Helpers
% Given A and B find the concatenation of AoB
append1([],B,B).
append1([H|T],B,[H|T1]):-append1(T,B,T1).


% Flatten
flatten1(X, [X]):- not(is_list1(X)).
flatten1([], []).
flatten1([H|T], R):- flatten1(H, FH), flatten1(T, FT),
	append1(FH, FT, R).

is_list1([]).
is_list1([_|_]).

is_list2([]).
is_list2([_|T]):-is_list2(T).


/*
 * Splits
 */
% Split list into two lists
split2([], [], []).
split2([H|T], [H|L], R):- split2(T, L, R).
split2([H|T], L, [H|R]):- split2(T, L, R).

% Split into three lists
split3([], [], [], []).
split3([H|T], [H|L], M, R):- split3(T, L, M, R).
split3([H|T], L, [H|M], R):- split3(T, L, M, R).
split3([H|T], L, M, [H|R]):- split3(T, L, M, R).

% Split generator
split([], []).
split(L, [H|R]):- append1(H, T, L), H \= [], split(T, R).

splitN(0, L, L).
splitN(K, L, R):- K > 0, K1 is K - 1, split(L, T), splitN(K1, T, R).

splitGen(L, R):- nat(N), splitN(N, L, R).


% Task from exam
reach(L, W, N):- getThemToTheRightSide(L, [], W, N).

getThemToTheRightSide([], _, _, N):- N >= 0.
getThemToTheRightSide(OnLeftSide, OnRightSide, W, N):-
    OnLeftSide \= [], N > 0, N1 is N - 1,
    partition(OnLeftSide, OnBoat, LeftOnLeftSide),
    sumWeights(OnBoat, OnBoatW), OnBoatW =< W,
    selectRower([RowerW, RowerC], OnBoat, OnBoatNoRower),
    RowerC > 0, NewRowerC is RowerC - 1,
    append(OnRightSide, [[RowerW, NewRowerC]|OnBoatNoRower], NewOnRightSide),
    getThemToTheLeftSide(LeftOnLeftSide, NewOnRightSide, W, N1).

getThemToTheLeftSide([], _, _, N):- N >= 0.
getThemToTheLeftSide(OnLeftSide, OnRightSide, W, N):-
    OnLeftSide \= [], N > 0, N1 is N - 1,
    partition(OnRightSide, OnBoat, LeftOnRightSide),
    sumWeights(OnBoat, OnBoatW), OnBoatW =< W,
    selectRower([RowerW, RowerC], OnBoat, OnBoatNoRower),
    RowerC > 0, NewRowerC is RowerC - 1,
    append(OnLeftSide, [[RowerW, NewRowerC]|OnBoatNoRower], NewOnLeftSide),
    getThemToTheRightSide(NewOnLeftSide, LeftOnRightSide, W, N1).

partition([], [], []).
partition([H|T], [H|R], L):- partition(T, R, L).
partition([H|T], R, [H|L]):- partition(T, R, L).

sumWeights([], 0).
sumWeights([[W, _]|T], N):- sumWeights(T, M), N is M + W.

remove(X, L, R):- append(A, [X|B], L), append(A, B, R).

selectRower(Rower, List, Rest):- remove(Rower, List, Rest).


% Task exam 2
sumPrices([], 0).
sumPrices([[_, C, _]|T], N):- sumPrices(T, M), N is M + C.

generateMenu(X, [[предястие, N1, D1], [основно, N2, D2], [десерт, N3, D3]]):-
    member([предястие, N1, D1], X),
    member([десерт, N3, D3], X),
    member([основно, N2, D2], X).

p(X, N, M):- generateMenu(X, M), sumPrices(M, Cost), Cost =< N.


% Task exam 3
edge(E, U, W):- member([U, W], E).

% Всички пътища от U го W с дължина K (не задължително прости a.k.a. ациклични).
pathLengthK(_, W, W, 0).
pathLengthK(E, U, W, K):-
    K > 0, K1 is K - 1,
    edge(E, U, V),
    pathLengthK(E, V, W, K1).

% Имаме, че G е слабо свързан и K > 1.
pr_Gr(E, K):-
    not(( edge(E, U, W),
        not(pathLengthK(E, U, W, K)) )).
