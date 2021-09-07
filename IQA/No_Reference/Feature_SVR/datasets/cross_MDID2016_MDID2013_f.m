function correlations = cross_MDID2016_MDID2013(feactorator, cost_in, gamma_in)
load(['./methods/', feactorator, '/FMX_MDID2013_', feactorator, '.mat']);
load(['./methods/', feactorator, '/FMX_MDID2016_', feactorator, '.mat']);
switch nargin
    case 1
        load(['./methods/', feactorator, '/optimized_cost_gamma_MDID2016.mat']);
        cost_max = optimized_cost_gamma_MDID2016(1,1);
        gamma_max = optimized_cost_gamma_MDID2016(1,2);
        only_srocc = 0;
    case 3
        cost_max = cost_in;
        gamma_max = gamma_in;
end
N = 1;
[rows, cols] = size(featrix_MDID2016);
feactor_length = cols-10;
%% where is the feactor
data_train= featrix_MDID2016(:,1:feactor_length);
%%

%% feactors' corresponding vector of subjective scores:
label_train= featrix_MDID2016(:,feactor_length+1);
%%

%% where is the feactor
data_test= featrix_MDID2013(:,1:feactor_length);
%%

%% feactors' corresponding vector of subjective scores:
label_test= 100*featrix_MDID2013(:,feactor_length+1);
%%

cost = cost_max;
gamma = gamma_max;
c_str = sprintf('%f',cost);
g_str = sprintf('%.2f',gamma);
libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];

spear_results = zeros(N,1);

for i = 1:N
    
    model = svmtrain(label_train,data_train,libsvm_options);
    [predict_score, ~, ~] = svmpredict(label_test, data_test, model);
    spear_results(i) = corr(predict_score, label_test, 'type', 'Spearman');
    kendall_results(i) = corr(predict_score, label_test, 'type', ...
            'Kendall');
    [PLCC(i) RMSE(i)] = PearsonLC(predict_score, label_test);
end
spear_median = median(spear_results);
PLCC_median = median(PLCC);
RMSE_median = median(RMSE);
kendall_median = median(kendall_results);

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
save(['./methods/', feactorator, '/corr_cross_MDID2016_MDID2013_',feactorator, ...
'.mat'], 'correlations');
disp(correlations)
end
