function [optimized_cost, optimized_gamma] = cazama_optimizer_MDID2013(feactorator, cost_range, gamma_range, is_power_of_2_in)
%CAZAMA_OPTIMIZER_MDID2013 Summary of this function goes here
%   Detailed explanation goes here
if nargin <4
    is_power_of_2 = 1;
else
    is_power_of_2 = is_power_of_2_in;
end
load(['./methods/', feactorator, '/FMX_MDID2013_', feactorator, '.mat']);
%% Optimizing Cost and Gamma parameters on the specified range
% number of reference images in the dataset:
Ref_number = 12;
N = 100;
REF = round(Ref_number*0.8);
C = zeros(N, REF);
for j = 1:N
    rand_order = randperm(Ref_number);
    C(j, :) = rand_order(1: REF);
end
feactor_length = size(featrix_MDID2013, 2)-4;
data = featrix_MDID2013(:, 1:feactor_length);
label = 100*featrix_MDID2013(:, feactor_length+1);
if is_power_of_2
    cost_power = cost_range(1):cost_range(2):cost_range(3);
    gamma_power = gamma_range(1):gamma_range(2):gamma_range(3);
    cost_set = power(2, cost_power);
    gamma_set = power(2, gamma_power);
else
    cost_set = cost_range(1):cost_range(2):cost_range(3);
    gamma_set = gamma_range(1):gamma_range(2):gamma_range(3);
end

init_cost = cost_set(1);
step_cost = cost_set(2)-cost_set(1);
init_gamma = gamma_set(1);
step_gamma = gamma_set(2)-gamma_set(1);
n_cost = length(cost_set);
n_gamma = length(gamma_set);
med_map = zeros(n_cost+1, n_gamma+1);
med_map(1:n_cost, n_gamma+1) = cost_set';
med_map(n_cost+1, 1:n_gamma) = gamma_set;
std_map = zeros(n_cost+1, n_gamma+1);
std_map(1:n_cost, n_gamma+1) = cost_set';
std_map(n_cost+1, 1:n_gamma) = gamma_set;
spr_rows = n_cost*n_gamma;
spr_mat = zeros(spr_rows, N);
co_ga = 0;
row = 0;

for aa = cost_set
    row = row+1;
    col = 0;
    for bb = gamma_set
        col = col+1;
        cost = aa;
        gamma = bb;
        co_ga = co_ga+1;
        c_str = sprintf('%f', cost);
        g_str = sprintf('%.2f', gamma);
        % 		libsvm_options = ['-s 3 -5 2 -g ', g_str, ' -c ', c_str];
        bestp = 1;
        libsvm_options = ['-c ', c_str, ' -g ', g_str, ' -s 3 -p ',...
            num2str(bestp)];
        
        % %         libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];
        %         bestp = 1;
        %         libsvm_options = ['-c ', c_str, ' -g ', g_str, ' -s 3 -p ', num2str(bestp)];
        spear_results = zeros(N, 1);
        for i = 1:N
            train = ismember(featrix_MDID2013(:, feactor_length+2),...
                C(i, :));
            test = ~train;
            model = svmtrain(label(train), data(train, :), ...
                libsvm_options);
            [predict_score, ~, ~] = svmpredict(label(test),...
                data(test, :), model);
            spear_results(i) = corr(predict_score, label(test),...
                'type', 'Spearman');
            spear_median = median(spear_results);
            spear_std = std(spear_results, 0);
        end
        spr_mat(co_ga, :) = spear_results';
        med_map(row, col) = spear_median;
        std_map(row, col) = spear_std;
    end
end
med_map2 = med_map(1:n_cost, 1:n_gamma);
spear_max = max(max(med_map2));
[the_cost, the_gamma] = find(abs(med_map-spear_max)<0.0001);
cost_max = med_map(the_cost, end);
gamma_max = med_map(end, the_gamma);
contour(log2(gamma_set), log2(cost_set), med_map2, 'ShowText', 'on'), ...
    xlabel('lg(gamma)'), ylabel('lg(cost)'), grid on
mkdir(['./methods/', feactorator,'/cost_gamma_optimization'])
saveas(gcf, ['./methods/', feactorator, '/cost_gamma_optimization/cntrs_MDID2013_',...
    feactorator, '_', num2str(spear_max), '_', num2str(cost_max(1,1)), '_', num2str(gamma_max(1,1)), '.png'])
save(['./methods/', feactorator, '/cost_gamma_optimization/sprs_MDID2013_', ...
    feactorator, '_', num2str(spear_max),'_', num2str(cost_max(1,1)), '_', num2str(gamma_max(1,1)), ...
    '.mat'], 'spr_mat');
try
    xlswrite(['./methods/',feactorator,'/cost_gamma_optimization/med_MDID2013_',...
        feactorator, '_', num2str(spear_max),'_', num2str(cost_max(1, 1)), '_', ...
        num2str(gamma_max(1,1)), '.xlsx']);
catch
    disp('could not save excel')
end
try
    load('./methods/',feactorator,'/optimized_cost_gamma_MDID2013.mat');
    if optimized_cost_gamma(1,3) < spear_max
        disp(optimized_cost_gamma)
        optimized_cost_gamma(1,1) = cost_max(1, 1);
        optimized_cost_gamma(1,2) = gamma_max(1, 1);
        optimized_cost_gamma(1,3) = spear_max;
        save(['./methods/', feactorator, '/optimized_cost_gamma_MDID2013.mat']...
            , 'optimized_cost_gamma')
        disp('###############################')
        disp(optimized_cost_gamma)
        disp('###############################')
    end
catch
    optimized_cost_gamma = zeros(1,3);
    optimized_cost_gamma(1,1) = cost_max(1, 1);
    optimized_cost_gamma(1,2) = gamma_max(1, 1);
    optimized_cost_gamma(1,3) = spear_max;
    save(['./methods/', feactorator, '/optimized_cost_gamma_MDID2013.mat'], ...
        'optimized_cost_gamma')
end
optimized_cost = cost_max(1, 1);
optimized_gamma = gamma_max(1, 1);
close all
end

