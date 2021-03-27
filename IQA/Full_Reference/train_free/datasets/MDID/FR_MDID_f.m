function correlations = FR_MDID_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
mos = importdata('./datasets/MDID/mos.txt');
objective_MDID = zeros(1600,11);
objective_MDID(:,2) = mos;
in_MDID2016 = 0;
for refrence = 1:20
    dst_info_name = [num2str(refrence,'%02.f'),'.txt'];
    dst_info = importdata(dst_info_name);
    for distorted = 1:80
        in_MDID2016 = in_MDID2016 +1
        ref_img_name = ['./datasets/MDID/reference_images/img',num2str(refrence,'%02.f'),'.bmp'];
        dst_img_name = ['./datasets/MDID/distortion_images/img',num2str(refrence,'%02.f'),'_',num2str(distorted,'%02.f'),'.bmp'];
        ref_img = imread(ref_img_name);
        dst_img = imread(dst_img_name);
        
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
        
        objective_MDID(in_MDID2016,1) = objective;
        objective_MDID(in_MDID2016,3) = refrence;
        objective_MDID(in_MDID2016,4) = 0;
        objective_MDID(in_MDID2016,5) = nigeb;
        objective_MDID(in_MDID2016,6:11) = dst_info(distorted,:);
    end
end

save(['./methods/', evaluator, '/objective_MDID_',evaluator, '.mat'], 'objective_MDID')

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

correlations{2,2}=corr(objective_MDID(:,1), objective_MDID(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_MDID(:,1), objective_MDID(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_MDID(:,1),objective_MDID(:,2));


save(['./methods/', evaluator, '/corr_MDID_',evaluator,'.mat'], 'correlations');
disp(correlations);
