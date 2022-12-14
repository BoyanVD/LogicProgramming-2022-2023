:- use_module(library(clpfd)).

%Given X, L find if X in L
member1(X,L):-append1(_,[X|_],L).

% Given A and B find the concatenation of AoB
append1([],B,B).
append1([H|T],B,[H|T1]):-append1(T,B,T1).

reverse1([],[]).
reverse1([H|T],R):-reverse1(T,RT),append1(RT,[H],R).


% Given list of lists L : find all elements from the cartesian product
% of the lists in L
cartesianProduct([],[]).
cartesianProduct([Li|T],[Ai|R]):-member1(Ai,Li),cartesianProduct(T,R).

% Given element E, index I and list L : check if E is the the element on
% index I in L.
nthElement(E,0,[E|_]).
nthElement(E,I,[H|T]):-E#\=H,I1#=I-1,nthElement(E,I1,T).

%Selection sort:
selectionSort([],[]).
selectionSort(L,[H|T]):-minElement(L,H),
    removeElement(H,L,R),
    selectionSort(R,T).

removeElement(E,L,R):-appendLists(A,[E|B],L),
    appendLists(A,B,R).

appendLists([],B,B).
appendLists([H|T],B,[H|R]):-appendLists(T,B,R).

minElement([E],E).
minElement([H|T],E):-minElement(T,M),minTwo(M,H,E).

minTwo(A,B,A):-A#=<B.
minTwo(A,B,B):-A#>B.

% Merge sort :
merge1([], Y, Y).
merge1(X, [], X).
merge1([X1 | X], [Y1 | Y], [Y1 | Z]) :- Y1 #=< X1, merge1([X1 | X], Y, Z).
merge1([X1 | X], [Y1 | Y], [X1 | Z]) :- X1 #< Y1, merge1(X, [Y1 | Y], Z).

split([], [], []).
split([A], [A], []).
split([A, B | L], [A | L1], [B | L2]) :- split(L, L1, L2).

merge_sort([], []).
merge_sort([A], [A]).
merge_sort([A, B | L], S) :- split([A, B | L], L1, L2), merge_sort(L1, S1), merge_sort(L2, S2), merge1(S1, S2, S).

%Quick sort
partition1(_, [], [], []).
partition1(Pivot, [H|T], [H|L], R):- Pivot >= H, partition1(Pivot, T, L, R).
partition1(Pivot, [H|T], L, [H|R]):- Pivot < H, partition1(Pivot, T, L, R).

quickSort([], []).
quickSort([H|T], R):- partition1(H, T, PL, PR), quickSort(PL, SL), quickSort(PR, SR), append1(SL, [H|SR], R).


% union, intersection, difference, subset, equal
element_in_union(X, A, B):- member1(X, A); member1(X, B).
element_in_intersection(X, A, B):- member1(X, A), member1(X, B).
element_in_difference(X, A, B):- member1(X, A), not(member1(X, B)).
subset_of(A, B):- not((member1(X, A), not(member1(X, B)))).
are_equal(A, B):- subset_of(A, B), subset_of(B, A).


% Given : list of different lists L
% Task : check if all two different elements of L have common element,
% which is not part of any other element of L.
%
%
% Note : solution done in class was correct, my pre-prepared tests were
% wrong !!!

pred(L):- not(( member1(A, L), member1(B, L), not(are_equal(A,B)),
	not(( element_in_intersection(X, A, B), not(( member1(C, L), not(are_equal(C,A)), not(are_equal(C,B)), member1(X, C) )) )) )).

% Tests
% ?- pred([[1,2,3], [1,2,4], [2,3,4], [1,2,3,4], [2,3,5]]).
% false.
% ?- pred([[1,3],[1,2,4],[2,3,4]]).
% true.
% ?- pred([[1,2,3], [1,2,4], [2,3,4], [1,2,3,4]]).
% false.












