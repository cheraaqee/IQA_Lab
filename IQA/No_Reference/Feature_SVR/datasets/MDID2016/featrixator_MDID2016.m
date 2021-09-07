function featrix_MDID2016 = featrixator_MDID2016(feactorator, state)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
%% Extract MDID2016 features (generating the 'featrix'-"FEAtures maTRIX"
prey = imread('./datasets/MDID2016/reference_images/img01.bmp');
if ~colorful
    prey = double(rgb2gray(prey));
end
feactor_length = length(feval(feactorator, prey));
mos = importdata('./datasets/MDID2016/mos.txt');
featrix_MDID2016 = zeros(1600,feactor_length+10);%feactor,mos,ref_number,0,exe_time,dst_info
featrix_MDID2016(:,feactor_length+1) = mos;
counter = 0;
for refrence = 1:20
    dst_info_name = [num2str(refrence,'%02.f'),'.txt'];
    dst_info = importdata(dst_info_name);
    for distorted = 1:80
        counter = counter +1
        dst_img_name = ['./datasets/MDID2016/distortion_images/img',num2str(refrence,'%02.f'),'_',num2str(distorted,'%02.f'),'.bmp'];
        dst_img = imread(dst_img_name);
	if ~colorful
		dst_img = double(rgb2gray(dst_img));
	end
        begin = tic;
        feactor = feval(feactorator, dst_img);
        nigeb = toc(begin);
        
        featrix_MDID2016(counter,1:feactor_length) = feactor;
        featrix_MDID2016(counter,feactor_length+2) = refrence;
        featrix_MDID2016(counter,feactor_length+3) = 0;
        featrix_MDID2016(counter,feactor_length+4) = nigeb;
        featrix_MDID2016(counter,feactor_length+5:feactor_length+10) = dst_info(distorted,:);
    end
end

save(['./methods/', feactorator, '/FMX_MDID2016_',feactorator, '.mat'], 'featrix_MDID2016')
