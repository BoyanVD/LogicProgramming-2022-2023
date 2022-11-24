:- use_module(library(clpfd)).

%Exercise 1
%Natural numbers
nat(c).
nat(s(X)):-nat(X).

%Sum of two natural numbers
sumNat(c,X,X).
sumNat(s(X),Y,s(Z)):-sum(X,Y,Z).

%Fibonacci: given N, find Fn, where F0 := 0, F1 := 1, Fn := Fn-1 + Fn-2
fib(0,0).
fib(1,1).
fib(N,Fn):-N#>0,N1#=N-1,N2#=N-2,fib(N1,Fn1),fib(N2,Fn2),Fn#=Fn1+Fn2.

fastfib(0,0,1).
fastfib(N,Fn,Fnext):-N#>0,Fprev#=Fnext-Fn,N1#=N-1,fastfib(N1,Fprev,Fn).

%Factorial: given N, find N!
factorial(0,1).
factorial(N,Fn):-N#>0,N1#=N-1,factorial(N1,Fn1),Fn#=N*Fn1.

%Given x, y find d,u,v,where d = gcd(x,y) and ux + vy = d
gcd(0,Y,Y,0,1).
gcd(X,Y,D,U,V):- X #>= Y,X1#=X-Y,V#=V1-U,gcd(X1,Y,D,U,V1).
gcd(X,Y,D,U,V):- Y #> X,gcd(Y,X,D,V,U).
