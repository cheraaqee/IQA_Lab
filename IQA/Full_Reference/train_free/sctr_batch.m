addpath(genpath('./datasets'))
% The plots will be saved in the folder of each method listed in the variable `methods_list'.
% IT MUST BE NOTED that, you must have run the testing script prior to plotting the scatter plots.
methods_list = {'GMSD'};
for method_idx = 1:length(methods_list)
    evaluator = methods_list{method_idx};
    sctr_SCID(evaluator)
    sctr_QACS(evaluator)
    sctr_SIQAD(evaluator)
end
