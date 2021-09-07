function correlations = FR_QADS_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
moses = importdata('./datasets/QADS/QADS/mos_with_names.txt');
objective_QADS = zeros(980,3);
for ii = 1:980
    ii
    mos_data = moses{ii};
    mos = mos_data(1:7);
    mos = str2double(mos);
    dst_name = mos_data(10:end);
    ref_name = mos_data(10:14);
    ref_name = [ref_name, '.bmp'];
    ref_path = ['./datasets/QADS/QADS/source_images/',ref_name];
    dst_path = ['./datasets/QADS/QADS/super-resolved_images/', dst_name];
    ref_img = imread(ref_path);
    dst_img = imread(dst_path);
    
    %
    switch colorful
        case 0
            dst_img = double(rgb2gray(dst_img));
            ref_img = double(rgb2gray(ref_img));
        case 1
            dst_img = double(rgb2gray(dst_img));
            ref_img = double(rgb2gray(ref_img));
        case 2
            dst_img = dst_img;
            ref_img = ref_img;
    end
    begin = tic;
    objective = feval(evaluator, ref_img, dst_img);
    nigeb = toc(begin);
    
    objective_QADS(ii,1) = objective;
    objective_QADS(ii, 2) = mos;
    objective_QADS(ii,3) = nigeb;
    
end

save(['./methods/', evaluator, '/objective_QADS_',evaluator, '.mat'], 'objective_QADS')

kinds = cell(1, 1);
kinds{1,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KROCC';

correlations = cell(2, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2,1) = kinds;

correlations{2,2}=corr(objective_QADS(:,1), objective_QADS(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_QADS(:,1), objective_QADS(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_QADS(:,1),objective_QADS(:,2));


save(['./methods/', evaluator, '/corr_QADS_',evaluator,'.mat'], 'correlations');
disp(correlations);
