function [ feat ] = proposed_feature_jet( imdist )

% This code implements the feature extraction procedure proposed in the following paper:
% H. Hadizadeh and I. V. Bajic, "Color Gaussian Jet Features For No-Reference Quality Assessment of Multiply-Distorted Images,", IEEE Signal Processing Letters, Vol. 23, No.12, 2016

% inputs:
% imdist - the distorted image (color image)
% outputs:
% the extracted features by which a SVM regressor can be trained based on any arbitrary image quality assessment database

% Part of this code was adopted from the following paper:
%  Q. Li, W. Lin, and Y. Fang. "No-reference quality assessment for multiply-distorted images in gradient domain," in IEEE Signal Processing Letters , vol.PP, no.99, pp.1-1
%  doi: 10.1109/LSP.2016.2537321


scalenum = 5; %number of scales
feat = [];

R = 1; P = 8;
lbp_type = { 'ri' 'u2' 'riu2' };
y = 3;
mtype = lbp_type{y};
MAPPING = getmapping( P, mtype );

sigma = 1;

orig = imdist;

imdist = double(rgb2gray(imdist));
for itr_scale = 1:scalenum
    [jets, norm_jet] = computeJets(imdist, sigma);
    jets = abs(jets);
    if(itr_scale==1)
        norm_jet_orig = norm_jet;
    end
    
    for j=2:6
        LBPMap = lbp_new(jets(:,:,j),R,P,MAPPING,'x');
        
        wLBPHist = [];
        weightmap = norm_jet;
        wintesity = weightmap(2:end-1, 2:end-1);
        wintensity = abs(wintesity);
        for k = 1:max(LBPMap(:))+1
            idx = find(LBPMap == k-1);
            kval = sum(wintensity(idx));
            wLBPHist = [wLBPHist kval];
        end
        wLBPHist = wLBPHist/sum(wLBPHist);
        
        feat = [feat wLBPHist];
    end
    
    imdist = imresize(imdist, 0.5);
end

for itr_scale = 1:1
    
    [S, H, O, A] = extract_color_features(orig,sigma);
    [WW, HH] = size(S);
    Color = zeros(WW,HH,4);
    Color(:,:,1) = S;
    Color(:,:,2) = H;
    Color(:,:,3) = O;
    Color(:,:,4) = A;
    
    for j=3:4
        Color(:,:,j) = abs(Color(:,:,j));
        LBPMap = lbp_new(Color(:,:,j),R,P,MAPPING,'x');
        
        wLBPHist = [];
        weightmap = Color(:,:,j);
        wintesity = weightmap(2:end-1, 2:end-1);
        wintensity = abs(wintesity);
        for k = 1:max(LBPMap(:))+1
            idx = find(LBPMap == k-1);
            kval = sum(wintensity(idx));
            wLBPHist = [wLBPHist kval];
        end
        wLBPHist = wLBPHist/sum(wLBPHist);
        
        feat = [feat wLBPHist];
    end
        orig = imresize(orig, 0.5);
end
end

