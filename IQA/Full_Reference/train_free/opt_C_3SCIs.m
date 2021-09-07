clear
close all
clc
%% HELP
% to use this script for optimizing the parametrs of a method, your method
% must be callable like this:
% >> score = method(ref, dst, p1, p2, p3, ...)
% then you should specify the list of possible values for each parameter
% and set the way the method is called in 'feval' statement in the body of
% this code.
% The datasets are limitted to screen content images at the moment. The
% similar 'FR_DatasetName_f_srocc.m' must be created for other datasets.
% After that it will be easy to recieve the list of datasets as an
% argument. (it is then better to change the file-name accordingly)
% The optimum parameters will be displayed and saved in a directory named
% 'paramoptimization'.
% Ah-huh:
% The optimization:
% find the sequence of parameters that will maximize:
% '	THE WEIGHTED-AVERAGE SROCC ON ALL DATASETS	'
%%
addpath(genpath('./datasets'));
addpath(genpath('./methods'));
evaluator = 'WS_3HV';
p1_vls = [50, 150];
p2_vls = [50, 75, 150];
p3_vls = [50, 150];
p4_vls = [50, 150];
p5_vls = [50, 75, 150];
p6_vls = [50, 150];
possiblities = length(p1_vls)*length(p2_vls)*length(p3_vls)*length(p4_vls)*...
    length(p5_vls)*length(p6_vls);
counter_2 = 0;
for p1_idx = 1:length(p1_vls)
    p1 = p1_vls(p1_idx);
    for p2_idx = 1:length(p2_vls)
        p2 = p2_vls(p2_idx);
        for p3_idx = 1:length(p3_vls)
            p3 = p3_vls(p3_idx);
            for p4_idx = 1:length(p4_vls)
                p4 = p4_vls(p4_idx);
                for p5_idx = 1:length(p5_vls)
                    p5 = p5_vls(p5_idx);
                    for p6_idx = 1:length(p6_vls)
                        p6 = p6_vls(p6_idx);
                        score_SIQAD = abs(FR_SIQAD_f_srocc(evaluator, p1, p2, p3, p4, p5, p6));
                        score_SCID_1600 =abs(FR_SCID_1600_f_srocc(evaluator, p1, p2, p3, p4, p5, p6));
                        score_QACS =abs(FR_QACS_f_srocc(evaluator, p1, p2, p3, p4, p5, p6));
                        score_average = (980*score_SIQAD+1600*score_SCID_1600+492*score_QACS)/(980+1600+492);
                        counter_2 = counter_2+1;
                        display([num2str(counter_2),'/' num2str(possiblities)])
                        param_space(p1_idx, p2_idx, p3_idx, p4_idx, p5_idx, p6_idx) = score_average;
                        
			% progressbar(1/(length(p1_vls)*length(p2_vls)*length(p3_vls)*length(p4_vls)*length(p5_vls)*length(p6_vls)))
                    end
                end
            end
        end
    end
end
save(['./paramoptimization/all_SCIs_2_3_corrs.mat'], 'param_space');
maximum = max(max(max(max(max(max(param_space))))))
ellite = abs(param_space-maximum)<0.0001;
lindex = find(ellite, 1);
[p1_m, p2_m, p3_m, p4_m, p5_m, p6_m] = ind2sub([length(p1_vls) length(p2_vls) length(p3_vls) length(p4_vls) length(p5_vls) length(p6_vls)], lindex);
opt_p1 = p1_vls(p1_m)
opt_p2 = p2_vls(p2_m)
opt_p3 = p3_vls(p3_m)
opt_p4 = p4_vls(p4_m)
opt_p5 = p5_vls(p5_m)
opt_p6 = p6_vls(p6_m)
opt_array = [opt_p1, opt_p2, opt_p3, opt_p4, opt_p5, opt_p6];
save(['./paramoptimization/all_SCIs_2_3_params.mat'], 'opt_array');
