% It is desired that you specify the methods and the datasets, then have a final
% comparsion. The tests are: per-dataset (80-20), per-dataset ([70-60-50-40]*),
% and cross-dataset. A box plot must be generated for the methods and a
% LaTeX table for the results. Cost&Gamma must be optimized for each
% dataset-method pair. It became complicated....
% The first time you want to test method, 'METHOD' on dataset, 'DATASET',
% you should:
% 1st: extract the feature vectors (feactors) of the images in DATASET
% using the feature extractor 'feactorator' of the METHOD. You can store
% these feactors in a matrix of features (featrix), where each row
% corresponds to a sample. Its the approach of Xue et. al. 2014, to save
% the corresponding label in the same row. + and also a number which
% specifies which reference image was used to generate this sample. So your
% featrix will have a format like:
% [feactor; label; ref_number]
%
% 2nd: optimize the Cost and Gamma parameters of SVR.
%
% 3rd: compute the performance indexes using the optimum cost and gamma.
% You may also alter the train-test portions from 80-20 to 70-30, 60-40,
% whatever... .
%
% After that you may train the METHOD on the entire images of one dataset,
% and test it on the entire images of another dataset.
clear
clc
close all
addpath(genpath('./datasets'));
addpath(genpath('./methods'));
% the_methods = {'proposed_yx', 'Grad_LOG_CP_TIP', 'gwhglbp_feature';0,0, 0};
the_methods = {'GM_LoG', 'proposed', 'GWH_GLBP','JetLBP';0,0,0,1}
% so as you see, the variable 'the_methods', is 2xM cell, where 'M' is the
% number of methods that you want to compare.
% the second row determines whether the method in the column operates on
% RGB images or not. If it is set to '1', an RGB image will be fed to the
% feature extractor. If set to '0', the image is assured to be a 2-D matrix of
% graylevel values.
datasets = {'MLIVE', 'MDID2013', 'MDID2016'}; % list the datasets here.
cost_range = [-3,3,15]; % by defult these will be the power's of 2 .The suggested
% range to begin with is : 2^3-2^15 for cost and 2^(-15)-2^(3) for gamma.
% The granularity of the search depends on your computing power.
% by setting:
% >> cost_range = [3:3:15];
% you are telling the search for cost values of 2^(3), 2^(6), 2^(9),...,
% 2^(15)
% ( '^' is the power operator)
gamma_range = [-15,3,3];
% if you want the specified range to be directly used as the values of cost
% and gamma, you should add a '0' as the fourth argument of
% 'cazama_optimizer_DATASET':
% >> [optimized_cost, optimzed_gamma] = feval(['cazama_optimizer_', ...
% datasets{dataset_idx}], cost_range, gamma_range, 0);
for method_idx = 1:size(the_methods, 2)
    for dataset_idx = 1:size(datasets, 2)
        %% extracting the feature vectors

        % featrix = feval(['featrixator_', datasets{dataset_idx}], ...
             % the_methods{1, 	method_idx}, the_methods{2, method_idx});
        
        % You should know that we are calling the function
        % 'featrixator_DATASET(feactorator, color_input)'
        % where 'DATASET' and 'feactoraotr' will be replaced by 'feval' to
        % corresponding values, i.e., :
        % 'featrixator_MLIVE(brisque, 0)'
        % 'featrixator_MLIVE(ILNIQE, 1)'
        % 'featrixator_MDID2016(brisque, 0)'
        % ....
        % The features vectors (feactors) of the corresponding method will
        % be saved in the file:
        % 'FMX_DATASET_METHOD.mat'
        % that contains the feactors in the variable 'featrix_DATASET'
        %% optimizing SVR's parameters
        [optimized_cost, optimized_gamma] = feval(['cazama_optimizer_', ...
            datasets{dataset_idx}], the_methods{1, 	method_idx},...
            cost_range, gamma_range);
        % so you specify a subset of R^2 (real numbers) to search for the
        % optimum (cost, gamma) ordered pair. The function will test all
        % the possible pairs and returns the one that led to the maximum
        % SROCC. You can also supply the function with a fourth argument as
        % explained above:
        % 'cazama_optimizer_DATASET(method, cost_range, gamma_range,
        % is_power_of_two)'
        % ! It must be noted that the FIRST time you are trying to
        % optimize C&G for a method on a dataset, the function stores that
        % value. If you try different ranges for improving the parameters,
        % the function checks whether there has been any improvements and
        % in that case, replaces the optimum parameters for that method on
        % that dataset.
        %% Computing the performance indexes
        correlations = feval(['indexer_', datasets{dataset_idx}],...
            the_methods{1,	method_idx}, optimized_cost, optimized_gamma);
        % There are a few options available for this function:
        %
        % 1- 'indexer_DATASET(METHOD)'
        % with this call, it is assumed that you have ran the
        % 'cazama_optimizer_DATASET' for this 'METHOD' and the functions attempts
        % to retrieve the optimum value for C&G. It then computes the
        % SROCC, PLCC, RMSE, and KROCC indexes with 1000, 80-20 splits.
        %
        % 2- 'indexer_DATASET(METHOD, cost_opt, gamma_opt)'
        % now, the same results of the previous call will be achieved, only
        % the value of C&G will be set to 'cost_opt' and 'gamma_opt'
        %
        % 3- 'indexer_DATASET(METHOD, cost_opt, gamma_opt, only_srocc)'
        % if you set 'only_srocc' to '1', the function will only compute
        % the SROCC (It is useful for testing purposes, since computing
        % PLCC and RMSE is time consuming). If you set it to 0, all indexes
        % will be computed. (The default is '0').
        %
        % 4- 'indexer_DATASET(METHOD, cost_opt, gamma_opt, only_srocc,
        % portoin)'
        % by defaut the splits are 80-20. You can set the portion of
        % 'train' samples with a number in (0, 1). (i.e. for 70-30 you
        % should set the porion to 0.7, and ...)
        %
        % oops:
        % if you want to specify values for 'only_srocc' or 'portion', you
        % HAVE TO pass the values for cost and gamma. I should have used
        % name-value pair arguments, but I don't know how to in MATLAB now.
        % One solution is to load the optimum values (, in case you don't
        % want to run the cazama_optimizer every time, )and then pass them
        % to indexer.
        %% let's test the 70-30, 60-40, 50-50, and 40-60 splits:
        for portion = 0.4:0.1:0.7
            feval(['indexer_', datasets{dataset_idx}],...
                the_methods{1, method_idx}, optimized_cost, ...
                optimized_gamma, 1, portion);
        end
    end
