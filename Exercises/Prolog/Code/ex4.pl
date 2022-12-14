:- use_module(library(clpfd)).

%Helpers
%Given X, L find if X in L
member1(X,L):-append1(_,[X|_],L).

% Given A and B find the concatenation of AoB
append1([],B,B).
append1([H|T],B,[H|T1]):-append1(T,B,T1).

% Given list L, generate all permutations of L
permutation1([],[]).
permutation1(L,[H|T]):-remove1(H,L,M),permutation1(T,M).

subsequence([],[]).
subsequence([H|T],[H|R]):-subsequence(T,R).
subsequence([_|T],R):-subsequence(T,R).

remove1(X,[X|T],T).
remove1(X,[H|T],[H|R]):-X#\=H,remove1(X,T,R).

reverse1([],[]).
reverse1([H|T],R):-reverse1(T,RT),append1(RT,[H],R).





% Gaphs, G = (V,E), where we will most often represent them as
%        V := [v1, v2, ..., vn]
%        E := [[v1,v2], [v2, v5], ... ]


% We will use next two predictes to extract vertices list from edges
% given
edgesToList([],[]).
edgesToList([H|T],Res):-edgesToList(T,TRes),append1(H,TRes,Res).

% Show them what happens if you swap toSet in clause
toSet([],[]).
toSet([H|T],[H|R]):-toSet(T,R),not(member1(H,R)).
toSet([H|T],R):-toSet(T,R),member1(H,R).

extractVertices(E,V):-edgesToList(E,L),toSet(L,V).

% Write predicate, that checks if path is correct (in undirected graph)
is_not_path(E, P) :- append1(_, [U, V | _], P), not( member1([U, V], E); member1([V, U], E) ).
is_path(E, P) :- not(is_not_path(E, P)).

% Write predicate that checks if path is hamilton
all_edges_not_in_path(V, P) :- member1(X, V), not(member1(X, P)).
is_hamilton(V, E, P) :- is_path(E, P), not(all_edges_not_in_path(V, P)).

% Generate all hamilton paths in graph
generate_hamilton_path(V, E, P) :- permutation1(V, P), is_hamilton(V, E, P).

% Wrtite predicate, that checks if there is clique in graph
is_not_clique(V, E) :- member1(X, V), member1(Y, V), Y #\= X, not(is_edge(X, Y, E)).
is_clique(V, E) :- not(is_not_clique(V, E)).

is_edge(U,V,E):-member1([U,V],E).

% Generate all cliques in graph
generate_clique([V, E], C) :- subsequence(V, C), is_clique([C, E]).

% Find path between X and Y
path(_,Y,Y,Visited,Path):-reverse1(Visited,P),append1(P,[Y],Path).
path(E,X,Y,Visited,Path):-X#\=Y,member1([X,Z],E), not(member1(Z,Visited)),
    path(E,Z,Y,[X|Visited],Path).

path(E, X, Y, P):- path(E, X, Y, [], P).
% path([[1,2],[2,3],[2,4],[1,4],[3,5]],1,5,P).
% path([[1,2],[2,3],[2,4],[1,4],[3,5],[7,8]],1,7,P).
%

cycle(E,Cycle):-member1([V1,V2],E),V1\=V2,path(E,V2,V1,P),
    append1([V1],P,Cycle).

is_connected(V, E):- not(( member1(X, V), member1(Y, V), X \= Y, not(path(E, X, Y, _)) )).



% DFS
%
% Caller function
dfs(E, Root, Result):- dfs_helper(E, [Root], [], Result).

% Helper function
dfs_helper(_, [], _ , []).
dfs_helper(E, [StackH|StackT], Visited, [[StackH, Next]|Result]):-
	next_vertice(E, StackH, [StackH|StackT], Visited, Next),
	dfs_helper(E, [Next, StackH|StackT], Visited, Result).
dfs_helper(E, [StackH|StackT], Visited, Result):-
	not(next_vertice(E, StackH, [StackH|StackT], Visited, _)),
	dfs_helper(E, StackT, [StackH|Visited], Result).

next_vertice(E, Curr, Container, Visited, Next):-
	member1([Curr, Next], E),
	not(member1(Next, Container)),
	not(member1(Next, Visited)).
