:- use_module(library(clpfd)).


%Exercise 2
%Given X, L find if X in L
member1(X,[H|T]):-X#=H;member1(X,T).

member2(X,[X|_]).
member2(X,[H|T]):-H#\=X,member2(X,T).

member3(X,L):-append1(_,[X|_],L).

% Diven A and B find the concatenation of AoB
append1([],B,B).
append1([H|T],B,[H|T1]):-append1(T,B,T1).

% Given X and L : check if X is the last element of L
last1(X,[X]).
last1(X,[_|T]):-last1(X,T).


remove1(X,[X|T],T).
remove1(X,[H|T],[H|R]):-X#\=H,remove1(X,T,R).

remove2(X,List,Result):-append1(A,[X|B],List),append1(A,B,Result),not(member1(X,A)).

removeAll(_,[],[]).
removeAll(X,[X|T],R):-removeAll(X,T,R).
removeAll(X,[H|T],[H|R]):-X#\=H,removeAll(X,T,R).

permutation1([],[]).
permutation1(L,[H|T]):-remove1(H,L,M),permutation1(T,M).

reverse1([],[]).
reverse1([H|T],R):-reverse1(T,RT),append1(RT,[H],R).

isSorted([]).
isSorted([_]).
isSorted([X,Y|T]):-X#=<Y,isSorted([Y|T]).

subsequence([],[]).
subsequence([H|T],[H|R]):-subsequence(T,R).
subsequence([_|T],R):-subsequence(T,R).
