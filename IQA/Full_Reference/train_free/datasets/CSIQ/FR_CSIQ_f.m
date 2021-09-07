function correlations = FR_CSIQ_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])

distortion_folders_list = importdata('./datasets/CSIQ/dst_imgs/Copy_of_distortion_folders_list.txt');
distortion_columns_list = importdata('./datasets/CSIQ/dst_imgs/distortion_folders_list.txt');
distortion_columns_list{6} = 'jpeg 2000';
nr_folders = length(distortion_folders_list);
ref_images_list = importdata('./datasets/CSIQ/src_imgs/ref_images_list.txt');
nr_refs = length(ref_images_list);
[num, txt, raw] = xlsread('./datasets/CSIQ/csiq.beta.xlsx','all_by_distortion');
[satr, sotun] = size(raw);
raw = raw(2:satr,1:9);
objective_CSIQ = zeros((satr-1), 5);%obj,sub,ref,dst,exe
dst_type = 2;
image_ref = 3;
indeX = 0;
in_CSIQ = 0;
for aa = 1:nr_folders
    crnt_folder = distortion_folders_list{aa};
    crnt_column = distortion_columns_list{aa};
    
    
    for bb = 1:nr_refs
        crnt_ref = strtok(ref_images_list{bb}, '.');
        row = 1;
        level = 0;
        while row < satr
            if strcmp(raw{row, dst_type}, crnt_column) && strcmp(num2str(raw{row, image_ref}),crnt_ref)
                level = level + 1;
                image_name = strcat('./datasets/CSIQ/dst_imgs/',crnt_folder,'/',crnt_ref,'.',crnt_folder,'.',num2str(level),'.png');
                ref_name= ['./datasets/CSIQ/src_imgs/',num2str(raw{row,3}),'.png'];
                image = imread(image_name);
                ref_image = imread(ref_name);

                %% if your evaluator doesn't accept RGB images, uncomment the following two commands
                switch colorful
                    case 0
                        image = double(rgb2gray(image));
                        ref_image = double(rgb2gray(ref_image));
                    case 1
                        image = double(rgb2gray(image));
                        ref_image = double(rgb2gray(ref_image));
                    case 2
                        image = image;
                        ref_image = ref_image;
                end
                %%
                dmos = raw{row, 9};
                indeX = indeX + 1;
                begin = tic;
                objective = feval(evaluator,ref_image,image);
                nigeb = toc(begin);
                objective_CSIQ(row,1) = objective;
                objective_CSIQ(row,2) = dmos;
                objective_CSIQ(row,3) = bb;
                objective_CSIQ(row,4) = aa;
                objective_CSIQ(row,5) = nigeb;
                in_CSIQ = in_CSIQ+1
            end
            row = row+1;
        end
    end
end
save(['./methods/', evaluator, '/objective_CSIQ_',evaluator, '.mat'], 'objective_CSIQ')

awgn = 0;
blur = 0;
contrast = 0;
fnoise = 0;
jpeg = 0;
jpeg2000 = 0;

for aa = 1:866
    switch objective_CSIQ(aa,4)
        case 1
            awgn = awgn+1;
            objective_CSIQ_awgn(awgn,:) = objective_CSIQ(aa,:);
        case 2
            blur = blur+1;
            objective_CSIQ_blur(blur,:) = objective_CSIQ(aa,:);
        case 3
            contrast = contrast+1;
            objective_CSIQ_contrast(contrast,:) = objective_CSIQ(aa,:);
        case 4
            fnoise  = fnoise+1;
            objective_CSIQ_fnoise(fnoise,:) = objective_CSIQ(aa,:);
        case 5
            jpeg = jpeg+1;
            objective_CSIQ_jpeg(jpeg, :) = objective_CSIQ(aa,:);
        case 6
            jpeg2000 = jpeg2000+1;
            objective_CSIQ_jpeg2000(jpeg2000,:) = objective_CSIQ(aa,:);
    end
end