end
%% evaluating the generalization with cross_dataset train and test
% Now that we're sure we have optimzied C&G for all (method, dataset)
% pairs, we perform the cross-dataset test.
for method_idx = 1:size(the_methods, 2)
    for train_dataset_idx = 1:size(datasets, 2)
        for test_dataset_idx = 1:size(datasets, 2)
            if ~strcmp(datasets{train_dataset_idx}, datasets{test_dataset_idx})
                load(['./methods/', the_methods{1, method_idx}, ...
                    '/optimized_cost_gamma_', ...
                    datasets{train_dataset_idx}, '.mat']);
                feval(['cross_', datasets{train_dataset_idx}, ...
                    '_', datasets{test_dataset_idx}, '_f'], ...
                    the_methods{1, method_idx}, ...
                    optimized_cost_gamma(1,1), optimized_cost_gamma(1,2))
            end
        end
    end
end
the_methos_2 = {'GM_LoG', 'FISBLIM', 'SISBLIM', 'Monogenic', 'GWH_GLBP', 'proposed', 'BOSS', 'JetLBP'};
tabler_v2_f(the_methods_2, datasets, 'experiment_1');
tabler_v3_f(the_methods_2, datasets); % This is for generality tabl
tabler_v4_f(the_methods_2, datasets, portion*100) % for different portions
box_plotter(the_methods_2, datasets)
