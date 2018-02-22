function [FC,S]=ift(S,K)
%function [FC,Sout]=ift(S,K)
%
%Image Foresting Transform (IFT) according to Malmberg 2009
% but with no Tie-breaking in this one (just first pick).
%S is labelled seed image
%K is (presumably sparse) symmetric matrix of size numel(S)*numel(S) 
%
%Author: Joakim Lindblad

% Dijkstra version

% Copyright (c) 2008-2018, Joakim Lindblad

%Pushing values instead of pulling, fits matlab better
FC=double(S>0); %init segm = seeds

Q=find(S); %push index to seeds on queue
while ~isempty(Q)
	fc=max(FC(Q)); %pick strongest fc in Q
	idx=find(FC(Q)==fc); %find all of same fc
   pick=Q(idx); %index in image
	Q(idx)=[]; %remove from Q
	%propagate affinity one layer
	[f,orig]=max(K(:,pick),[],2);
	f=min(fc,f); %compute fc for adjacent pixels
	idx=find(f>FC(:)); %find those with real change
   FC(idx)=f(idx); %update FC
	S(idx)=S(pick(orig(idx))); %update label
	Q=[Q;idx]; %push all updated spels
end
