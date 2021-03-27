function correlations = FR_MDID2013_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
load('./datasets/MDID2013/MDID_dmos.mat');
objective_MDID13 = zeros(324, 5);%objective,mos,ref,dst,exe
objective_MDID13(:, 2) = MDID_dmos;
for in_MDID2013 = 1:324
    image_name = ['./datasets/MDID2013/MDID2013/img',num2str(in_MDID2013,'%03.f'),'.png'];
    ref_name = ['./datasets/MDID2013/MDID2013/org',num2str(ceil(in_MDID2013/27),'%03.f'),'.png'];
    image = imread(image_name);
    ref = imread(ref_name);
    %
    switch colorful
        case 0
            image = double(rgb2gray(image));
            ref = double(rgb2gray(ref));
        case 1
            image = double(rgb2gray(image));
            ref = double(rgb2gray(ref));
        case 2
            image = image;
            ref = ref;
    end
    
    begin = tic;
    objective = feval(evaluator,ref, image);
    nigeb = toc(begin);
    
    ref_number = ceil(in_MDID2013/27);
    objective_MDID13(in_MDID2013, 1) = objective;
    objective_MDID13(in_MDID2013, 3) = ref_number;
    objective_MDID13(in_MDID2013, 4) = 0;
    objective_MDID13(in_MDID2013, 5) = nigeb;
    in_MDID2013
end
save(['./methods/', evaluator, '/objective_MDID2013_',evaluator, '.mat'], 'objective_MDID13')

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

correlations{2,2}=corr(objective_MDID13(:,1), objective_MDID13(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_MDID13(:,1), objective_MDID13(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_MDID13(:,1),objective_MDID13(:,2));


save(['./methods/', evaluator, '/corr_MDID2013_',evaluator,'.mat'], 'correlations');
disp(correlations);
