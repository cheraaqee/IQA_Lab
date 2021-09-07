function index = FR_SIQAD_ref_based(evaluator, p1, p2, p3, p4, p5, p6, trainees)
% addpath(genpath('E:\DATABASES\SIQAD_QoMex'));
load('./datasets/SIQAD/DMOS_SIQAD');
load('./datasets/SIQAD/subjective_SIQAD_dst_wise.mat');
load('./datasets/SIQAD/subjective_SIQAD_vec.mat');
% predicted_vec = zeros(980,1);

whole_index = 0;
subjective_vec = zeros(1,1);
for reference = trainees
    % let's extract the subjective scores for this reference
    current_ref_dmos = DMOS(:, reference);
    subjective_vec = cat(1, subjective_vec, current_ref_dmos);
    
    ref_nme = ['./datasets/SIQAD/references/cim',num2str(reference),'.bmp'];
    ref_img = imread(ref_nme);
    
    %% Instruction
    % If your method operates merely on grayscale images, uncomment the
    % following command
    %     ref_img = double(rgb2gray(ref_img));
    %% end of Instruction
    
    per_ref_index = 0;
    for distortion = 1:7
        for severity = 1:7
            whole_index = whole_index+1;
            per_ref_index = per_ref_index+1;
            
            dst_nme = ['./datasets/SIQAD/DistortedImages/cim', num2str(reference), '_', num2str(distortion), '_', num2str(severity), '.bmp'];
            dst_img = imread(dst_nme);
            
            %% Instruction
            % If your method operates merely on grayscale images, uncomment
            % the following command
            %           dst_img = double(rgb2gray(dst_img));
            %% end of Instruction
            
            prediction = feval(evaluator, ref_img, dst_img, p1, p2, p3, p4, p5, p6);
            predicted_vec(whole_index,1) = prediction;
            %  predicted_mtx(per_ref_index, reference) = prediction;
        end
    end
end
index = corr(predicted_vec, subjective_vec(2:end), 'type', 'spearman');
end
