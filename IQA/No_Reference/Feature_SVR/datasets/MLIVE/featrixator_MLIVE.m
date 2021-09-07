function featrix_MLIVE = featrixator_MLIVE(feactorator, state)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
%% Extract MLIVE features (generating the 'featrix'-"FEAtures maTRIX"
prey = imread('./datasets/MLIVE/Part 1/blurjpeg/babygirl.bmp');
if ~colorful
    prey = double(rgb2gray(prey));
end
feactor_length = length(feval(feactorator, prey));
% blur-jpeg (one of the two folders in the dataset)
load('./datasets/MLIVE/Part 1/Imagelists.mat');
load('./datasets/MLIVE/Part 1/Scores.mat');
featrix_MLIVE_J = zeros(225, feactor_length+5); % feactor (FEAture veCTOR),
% mos, ref, exe_time,first_distortion_level, second_distortion_level
featrix_MLIVE_J(:, feactor_length+1) = DMOSscores';
for aa = 1: 225
    impath = strcat('./datasets/MLIVE/Part 1/blurjpeg/', distimgs{aa});
    image = imread(impath);
    if ~colorful
        image = double(rgb2gray(image));
    end
    ref_number = 1;
    while ~strcmp(refimgs(ref_number), strcat(strtok(distimgs(aa), '_'),...
            '.bmp'))
        ref_number = ref_number+1;
    end
    
    begin = tic;
    feactor = feval(feactorator, image);
    nigeb = toc(begin);
    featrix_MLIVE_J(aa, 1:feactor_length) = feactor;
    featrix_MLIVE_J(aa, feactor_length+2) = ref_number;
    featrix_MLIVE_J(aa, feactor_length+3) = nigeb;
    featrix_MLIVE_J(aa, feactor_length+4:feactor_length+5) = ...
        distimgdistlevels(aa, :);
    disp(['MLIVE_', num2str(aa)])
end
% blur-noise (second folder)
load('./datasets/MLIVE/Part 2/Imagelists.mat');
load('./datasets/MLIVE/Part 2/Scores.mat');
featrix_MLIVE_N = zeros(225, feactor_length+5);
featrix_MLIVE_N(:, feactor_length+1) = DMOSscores;
for aa = 1:225
    impath = strcat('./datasets/MLIVE/Part 2/blurnoise/', distimgs{aa});
    image = imread(impath);
    if ~colorful
        image = double(rgb2gray(image));
    end
    ref_number = 1;
    while ~strcmp(refimgs(ref_number), strcat(strtok(distimgs(aa), '_'),...
            '.bmp'))
        ref_number = ref_number+1;
    end
    begin = tic;
    feactor = feval(feactorator, image);
    nigeb = toc(begin);
    featrix_MLIVE_N(aa, 1:feactor_length) = feactor;
    featrix_MLIVE_N(aa, feactor_length+2) = ref_number;
    featrix_MLIVE_N(aa, feactor_length+3) = nigeb;
    featrix_MLIVE_N(aa, feactor_length+4:feactor_length+5) = ...
        distimgdistlevels(aa, :);
    disp(['MLIVE_BN_', num2str(aa)])
end
featrix_MLIVE = cat(1, featrix_MLIVE_J, featrix_MLIVE_N);
save(['./methods/',feactorator, '/FMX_MLIVE_', feactorator, '.mat'],...
    'featrix_MLIVE');
end

