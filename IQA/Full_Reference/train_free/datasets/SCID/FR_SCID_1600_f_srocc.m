function index = FR_SCID_1600_f_srocc(evaluator, p1, p2, p3, p4, p5, p6)
% addpath(genpath('E:\DATABASES\SCID'));
objective_SCID_1600 = zeros(1600, 6);
load('./datasets/SCID/MOS_SCID.mat');
img_idx = 0;
for ref_idx = 1:40
    for dst_idx = [1,2,3,4,5,6,8,9]
        for dst_lev = 1:5
            ref_nme = ['SCI', num2str(ref_idx,'%02.f'),'.bmp'];
            ref_pth = ['./datasets/SCID/ReferenceSCIs/',ref_nme];
            ref_img = imread(ref_pth);
            dst_nme = ['SCI', num2str(ref_idx,'%02.f'),'_',...
                num2str(dst_idx),'_',num2str(dst_lev),'.bmp'];
            dst_pth = ['./datasets/SCID/DistortedSCIs/', dst_nme];
            dst_img = imread(dst_pth);
            %
%             ref_img = double(rgb2gray(ref_img));
%             dst_img = double(rgb2gray(dst_img));
            %
            begin = tic;
            score = feval(evaluator, ref_img, dst_img, p1, p2, p3, p4, p5, p6);
            nigeb = toc(begin);
            img_idx = img_idx+1;
	    mos_idx = 45*(ref_idx-1)+5*(dst_idx-1)+dst_lev;
            objective_SCID_1600(img_idx, 1) = score;
            objective_SCID_1600(img_idx, 2) = MOS_SCID(mos_idx);
            objective_SCID_1600(img_idx, 3) = ref_idx;
            objective_SCID_1600(img_idx, 4) = dst_idx;
            objective_SCID_1600(img_idx, 5) = dst_lev;
            objective_SCID_1600(img_idx, 6) = nigeb;
        end
    end
end
% save(['./', evaluator, '/objective_FR_SCID_1600_',evaluator, '.mat'], 'objective_SCID_1600');
% distortions = {'GN'; 'GB'; 'MB'; 'CC'; 'JPEG'; 'JPEG2000'; 'HEVC-SCC'; 'CQD'};
% the_indexes = { 'SROCC', 'PLCC', 'RMSE', 'KROCC'};
%correlations = cell(length(distortions)+2, length(the_indexes)+1);
%correlations{1,1} = 'type';
%correlations{end, 1} = 'ALL';
% correlations(2:end-1,1) = distortions;
%correlations(1,2:end) = the_indexes;
%tbl_idx = 0;
%for dst_idx = [1,2,3,4,5,6,8,9]
%    founds = find(objective_SCID_1600(:,4)==dst_idx);
%    objectiveha = objective_SCID_1600(founds, 1);
%    subjectiveha = objective_SCID_1600(founds, 2);
%    tbl_idx = tbl_idx+1;
%    correlations{tbl_idx+1, 2}  = corr(objectiveha, subjectiveha, 'type', 'spearman');
%    [correlations{tbl_idx+1, 3} , correlations{tbl_idx+1, 4} ] = PearsonLC(objectiveha, subjectiveha);
%    correlations{tbl_idx+1, 5}  = corr(objectiveha, subjectiveha, 'type', 'spearman');
%end
index  = corr(objective_SCID_1600(:,1), objective_SCID_1600(:,2), 'type', 'spearman');
% [correlations{end,3}, correlations{end, 4}] = PearsonLC(...
%    objective_SCID_1600(:, 1), objective_SCID_1600(:, 2));
% correlations{end, 5} = corr(objective_SCID_1600(:, 1), objective_SCID_1600(:, 2), ...
%    'type', 'kendall');
%save(['./', evaluator, '/corrs_SCID_1600_', evaluator, '.mat'], 'correlations');
% xlswrite(['./', evaluator, '/corrs_SCID_', evaluator, '.xls'], correlations);
end
