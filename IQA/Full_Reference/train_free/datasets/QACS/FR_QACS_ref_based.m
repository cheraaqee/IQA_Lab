function index = FR_QACS_ref_based(evaluator, p1, p2, p3, p4, p5, p6, trainees)
clc;
load('./datasets/QACS/QACS_mos.mat');
cnt = 0;
num = 492;
hit = 0;
for cnt = 1:num
    if ismember(QACS_ind(cnt, 1), trainees)
        hit = hit+1;
        img1_name = QACS_str{cnt,1};
        img2_name = QACS_str{cnt,2};
        % for linux:
        % !!!!!!!!!!! modifications are mandatory for Linux: the names need a './da
        % tasets/' (check the Windows'es version) before them. when they are read f
        % rom the mat-file and when they
        % are called from a function in a parrent directory
        img1_name = strrep(img1_name, '\', '/');
        img2_name = strrep(img2_name, '\', '/');
        % end for linux!
        imgA = imread(['./datasets/', img1_name]);
        imgB = imread(['./datasets/', img2_name]);
        img1 = double(rgb2gray(imgA));
        img2 = double(rgb2gray(imgB));
        objective(hit) = feval(evaluator, img1,img2, p1, p2, p3, p4, p5, p6);
        subjective(hit) = QACS_mos(cnt);
    end
end
index = corr(subjective', objective', 'type', 'Spearman');
end
