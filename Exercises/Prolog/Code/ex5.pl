:- use_module(library(clpfd)).

% Natural numbers
nat(0).
nat(N):-nat(N1),N #= N1 + 1.

% Even natural numbers
even(0).
even(N):-even(N1),N #= N1 + 2.

even1(N):-nat(N),0 #= N mod 2.

% Divisable by K numbers
div_by_k(0,_).
div_by_k(N,K):-div_by_k(N1,K),N #= N1 + K.

% All integers in [A, B]
between1(A,B,A):-A #=< B.
between1(A,B,X):-A#<B, A1 #= A + 1, between1(A1,B,X).

% Generate all integers from range [A, B]
range(A,A,[A]).
range(A,B,[A|R]):-A #< B, A1 #= A + 1,range(A1,B,R).

% Generate pairs of natural numbers
pair(A,B):-nat(Sum),between1(0,Sum,A),Sum #= A + B.
pairs2(A, B):- nat(A), nat(B).

/*promblem with:
pairs2(A, B):- nat(A), nat(B).
pairs1(A, B):- nat(N), between(0, N, A), between(0, N, B).

*/

% Generate K numbers with sum S
genKS(1,S,[S]).
genKS(K, S, [Ni|Rest]):-K #> 1, K1 #= K - 1, between1(0, S, Ni),
    S1 #= S - Ni, genKS(K1, S1, Rest).

% generate all finite sequences of natural numbers
genAll2([]).
genAll2(L):- nat(N), between1(1, N, K),
    S #= N - K, genKS(K, S, L).

genAll([]).
genAll(L):- pair(K, S), K > 0, S > 0, genKS(K, S, L).


%Generate all finite sets of natural numbers
% Gen all sets, with elements less than N
gen_sets_max_el(0, []).
gen_sets_max_el(N, [N1 | S]) :- N #> 0, N1 #= N - 1, between1(0, N1, N2), gen_sets_max_el(N2, S).

gen_finite_sets(S) :- nat(N), gen_sets_max_el(N, S).


% Fibonacci numbers
%
% Old way
fib1(0,0).
fib1(1,1).
fib1(N,Fn):-N#>0,N1#=N-1,N2#=N-2,fib1(N1,Fn1),fib1(N2,Fn2),Fn#=Fn1+Fn2.
fib1(X):-nat(N),fib1(N,X).

fib(0, 1).
fib(Y, Z):- fib(X, Y), Z #= X + Y.
fib(X):- fib(X, _).

% Factoriel
fact1(0, 1).
fact1(N, F) :- N #> 0, N1 #= N - 1, fact1(N1, F1), F #= F1 * N.
fact1(X):-nat(N),fact1(N,X).


% Generate all finite arithmetic progressions
is_arithmetic([]).
is_arithmetic([_]).
is_arithmetic([A, B]):- A < B.
is_arithmetic(L):- (L = [X,Y,_|_]),X < Y,
	not(( append(_, [A, B, C|_], L), (A + C) =\=  (B + B) )).

gen_arithmetic(L):- genAll(L), is_arithmetic(L).