save(['./methods/', evaluator, '/objective_CSIQ_awgn_',evaluator, '.mat'], 'objective_CSIQ_awgn')
save(['./methods/', evaluator, '/objective_CSIQ_blur_',evaluator, '.mat'], 'objective_CSIQ_blur')
save(['./methods/', evaluator, '/objective_CSIQ_contrast_',evaluator, '.mat'], 'objective_CSIQ_contrast')
save(['./methods/', evaluator, '/objective_CSIQ_fnoise_',evaluator, '.mat'], 'objective_CSIQ_fnoise')
save(['./methods/', evaluator, '/objective_CSIQ_jpeg_',evaluator, '.mat'], 'objective_CSIQ_jpeg')
save(['./methods/', evaluator, '/objective_CSIQ_jpeg2000_',evaluator, '.mat'], 'objective_CSIQ_jpeg2000')

kinds = cell(7, 1);
kinds{1,1} = 'awgn';
kinds{2,1} = 'blur';
kinds{3,1} = 'contrast';
kinds{4,1} = 'fnoise';
kinds{5,1} = 'jpeg';
kinds{6,1} = 'jpeg2000';
kinds{7,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KROCC';

correlations = cell(length(kinds)+1, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:end,1) = kinds;

correlations{2,2}=corr(objective_CSIQ_awgn(:,1), objective_CSIQ_awgn(:,2), 'type', 'Spearman');
correlations{3,2}=corr(objective_CSIQ_blur(:,1), objective_CSIQ_blur(:,2), 'type', 'Spearman');
correlations{4,2}=corr(objective_CSIQ_contrast(:,1), objective_CSIQ_contrast(:,2), 'type', 'Spearman');
correlations{5,2}=corr(objective_CSIQ_fnoise(:,1), objective_CSIQ_fnoise(:,2), 'type', 'Spearman');
correlations{6,2}=corr(objective_CSIQ_jpeg(:,1), objective_CSIQ_jpeg(:,2), 'type', 'Spearman');
correlations{7,2}=corr(objective_CSIQ_jpeg2000(:,1), objective_CSIQ_jpeg2000(:,2), 'type', 'Spearman');
correlations{8,2}=corr(objective_CSIQ(:,1), objective_CSIQ(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_CSIQ_awgn(:,1), objective_CSIQ_awgn(:,2), 'type', 'Kendall');
correlations{3,5}=corr(objective_CSIQ_blur(:,1), objective_CSIQ_blur(:,2), 'type', 'Kendall');
correlations{4,5}=corr(objective_CSIQ_contrast(:,1), objective_CSIQ_contrast(:,2), 'type', 'Kendall');
correlations{5,5}=corr(objective_CSIQ_fnoise(:,1), objective_CSIQ_fnoise(:,2), 'type', 'Kendall');
correlations{6,5}=corr(objective_CSIQ_jpeg(:,1), objective_CSIQ_jpeg(:,2), 'type', 'Kendall');
correlations{7,5}=corr(objective_CSIQ_jpeg2000(:,1), objective_CSIQ_jpeg2000(:,2), 'type', 'Kendall');
correlations{8,5}=corr(objective_CSIQ(:,1), objective_CSIQ(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_CSIQ_awgn(:,1),objective_CSIQ_awgn(:,2));
[correlations{3,3},correlations{3,4}] = PearsonLC(objective_CSIQ_blur(:,1),objective_CSIQ_blur(:,2));
[correlations{4,3},correlations{4,4}] = PearsonLC(objective_CSIQ_contrast(:,1),objective_CSIQ_contrast(:,2));
[correlations{5,3},correlations{5,4}] = PearsonLC(objective_CSIQ_fnoise(:,1),objective_CSIQ_fnoise(:,2));
[correlations{6,3},correlations{6,4}] = PearsonLC(objective_CSIQ_jpeg(:,1),objective_CSIQ_jpeg(:,2));
[correlations{7,3},correlations{7,4}] = PearsonLC(objective_CSIQ_jpeg2000(:,1),objective_CSIQ_jpeg2000(:,2));
[correlations{8,3},correlations{8,4}] = PearsonLC(objective_CSIQ(:,1),objective_CSIQ(:,2));


save(['./methods/', evaluator, '/corr_CSIQ_',evaluator,'.mat'], 'correlations');
disp(correlations);
