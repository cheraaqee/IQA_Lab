clear
clc
%% What is the name of your evaluator? place it here:
evaluator = 'sim_GM_sim_absDN_w';
%%
 
load('./Part 1/Imagelists.mat');
load('./Part 1/Scores.mat');

objective_MLIVE_J = zeros(225,6);%objective,mos,ref,exe_time,blur,jpeg
objective_MLIVE_J(:,2) = DMOSscores';
for aa = 1:225
    impath = strcat('./Part 1/blurjpeg/',distimgs{aa});
    ref_name = strcat(strtok(distimgs{aa}, '_'),'.bmp');
    ref_path = ['./Part 1/blurjpeg/',ref_name];
    image = imread(impath);
    ref_img = imread(ref_path);
    
    %% if your evaluator doesn't operate on RGB images, uncomment the following commands:
    image = double(rgb2gray(image));
    ref_img = double(rgb2gray(ref_img));
    %%
    
    ref_number = 1;
    while ~strcmp(refimgs(ref_number), strcat(strtok(distimgs(aa), '_'),'.bmp'))
        ref_number = ref_number+1;
    end
    
    begin = tic;
    objective = feval(evaluator,ref_img,image);
    nigeb = toc(begin);
    objective_MLIVE_J(aa,1) = objective;
    objective_MLIVE_J(aa,3) = ref_number;
    objective_MLIVE_J(aa,4) = nigeb;
    objective_MLIVE_J(aa,5:6) = distimgdistlevels(aa,:);
    aa
end
save(['objective_MLIVE_J_',evaluator,'.mat'],'objective_MLIVE_J');
clear all
%% What is the name of your evaluator? place it here:
evaluator = 'GMSD';
%%

load('./Part 2/Imagelists.mat');
load('./Part 2/Scores.mat');

objective_MLIVE_N = zeros(225,6);%objective,mos,ref,exe_time,blur,jpeg
objective_MLIVE_N(:,2) = DMOSscores';
for aa = 1:225
    impath = strcat('./Part 2/blurnoise/',distimgs{aa});
    ref_name = strcat(strtok(distimgs{aa}, '_'),'.bmp');
    ref_path = ['./Part 2/blurnoise/',ref_name];
    image = imread(impath);
    ref_img = imread(ref_path);
    
    %% if your evaluator doesn't operate on RGB images, uncomment the following commands:
    image = double(rgb2gray(image));
    ref_img = double(rgb2gray(ref_img));
    %%
    
    ref_number = 1;
    while ~strcmp(refimgs(ref_number), strcat(strtok(distimgs(aa), '_'),'.bmp'))
        ref_number = ref_number+1;
    end
    
    begin = tic;
    objective = feval(evaluator,ref_img,image);
    nigeb = toc(begin);
    objective_MLIVE_N(aa,1) = objective;
    objective_MLIVE_N(aa,3) = ref_number;
    objective_MLIVE_N(aa,4) = nigeb;
    objective_MLIVE_N(aa,5:6) = distimgdistlevels(aa,:);
    aa
end
save(['objective_MLIVE_N_',evaluator,'.mat'],'objective_MLIVE_N');

load(['objective_MLIVE_J_',evaluator,'.mat']);
objective_MLIVE = cat(1, objective_MLIVE_J, objective_MLIVE_N);
save(['objective_MLIVE_', evaluator, '.mat'], 'objective_MLIVE');

kinds = cell(3, 1);
kinds{1,1} = 'blur_jpeg';
kinds{2,1} = 'blur_noise';
kinds{3,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KENDALL';

correlations = cell(length(kinds)+1, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:end,1) = kinds;

correlations{2,2}=corr(objective_MLIVE_J(:,1), objective_MLIVE_J(:,2), 'type', 'Spearman');
correlations{3,2}=corr(objective_MLIVE_N(:,1), objective_MLIVE_N(:,2), 'type', 'Spearman');
correlations{4,2}=corr(objective_MLIVE(:,1), objective_MLIVE(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_MLIVE_J(:,1), objective_MLIVE_J(:,2), 'type', 'Kendall');
correlations{3,5}=corr(objective_MLIVE_N(:,1), objective_MLIVE_N(:,2), 'type', 'Kendall');
correlations{4,5}=corr(objective_MLIVE(:,1), objective_MLIVE(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_MLIVE_J(:,1), objective_MLIVE_J(:,2));
[correlations{3,3},correlations{3,4}] = PearsonLC(objective_MLIVE_N(:,1), objective_MLIVE_N(:,2));
[correlations{4,3},correlations{4,4}] = PearsonLC(objective_MLIVE(:,1), objective_MLIVE(:,2));

xlswrite(['corr_MLIVE_',evaluator,'.xls'], correlations);
disp(correlations);