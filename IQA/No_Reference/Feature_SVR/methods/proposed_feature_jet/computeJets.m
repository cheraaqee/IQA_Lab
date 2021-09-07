function [jet, norm_jet] = computeJets(im, sigma)
% COMPUTEBIFS - Computes basic images features
%
% im            Image used for BIFs computation.
% sigma         Filter scale
% epislon       Amout of the image clasified as flat
%
% ----- Literature References:
% Griffin et al.
% Basic Image Features (BIFs) Arising from Approximate Symmetry Type.
% Proceedings of the 2nd International Conference on Scale Space and Variational Methods in Computer Vision (2009)
%
% Griffin and Lillholm.
% Symmetry sensitivities of derivative-of-Gaussian filters.
% IEEE Trans Pattern Anal Mach Intell (2010) vol. 32 (6) pp. 1072-83
%
% Matlab implementation by  Nicolas Jaccard (nicolas.jaccard@gmail.com)

% Load image and normalize
if(~strcmp(class(im),'double'))
    if(~(ndims(im)==3))
        im = double(im)/255;
    else
        im = double( rgb2gray( im ) )/255;
    end
end

% Dervative orders list
orders=[0, 0; 1, 0; 0, 1; 2, 0; 1, 1;0, 2];

% Compute jets
jet = zeros(size(im,1),size(im,2),6);

% Do the actual computation

DtGfilters = DtGfiltersBank(sigma);

for i=1:size(orders,1)
    jet(:,:,i)=efficientConvolution(im,DtGfilters{i,1},DtGfilters{i,2})*(sigma^(sum(orders(i,:))));
end

s2 = sigma^2;
c10 = jet(:,:,2);
c01 = jet(:,:,3);
c20 = jet(:,:,4);
c11 = jet(:,:,5);
c02 = jet(:,:,6);
norm_jet = sqrt(s2*(c10.^2+c01.^2) + 0.25*s2*s2*(c20+c02).^2 + 0.25*s2*s2*((c20-c02).^2+4*c11.^2));

end