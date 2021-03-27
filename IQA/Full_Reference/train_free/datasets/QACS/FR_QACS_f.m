function correlations = FR_QACS_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
load('./datasets/QACS/QACS_mos');
in_QACS = 0;
num = 492;
for in_QACS = 1:num
	in_QACS
	img1_name = QACS_str{in_QACS, 1};
	img2_name = QACS_str{in_QACS, 2};
	% for linux:
    % !!!! needs further modification for /datasets/QACS/QACS..
% 	img1_name = strrep(img1_name, '\', '/');
% 	img2_name = strrep(img2_name, '\', '/');
	% end for linux!
	imgA = imread(['./datasets/',img1_name]);
	imgB = imread(['./datasets/',img2_name]);
    
    %
    switch colorful
        case 0
            img1 = double(rgb2gray(imgA));
            img2 = double(rgb2gray(imgB));
        case 1
            img1 = double(rgb2gray(imgA));
            img2 = double(rgb2gray(imgB));
        case 2
            img1 = imgA;
            img2 = imgB;
    end

% 	img1 = double(rgb2gray(imgA));
% 	img2 = double(rgb2gray(imgB));
%     % RGB2gray (for gray, comment the 2 lines below, for RGB, comment the 2 lines above)
% %     img1 = imgA;
% %     img2 = imgB;
	objective(in_QACS) = feval(evaluator, img1, img2);
end
% the final arrays are: `QACS_mos ' and `objective' '
% QACS_mos(1:258) -> HEVC
% QACS_mos(259:end) -> SCC
objective_QACS = objective;
save(['./methods/',evaluator, '/objective_QACS_', evaluator, '.mat'], 'objective_QACS');
kinds = cell(3, 1);
kinds{1,1} = 'HEVC';
kinds{2,1} = 'SCC';
kinds{3,1} = 'ALL';

indexes = cell(1, 4);
indexes{1,1} = 'SROCC';
indexes{1,2} = 'PLCC';
indexes{1,3} = 'RMSE';
indexes{1,4} = 'KROCC';

correlations = cell(length(kinds)+1, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:end, 1) = kinds;

% HEVC indexes correlations{2, 2:5}
correlations{2,2} = corr(QACS_mos(1:258), objective(1:258)', 'type', 'Spearman');
[correlations{2,3}, correlations{2,4}] = PearsonLC(objective(1:258)', QACS_mos(1:258));
correlations{2,5} = corr(QACS_mos(1:258), objective(1:258)', 'type', 'Kendall');
% SCC indexes correlations{3, 2:5}
correlations{3,2} = corr(QACS_mos(259:end), objective(259:end)', 'type', 'Spearman');
[correlations{3,3}, correlations{3,4}] = PearsonLC(objective(259:end)', QACS_mos(259:end));
correlations{3,5} = corr(QACS_mos(259:end), objective(259:end)', 'type', 'Kendall');
% ALL indexes correlations{4, 2:5}
correlations{4,2} = corr(QACS_mos, objective', 'type', 'Spearman');
[correlations{4,3}, correlations{4,4}] = PearsonLC(objective', QACS_mos);
correlations{4,5} = corr(QACS_mos, objective', 'type', 'Kendall');
save(['./methods/', evaluator, '/corr_QACS_', evaluator, '.mat'], 'correlations');
