function correlations = FR_SIQAD_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
% addpath(genpath('E:\DATABASES\SIQAD_QoMex'));
load('./datasets/SIQAD/DMOS_SIQAD');
load('./datasets/SIQAD/subjective_SIQAD_dst_wise.mat');
load('./datasets/SIQAD/subjective_SIQAD_vec.mat');
predicted_vec = zeros(980,2);
predicted_mtx = zeros(49,20);

kinds = cell(8, 1);
kinds{1,1} = 'GN';
kinds{2,1} = 'GB';
kinds{3,1} = 'MB';
kinds{4,1} = 'CC';
kinds{5,1} = 'JPEG';
kinds{6,1} = 'JPTK';
kinds{7,1} = 'LSC';
kinds{8,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KROCC';

correlations = cell(length(kinds)+1, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:end,1) = kinds;

in_SIQAD = 0;
for reference = 1:20
    ref_nme = ['./datasets/SIQAD/references/cim',num2str(reference),'.bmp'];
    ref_img = imread(ref_nme);
    
    %
    switch colorful
        case 0
            %             dst_img = double(rgb2gray(dst_img));
            ref_img = double(rgb2gray(ref_img));
        case 1
            %             dst_img = double(rgb2gray(dst_img));
            ref_img = double(rgb2gray(ref_img));
        case 2
            %             dst_img = dst_img;
            ref_img = ref_img;
    end
    
    per_ref_index = 0;
    for distortion = 1:7
        for severity = 1:7
            in_SIQAD = in_SIQAD+1
            per_ref_index = per_ref_index+1;
            
            dst_nme = ['./datasets/SIQAD/DistortedImages/cim', num2str(reference), '_', num2str(distortion), '_', num2str(severity), '.bmp'];
            dst_img = imread(dst_nme);
            
            %
            switch colorful
                case 0
                    dst_img = double(rgb2gray(dst_img));
%                     ref_img = double(rgb2gray(ref_img));
                case 1
                    dst_img = double(rgb2gray(dst_img));
%                     ref_img = double(rgb2gray(ref_img));
                case 2
                    dst_img = dst_img;
%                     ref_img = ref_img;
            end
            
            begin = tic;
            prediction = feval(evaluator, ref_img, dst_img);
            nigeb = toc(begin);
            predicted_vec(in_SIQAD,1) = prediction;
            predicted_vec(in_SIQAD,2) = nigeb;
            predicted_mtx(per_ref_index, reference) = prediction;
        end
    end
end
save(['./methods/',evaluator,'/objective_SIQAD_vec_',evaluator,'.mat'], 'predicted_vec');
save(['./methods/',evaluator,'/objective_SIQAD_mtx_',evaluator,'.mat'], 'predicted_mtx');

predicted_dst_wise = zeros(140, 7);
per_dst_index = 0;
for dst = 1:7:49
    per_dst_index = 0;
    for ref = 1:20
        for sev = 1:7
            per_dst_index = per_dst_index +1;
            predicted_dst_wise(per_dst_index,ceil(dst/7))= predicted_mtx(dst+sev-1,ref);
        end
    end
end

save(['./methods/',evaluator,'/objective_SIQAD_dst_wise_',evaluator,'.mat'], 'predicted_dst_wise');

for dst = 2:8
    correlations{dst, 2} = corr(predicted_dst_wise(:,dst-1), subjective_dst_wise(:,dst-1),'type','spearman');
    correlations{dst, 5} = corr(predicted_dst_wise(:,dst-1), subjective_dst_wise(:,dst-1),'type','kendall');
end
correlations{9,2} = corr(predicted_vec(:,1), subjective_vec, 'type', 'spearman');
correlations{9,5} = corr(predicted_vec(:,1), subjective_vec, 'type', 'kendall');

for dst = 2:8
    [pearson, rmsquare] = PearsonLC(predicted_dst_wise(:,dst-1), subjective_dst_wise(:,dst-1));
    correlations{dst, 3} = pearson;
    correlations{dst, 4} = rmsquare;
end
[pearson, rmsquare] = PearsonLC(predicted_vec(:,1), subjective_vec);
correlations{9,3} = pearson;
correlations{9,4} = rmsquare;
save(['./methods/', evaluator, '/corr_SIQAD_',evaluator,'.mat'], 'correlations');
disp(correlations)
% xlswrite(['./', evaluator, 'corr_SIQAD_',evaluator,'.xls'], correlations);
end
