function correlations = FR_KADID10K_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
%------------------------
mkdir(['./methods/', evaluator])
dmos = readmatrix('./datasets/KADID10K/dmos.csv');
dmos = dmos(:, 3);
objective_KADID10K = zeros(10125, 5);
in_KADID10K = 0;
for ref_idx = 1:81
    ref = imread(['./datasets/KADID10K/images/I',num2str(ref_idx, '%02.f'), '.png']);
    for dst_typ = 1:25
        for dst_lvl = 1:5
            in_KADID10K = in_KADID10K+1
            dst = imread(['./datasets/KADID10K/images/I', num2str(ref_idx, '%02.f'), '_', ...
                num2str(dst_typ, '%02.f'), '_', ...
                num2str(dst_lvl, '%02.f'), '.png']);
            %             if length(size(ref))>2
            %                 ref = double(rgb2gray(ref));
            %             end
            %             if length(size(dst))>2
            %                 dst = double(rgb2gray(dst));
            %             end
            switch colorful
                case 0
                    dst = double(rgb2gray(dst));
                    ref = double(rgb2gray(ref));
                case 1
                    if length(size(ref))>2
                        ref = double(rgb2gray(ref));
                    end
                    if length(size(dst))>2
                        dst = double(rgb2gray(dst));
                    end
                case 2
                    dst = dst;
                    ref = ref;
            end
            begin = tic;
            objective = feval(evaluator, ref, dst);
            nigeb = toc(begin);
            objective_KADID10K(in_KADID10K, 1) = objective;
            objective_KADID10K(in_KADID10K, 2) = dmos(in_KADID10K);
            objective_KADID10K(in_KADID10K, 3) = ref_idx;
            objective_KADID10K(in_KADID10K, 4) = dst_typ;
            objective_KADID10K(in_KADID10K, 5) = dst_lvl;
            objective_KADID10K(in_KADID10K, 6) = nigeb;
        end
    end
end
save(['./methods/', evaluator, '/objective_KADID10K_', evaluator, '.mat'], 'objective_KADID10K')
kinds = {'GB', 'LB', 'MB', 'ColDiff', 'ColShift', 'ColQuan', 'ColSat', ...
    'ColSat2', 'JP2K', 'JPEG', 'WN', 'ColWn', 'ImpN', 'MultN', 'DeN', 'Br', ...
    'Dr', 'MS', 'Jietter', 'eccen', 'pixelate', 'quan', 'cblocks', 'hsharp',...
    'cc', 'ALL'};
kinds = kinds';
indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KROCC';
correlations = cell(2, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:length(kinds)+1,1) = kinds;
for dst_idx = 1:length(kinds)-1
    rows_of_distortion = find(objective_KADID10K(:,4)==dst_idx);
    obj_dst = objective_KADID10K(rows_of_distortion, 1);
    sbj_dst = objective_KADID10K(rows_of_distortion, 2);
    correlations{dst_idx+1, 2}=...
        corr(obj_dst, sbj_dst, 'type', 'Spearman');
    correlations{dst_idx+1, 5}=...
        corr(obj_dst, sbj_dst, 'type', 'Kendall');
    [correlations{dst_idx+1,3},correlations{dst_idx+1,4}] = ...
        PearsonLC(obj_dst,sbj_dst);
end
correlations{end,2}=corr(objective_KADID10K(:,1), objective_KADID10K(:,2), 'type', 'Spearman');
correlations{end,5}=corr(objective_KADID10K(:,1), objective_KADID10K(:,2), 'type', 'Kendall');
[correlations{end,3},correlations{end,4}] = PearsonLC(objective_KADID10K(:,1),objective_KADID10K(:,2));
save(['./methods/', evaluator, '/corr_KADID10K_',evaluator,'.mat'], 'correlations');
disp(correlations);
