function K=affinity(I,A,k2)
%function K=affinity(I,A,k2)
% Input: I=image range [0,1], A=adjaceny(I), k2=gradient weight
%
%Computes affinity according to (2.9) in Upupa '96
%
%Author: Joakim Lindblad

% Copyright (c) 2008-2018, Joakim Lindblad

[i,j,a]=find(A); %get adjacencies
K=sparse(i,j,a./(1+k2.*abs(I(i)-I(j))),size(A,1),size(A,2));
