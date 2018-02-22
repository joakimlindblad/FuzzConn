%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Absolute Fuzzy Connectedness segmentation example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Read image and scale to [0,1]
I=im2double(imread('cameraman.tif'));
fprintf('Image size: %d x %d\n',size(I,1),size(I,2));

%Compute adjacency
n=3;
k1=0.1;
A=adjacency(size(I),n,k1);

%Compute affinity
k2=2;
K=affinity(I,A,k2);

%Seed region
S=zeros(size(I));
S(150:160,50:60)=1; %coat

%Show seeds overlayed on image
I_rgb=repmat(I,[1,1,3]); %make rgb image (required by imoverlay)

figure(1)
image(I_rgb)
imoverlay(S,S>0);
title('Seed region');

%Compute FC
fprintf('Computing Absolute Fuzzy Connectedness map\n');
FC=afc(S,K); %Absolute FC

%Show resulting FC-map
figure(2)
imagesc(FC,[0,1])
colorbar
title('Fuzzy connectedness map');

%Threshold value
thresh=0.82;

%Show the 0.82-connected component overlayed on original image
figure(3)
image(I_rgb)
imoverlay(FC,FC>thresh);
title(sprintf('Fuzzy connected component at level %.2f',thresh));
