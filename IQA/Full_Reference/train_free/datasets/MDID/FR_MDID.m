clear
clc
%% The name of your feactorator:
evaluator = 'sim_GM_sim_absDN_w';
%%

mos = importdata('mos.txt');
objective_MDID = zeros(1600,11);
objective_MDID(:,2) = mos;
counter = 0;
for refrence = 1:20
    dst_info_name = [num2str(refrence,'%02.f'),'.txt'];
    dst_info = importdata(dst_info_name);
    for distorted = 1:80
        counter = counter +1
        ref_img_name = ['./reference_images/img',num2str(refrence,'%02.f'),'.bmp'];
        dst_img_name = ['./distortion_images/img',num2str(refrence,'%02.f'),'_',num2str(distorted,'%02.f'),'.bmp'];
        ref_img = imread(ref_img_name);
        dst_img = imread(dst_img_name);
        
        %% if your evaluator doesn't accept RGB images, uncomment the following commands
        ref_img = double(rgb2gray(ref_img));
        dst_img = double(rgb2gray(dst_img));
        %%
        begin = tic;
        objective = feval(evaluator, ref_img, dst_img);
        nigeb = toc(begin);
        
        objective_MDID(counter,1) = objective;
        objective_MDID(counter,3) = refrence;
        objective_MDID(counter,4) = 0;
        objective_MDID(counter,5) = nigeb;
        objective_MDID(counter,6:11) = dst_info(distorted,:);
    end
end

save(['objective_MDID_',evaluator, '.mat'], 'objective_MDID')

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

correlations{2,2}=corr(objective_MDID(:,1), objective_MDID(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_MDID(:,1), objective_MDID(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_MDID(:,1),objective_MDID(:,2));


xlswrite(['corr_MDID_',evaluator,'.xls'], correlations);
disp(correlations);