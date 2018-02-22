%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relative Fuzzy Connectedness / Image Foresting Transform segmentation example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Read image and scale to [0,1]
I=im2double(imread('cameraman.tif'));
fprintf('Image size: %d x %d\n',size(I,1),size(I,2));

%Compute adjacency
n=sqrt(2);
k1=0.1;
A=adjacency(size(I),n,k1);

%Compute affinity
k2=2;
K=affinity(I,A,k2);

%Seed regions, numbered from 1 and up
S=zeros(size(I));

S(150:160,50:60)=1; %coat
%S(120:130,80:90)=1; %hand
%S(220:230,40:50)=1; %leg

S(20:30,160:170)=2; %sky
S(200:210,220:250)=3; %grass

%Show seeds overlayed on image
I_rgb=repmat(I,[1,1,3]); %make rgb image (required by imoverlay)

figure(1)
image(I_rgb)
imoverlay(S,S>0);
title('Seed regions');

%Compute FC using Image Foresting Transform
fprintf('Computing RFC as Image Foresting Transform\n');
[FC,Sout]=ift(S,K); %Competitive FC a la IFT

%Show resulting FC-map of connection to closes seed
figure(2)
imagesc(FC,[0,1])
colorbar
title('Fuzzy connectedness map');

%Show segmentation 
figure(3)
imagesc(Sout)
title('Fuzzy segmentation 1, IFT');

%Compute Iterative Relative Fuzzy Connectedness
fprintf('Computing Iterative Relative Fuzzy Connectedness\n');
Sout2=irfc(S,K); 

%Show segmentation
figure(4)
imagesc(Sout2)
title('Fuzzy segmentation 2, IRFC');
