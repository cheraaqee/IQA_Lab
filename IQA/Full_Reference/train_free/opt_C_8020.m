clear
close all
clc
load('portfolio.mat');
evaluator = 'WS_3HV';
dataset_name = 'QACS';
addpath(['./datasets/',dataset_name,'/']);
addpath(['./methods/',evaluator,'/'])
mkdir('paramoptimization')
for ii = 1:length(portfolio)
    if strcmp(portfolio(ii).name, dataset_name)
        n_ref = portfolio(ii).nref;
    end
end
%list the possible values for each parameter:
p1_vls = [45, 120];
p2_vls = [45, 120];
p3_vls = [45, 120];
p4_vls = [45, 120];
p5_vls = [45, 120];
p6_vls = [45, 120];
n_possiblities = length(p1_vls)*length(p2_vls)*length(p3_vls)*length(p4_vls)*...
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
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        N = 10;
                        REF = round(0.8*n_ref);
                        C = zeros(N,REF);
                        for j = 1:N
                            rand_order = randperm(n_ref);
                            C(j,:) = rand_order(1:REF);
                        end
                        %                         sroccs = load('./sroccs.mat');
                        for ith_srocc = 1:N
                            trainees = C(ith_srocc,:);
                            sroccs(ith_srocc) = abs(...
                                feval(['FR_',dataset_name,'_ref_based'],...
                                evaluator, ...
                                p1, p2, p3, p4, p5, p6, trainees));
                        end
                        
                        score_average = median(sroccs);
                        counter_2 = counter_2+1;
                        display([num2str(counter_2),'/' num2str(n_possiblities)])
                        param_space(p1_idx, p2_idx, p3_idx, ...
                            p4_idx, p5_idx, p6_idx) = score_average;
                    end
                end
            end
        end
    end
end
save(['./paramoptimization/QACS_mohammad_45_120_corrs.mat'], 'param_space');
maximum = max(max(max(max(max(max(param_space))))))
ellite = abs(param_space-maximum)<0.0001;
lindex = find(ellite, 1);
[p1_m, p2_m, p3_m, p4_m, p5_m, p6_m] = ...
    ind2sub([length(p1_vls) length(p2_vls) length(p3_vls) length(p4_vls) length(p5_vls) length(p6_vls)], lindex);
opt_p1 = p1_vls(p1_m)
opt_p2 = p2_vls(p2_m)
opt_p3 = p3_vls(p3_m)
opt_p4 = p4_vls(p4_m)
opt_p5 = p5_vls(p5_m)
opt_p6 = p6_vls(p6_m)
opt_array = [opt_p1, opt_p2, opt_p3, opt_p4, opt_p5, opt_p6];
save(['./paramoptimization/QACS_mohammad_45_120_params.mat'], 'opt_array');
