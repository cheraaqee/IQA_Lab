function [score, quality_mapdir] = MD_GD(Y1_in_in, Y2_in_in, TT_in)
% This is an implentation for:
% "Cheraaqee, P., Mansouri, A., & Mahmoudi-Aznaveh, A. (2019). 
% Incorporating Gradient Direction for Assessing Multiple Distortions. 
% 4th International Conference on Pattern Recognition and Image Analysis 
% (IPRIA). https://doi.org/10.1109/pria.2019.8785992"
% This implementation is slightly different from the paper. Here, the
% absolute value of the angles are considered (180 degrees instead of 360),
% which improves the correlation of the index with subjective scores. 
% The calculation of gradient magnitude similarity is adapted from the 
% implementation of Xue et al. for:
% "Xue, W., Zhang, L., Mou, X., & Bovik, A. C. (2014). 
% Gradient magnitude similarity deviation: A highly efficient perceptual 
% image quality index. 
% IEEE Transactions on Image Processing, 23(2), 668–695. 
% https://doi.org/10.1109/TIP.2013.2293423"
%
% If 'ref' and 'dst' are two images, the function can be called as:
% >> objective_score = sim_GM_sim_absDN_w(ref, dst);
% where the variable 'objective_score' holds the quality score.
% The map for gradient direction similarity can be stored in the variable
% 'map':
% >> [objective_score, map] = sim_GM_sim_absDN_w(ref, dst);
% The constant in the similarity relation, TT, can also passed as an 
% argument ('sim_GM_sim_absDN_w(ref, dst, TT)').
switch nargin
    case 2
        Y1_in = Y1_in_in;
        Y2_in = Y2_in_in;
        TT = 150;
    case 3
        Y1_in = Y1_in_in;
        Y2_in = Y2_in_in;
        TT = TT_in;
end
if length(size(Y1_in))>2
    Y1 = double(rgb2gray(Y1_in));
    Y2 = double(rgb2gray(Y2_in));
else
    Y1 = Y1_in;
    Y2 = Y2_in;
end

T = 170; 
Down_step = 2;
dx = [1 0 -1; 1 0 -1; 1 0 -1]/3;
dy = dx';

aveKernel = fspecial('average',2);
aveY1 = conv2(Y1, aveKernel,'same');
aveY2 = conv2(Y2, aveKernel,'same');
Y1 = aveY1(1:Down_step:end,1:Down_step:end);
Y2 = aveY2(1:Down_step:end,1:Down_step:end);

IxY1 = conv2(Y1, dx, 'same');     
IyY1 = conv2(Y1, dy, 'same'); 
dirY1=abs(atan2d(IyY1,IxY1));
gradientMap1 = sqrt(IxY1.^2 + IyY1.^2);

IxY2 = conv2(Y2, dx, 'same');     
IyY2 = conv2(Y2, dy, 'same');
dirY2=abs(atan2d(IyY2,IxY2));

gradientMap2 = sqrt(IxY2.^2 + IyY2.^2);
quality_mapdir = (2*dirY1.*dirY2 + TT) ./(dirY1.^2+dirY2.^2 + TT);
quality_map = (2*gradientMap1.*gradientMap2 + T) ./(gradientMap1.^2+gradientMap2.^2 + T);

Gm = max(gradientMap1, gradientMap2);
SimMatrix = quality_mapdir .* quality_map .* Gm;
score = sum(sum(SimMatrix)) / sum(sum(Gm));
