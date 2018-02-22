function A=adjacency(siz,n,k1)
%function A=adjacency(siz,n,k1)
% Input: image size, n=L1 distance of neighbourhood, k1=distance decline factor
%
% Compute adjacency according to (2.8) in Udupa '96
%
%Author: Joakim Lindblad

% Copyright (c) 2008-2018, Joakim Lindblad

[r,c]=deal(siz(1),siz(2));
N=r*c;

%abs delta of column and row coordinates
dC=abs(repmat([1:c],c,1)-repmat([1:c].',1,c));
dR=abs(repmat([1:r],r,1)-repmat([1:r].',1,r));

A=sparse(N,N); %output matrix

for dc=0:n %for each L1 distance level
	[bi,bj]=find(dC == dc); %r*r blocks with dc<=n
	for dr=0:n-dc
		[i,j]=find(dR == dr); %pixels within block with dr+dc<=n

		%The adjaceny
		a=1./(1+k1.*sqrt(dr.^2+dc.^2)); 

		blocksize=length(i);
		%compute global indices and put things into A
		p=zeros(length(bi)*blocksize,1);
		q=zeros(length(bi)*blocksize,1);
		for k=1:length(bi)
			p((k-1)*blocksize+1:k*blocksize)=(bi(k)-1)*r+i;
			q((k-1)*blocksize+1:k*blocksize)=(bj(k)-1)*r+j;
		end
		A=A+sparse(p,q,repmat(a,size(q)),N,N);
	end
end
