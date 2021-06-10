function featrix_MDID2013 = featrixator_MDID2013(feactorator, state)
%featrixator_MDID2013 accepts the name of a feactorator's .m-file and generates
%the featrix for MDID2013 for that method.
%	Detailed explanation of the featrixator_MDID2013

switch nargin
	case 1
		colorful = 0;
	case 2
		colorful = state;
end
%% Extract MDID2013 features (generating the 'featrix'- "FEAtures maTRIX"
prey = imread('./datasets/MDID2013/MDID2013/img001.png');
if ~colorful
    prey = double(rgb2gray(prey));
end
feactor_length = length(feval(feactorator, prey));
load('./datasets/MDID2013/MDID_dmos.mat');
featrix_MDID2013 = zeros(324, feactor_length+4);%feactor,mos,ref,dst,exe
featrix_MDID2013(:, feactor_length+1) = MDID_dmos;
for aa = 1:324
    image_name = ['./datasets/MDID2013/MDID2013/img',num2str(aa,'%03.f'),'.png'];
    image = imread(image_name);
    if ~colorful
	    image = double(rgb2gray(image));
    end
    begin = tic;
    feactor = feval(feactorator, image);
    nigeb = toc(begin);
    ref_number = ceil(aa/27);
    featrix_MDID2013(aa, 1:feactor_length) = feactor;
    featrix_MDID2013(aa, feactor_length+2) = ref_number;
    featrix_MDID2013(aa, feactor_length+3) = 0;
    featrix_MDID2013(aa, feactor_length+4) = nigeb;
    aa
end
save(['./methods/', feactorator,'/FMX_MDID2013_',feactorator, '.mat'], 'featrix_MDID2013')
