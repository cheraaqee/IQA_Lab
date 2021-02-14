function index = FR_QACS_f_srocc(evaluator, p1, p2, p3, p4, p5, p6)
% clear;clc;
load('./datasets/QACS/QACS_mos.mat');
cnt = 0;
num = 492;
% evaluator = 'psnr_indx'
for cnt = 1:num
% cnt
img1_name = QACS_str{cnt,1};
img2_name = QACS_str{cnt,2};
% for linux:
% !!!!!!!!!!! modifications are mandatory for Linux: the names need a './da
% tasets/' (check the Windows'es version) before them. when they are read f
% rom the mat-file and when they
% are called from a function in a parrent directory
% img1_name = strrep(img1_name, '\', '/');
% img2_name = strrep(img2_name, '\', '/');
% end for linux!
imgA = imread(['./datasets/', img1_name]);
imgB = imread(['./datasets/', img2_name]);
img1 = double(rgb2gray(imgA));
img2 = double(rgb2gray(imgB));
objective(cnt) = feval(evaluator, img1,img2, p1, p2, p3, p4, p5, p6);
end
index = corr(QACS_mos, objective', 'type', 'Spearman');
end
