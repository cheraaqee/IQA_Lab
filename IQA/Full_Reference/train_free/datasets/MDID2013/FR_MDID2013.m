clear
clc
%% Instructions-I
% 1- what is the name of your evaluator?, type it below: (evaluator =
% 'the name of your evaluator')
evaluator = 'sim_GM_sim_absDN_w';
%% end of the first instructins

load('MDID_dmos.mat');
objective_MDID13 = zeros(324, 5);%objective,mos,ref,dst,exe
objective_MDID13(:, 2) = MDID_dmos;
for aa = 1:324
    image_name = ['./MDID2013/img',num2str(aa,'%03.f'),'.png'];
    ref_name = ['./MDID2013/org',num2str(ceil(aa/27),'%03.f'),'.png'];
    image = imread(image_name);
    ref = imread(ref_name);
    %% Instructions-II
    % 1- If your evaluator operates merely on grayscale images, uncomment
    % the following commands
    image = double(rgb2gray(image));
    ref = double(rgb2gray(ref));
    %% end of the second instructions
    
    begin = tic;
    objective = feval(evaluator,ref, image);
    nigeb = toc(begin);
    
    ref_number = ceil(aa/27);
    objective_MDID13(aa, 1) = objective;
    objective_MDID13(aa, 3) = ref_number;
    objective_MDID13(aa, 4) = 0;
    objective_MDID13(aa, 5) = nigeb;
    aa
end
save(['objective_MDID2013_',evaluator, '.mat'], 'objective_MDID13')

kinds = cell(1, 1);
kinds{1,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KENDALL';

correlations = cell(2, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2,1) = kinds;

correlations{2,2}=corr(objective_MDID13(:,1), objective_MDID13(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_MDID13(:,1), objective_MDID13(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_MDID13(:,1),objective_MDID13(:,2));


xlswrite(['corr_MDID2013_',evaluator,'.xls'], correlations);
disp(correlations);