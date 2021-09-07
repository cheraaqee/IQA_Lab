function correlations = indexer_MDID2013(feactorator, cost_in, gamma_in, only_srocc_in, portion_in)
%INDEXER_MDID2013 Summary of this function goes here
%   Detailed explanation goes here
load(['./methods/', feactorator, '/FMX_MDID2013_', feactorator, '.mat']);
switch nargin
    case 1
        load(['./methods/', feactorator, '/optimized_cost_gamma_MDID2013.mat']);
        cost_max = optimized_cost_gamma_MDID2013(1,1);
        gamma_max = optimized_cost_gamma_MDID2013(1,2);
        only_srocc = 0;
        portion = 0.8;
    case 3
        cost_max = cost_in;
        gamma_max = gamma_in;
        only_srocc = 0;
        portion = 0.8;
    case 4
        cost_max = cost_in;
        gamma_max = gamma_in;
        only_srocc = only_srocc_in;
        portion = 0.8;
    case 5
        cost_max = cost_in;
        gamma_max = gamma_in;
        only_srocc = only_srocc_in;
        portion = portion_in;
end

%% Computing the indexes
Ref_number = 12;
N = 1000;
REF = round(Ref_number*portion);
C = zeros(N, REF);
for j=1:N
    rand_order = randperm(Ref_number);
    C(j, :) = rand_order(1:REF);
end
feactor_length = size(featrix_MDID2013, 2)-4;
data = featrix_MDID2013(:, 1:feactor_length);
label = 100*featrix_MDID2013(:, feactor_length+1);
c_str = sprintf('%f', cost_max);
g_str = sprintf('%.2f', gamma_max);
% libsvm_optoins = ['-s 3 -5 2 -g ', g_str, ' -c ', c_str];
bestp = 1;
libsvm_options = ['-c ', c_str, ' -g ', g_str, ' -s 3 -p ',num2str(bestp)];
spear_results = zeros(N, 1);
regression_models = cell(N, 1);
for i = 1:N
    train = ismember(featrix_MDID2013(:, feactor_length+2), C(i, :));
    test = ~train;
    model = svmtrain(label(train), data(train, :), libsvm_options);
    regression_models{i, 1} = model;
    [predict_score, ~, ~] = svmpredict(label(test), data(test, :), model);
    spear_results(i) = corr(predict_score, label(test), 'type', 'Spearman');
    if ~only_srocc
        kendall_results(i) = corr(predict_score, label(test), 'type', ...
            'Kendall');
        [PLCC(i) RMSE(i)] = PearsonLC(predict_score, label(test));
    end
end
spear_median = median(spear_results);

if ~only_srocc
    kendall_median = median(kendall_results);
    PLCC_median = median(PLCC);
    RMSE_median = median(RMSE);
    spear_std = std(spear_results, 0);
    
    kinds = cell(1,1);
    kinds{1,1} = 'ALL';
    
    indexes = cell(1,4);
    indexes{1,1} = 'SROCC';
    indexes{1,2} = 'PLCC';
    indexes{1,3} = 'RMSE';
    indexes{1,4} = 'KROCC';
    
    correlations = cell(length(kinds)+1, length(indexes)+1);
    correlations(1, 2:end) = indexes;
    correlations(2:end, 1) = kinds;
    
    correlations{2,2} = spear_median;
    correlations{2,3} = PLCC_median;
    correlations{2,4} = RMSE_median;
    correlations{2,5} = kendall_median;
    if nargin ~= 5
        save(['./methods/', feactorator, '/corr_MDID2013_', feactorator, '.mat'], ...
            'correlations');
        save(['./methods/', feactorator, '/thousand_spears_MDID2013', ...
            '_', feactorator, '.mat'], 'spear_results');
    else
        save(['./methods/', feactorator, '/corr_MDID2013_', num2str(portion*100),...
            '_', feactorator, '.mat'], ...
            'correlations');
    end
    disp(correlations)
else
    if nargin ~=5
        save(['./methods/', feactorator, '/spear_MDID2013_', feactorator, '.mat'],...
            'spear_median');
        save(['./methods/', feactorator, '/thousand_spears_MDID2013', ...
            '_', feactorator, '.mat'], 'spear_results');
    else
        save(['./methods/', feactorator, '/spear_MDID2013_', num2str(portion*100),...
            '_', feactorator, '.mat'],...
            'spear_median');
    end
end
close all
end

