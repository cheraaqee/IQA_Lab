function correlations = FR_LIVE_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
load('./datasets/LIVE/dmos_realigned.mat');
load('./datasets/LIVE/refnames_all.mat');
ref_list = importdata('./datasets/LIVE/ref_list.txt');
in_LIVE = 0;
kk = 0;

jj = 0;
ll = 0;
for ii = 1:227
    reference = imread(strcat('./datasets/LIVE/refimgs/',char(refnames_all(ii))));
    distorted = imread(strcat('./datasets/LIVE/jp2k/','img',num2str(ii),'.bmp'));
    
    switch colorful
        case 0
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 1
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 2
            distorted = distorted;
            reference = reference;
    end
    %%
    
    begin = tic;
    objective = feval(evaluator,reference, distorted);
    nigeb = toc(begin);
    objective_LIVE_982(ii, 1) = objective;
    objective_LIVE_982(ii, 2) = dmos_new(ii);
    objective_LIVE_982(ii, 3) = find(strcmp(ref_list, refnames_all{1,ii})==1);
    objective_LIVE_982(ii, 4) = 1;
    objective_LIVE_982(ii, 5) = nigeb;
    in_LIVE = ii
    jj = jj+1;
    objective_LIVE_982_jp2k(jj,:) = objective_LIVE_982(ii,:);
    
    if orgs(ii) == 0
        kk = kk+1;
        ll = ll+1;
        objective_LIVE_779(kk,:) = objective_LIVE_982(ii,:);
        objective_LIVE_779_jp2k(ll,:) = objective_LIVE_982(ii,:);
    end
end
save(['./methods/', evaluator, '/objective_LIVE_982_jp2k_',evaluator,'.mat'],'objective_LIVE_982_jp2k');
save(['./methods/', evaluator, '/objective_LIVE_779_jp2k_',evaluator,'.mat'],'objective_LIVE_779_jp2k');

jj = 0;
ll = 0;
for ii = 228:460
    reference = imread(strcat('./datasets/LIVE/refimgs/',char(refnames_all(ii))));
    distorted = imread(strcat('./datasets/LIVE/jpeg/','img',num2str(ii-227),'.bmp'));
    
    switch colorful
        case 0
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 1
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 2
            distorted = distorted;
            reference = reference;
    end
    
    begin = tic;
    objective = feval(evaluator,reference, distorted);
    nigeb = toc(begin);
    objective_LIVE_982(ii, 1) = objective;
    objective_LIVE_982(ii, 2) = dmos_new(ii);
    objective_LIVE_982(ii, 3) = find(strcmp(ref_list, refnames_all{1,ii})==1);
    objective_LIVE_982(ii, 4) = 2;
    objective_LIVE_982(ii, 5) = nigeb;
    in_LIVE = ii
    jj = jj+1;
    objective_LIVE_982_jpeg(jj,:) = objective_LIVE_982(ii,:);
    
    if orgs(ii) == 0
        kk = kk+1;
        ll = ll+1;
        objective_LIVE_779(kk,:) = objective_LIVE_982(ii,:);
        objective_LIVE_779_jpeg(ll,:) = objective_LIVE_982(ii,:);
    end
end
save(['./methods/', evaluator, '/objective_LIVE_982_jpeg_',evaluator,'.mat'],'objective_LIVE_982_jpeg');
save(['./methods/', evaluator, '/objective_LIVE_779_jpeg_',evaluator,'.mat'],'objective_LIVE_779_jpeg');

jj = 0;
ll = 0;
for ii = 461:634
    reference = imread(strcat('./datasets/LIVE/refimgs/',char(refnames_all(ii))));
    distorted = imread(strcat('./datasets/LIVE/wn/','img',num2str(ii-460),'.bmp'));
    
    switch colorful
        case 0
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 1
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 2
            distorted = distorted;
            reference = reference;
    end
    
    begin = tic;
    objective = feval(evaluator,reference, distorted);
    nigeb = toc(begin);
    objective_LIVE_982(ii, 1) = objective;
    objective_LIVE_982(ii, 2) = dmos_new(ii);
    objective_LIVE_982(ii, 3) = find(strcmp(ref_list, refnames_all{1,ii})==1);
    objective_LIVE_982(ii, 4) = 3;
    objective_LIVE_982(ii, 5) = nigeb;
    in_LIVE = ii
    jj = jj+1;
    objective_LIVE_982_wn(jj,:) = objective_LIVE_982(ii,:);
    
    if orgs(ii) == 0
        kk = kk+1;
        ll = ll+1;
        objective_LIVE_779(kk,:) = objective_LIVE_982(ii,:);
        objective_LIVE_779_wn(ll,:) = objective_LIVE_982(ii,:);
    end
end
save(['./methods/', evaluator, '/objective_LIVE_982_wn_',evaluator,'.mat'],'objective_LIVE_982_wn');
save(['./methods/', evaluator, '/objective_LIVE_779_wn_',evaluator,'.mat'],'objective_LIVE_779_wn');

jj = 0;
ll = 0;
for ii = 635:808
    reference = imread(strcat('./datasets/LIVE/refimgs/',char(refnames_all(ii))));
    distorted = imread(strcat('./datasets/LIVE/gblur/','img',num2str(ii-634),'.bmp'));
    
    switch colorful
        case 0
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 1
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 2
            distorted = distorted;
            reference = reference;
    end
    
    begin = tic;
    objective = feval(evaluator,reference, distorted);
    nigeb = toc(begin);
    objective_LIVE_982(ii, 1) = objective;
    objective_LIVE_982(ii, 2) = dmos_new(ii);
    objective_LIVE_982(ii, 3) = find(strcmp(ref_list, refnames_all{1,ii})==1);
    objective_LIVE_982(ii, 4) = 4;
    objective_LIVE_982(ii, 5) = nigeb;
    in_LIVE = ii
    jj = jj+1;
    objective_LIVE_982_gblur(jj,:) = objective_LIVE_982(ii,:);
    
    if orgs(ii) == 0
        kk = kk+1;
        ll = ll+1;
        objective_LIVE_779(kk,:) = objective_LIVE_982(ii,:);
        objective_LIVE_779_gblur(ll,:) = objective_LIVE_982(ii,:);
    end
end
save(['./methods/', evaluator, '/objective_LIVE_982_gblur_',evaluator,'.mat'],'objective_LIVE_982_gblur');
save(['./methods/', evaluator, '/objective_LIVE_779_gblur_',evaluator,'.mat'],'objective_LIVE_779_gblur');

jj = 0;
ll = 0;
for ii = 809:982
    reference = imread(strcat('./datasets/LIVE/refimgs/',char(refnames_all(ii))));
    distorted = imread(strcat('./datasets/LIVE/fastfading/','img',num2str(ii-808),'.bmp'));
    
    switch colorful
        case 0
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 1
            distorted = double(rgb2gray(distorted));
            reference = double(rgb2gray(reference));
        case 2
            distorted = distorted;
            reference = reference;
    end
    
    begin = tic;
    objective = feval(evaluator,reference, distorted);
    nigeb = toc(begin);
    objective_LIVE_982(ii, 1) = objective;
    objective_LIVE_982(ii, 2) = dmos_new(ii);
    objective_LIVE_982(ii, 3) = find(strcmp(ref_list, refnames_all{1,ii})==1);
    objective_LIVE_982(ii, 4) = 5;
    objective_LIVE_982(ii, 5) = nigeb;
    in_LIVE = ii
    jj = jj+1;
    objective_LIVE_982_fastfading(jj,:) = objective_LIVE_982(ii,:);
    
    if orgs(ii) == 0
        kk = kk+1;
        ll = ll+1;
        objective_LIVE_779(kk,:) = objective_LIVE_982(ii,:);
        objective_LIVE_779_fastfading(ll,:) = objective_LIVE_982(ii,:);
    end
end
save(['./methods/', evaluator, '/objective_LIVE_982_fastfading_',evaluator,'.mat'],'objective_LIVE_982_fastfading');
save(['./methods/', evaluator, '/objective_LIVE_779_fastfading_',evaluator,'.mat'],'objective_LIVE_779_fastfading');

save(['./methods/', evaluator, '/objective_LIVE_982_',evaluator,'.mat'],'objective_LIVE_982');
save(['./methods/', evaluator, '/objective_LIVE_779_',evaluator,'.mat'],'objective_LIVE_779');

kinds = cell(6, 1);
kinds{1,1} = 'jp2k';
kinds{2,1} = 'jpeg';
kinds{3,1} = 'wn';
kinds{4,1} = 'gblur';
kinds{5,1} = 'fastfading';
kinds{6,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KROCC';

correlations = cell(length(kinds)+1, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:end,1) = kinds;

correlations{2,2}=corr(objective_LIVE_779_jp2k(:,1), objective_LIVE_779_jp2k(:,2), 'type', 'Spearman');
correlations{3,2}=corr(objective_LIVE_779_jpeg(:,1), objective_LIVE_779_jpeg(:,2), 'type', 'Spearman');
correlations{4,2}=corr(objective_LIVE_779_wn(:,1), objective_LIVE_779_wn(:,2), 'type', 'Spearman');
correlations{5,2}=corr(objective_LIVE_779_gblur(:,1), objective_LIVE_779_gblur(:,2), 'type', 'Spearman');
correlations{6,2}=corr(objective_LIVE_779_fastfading(:,1), objective_LIVE_779_fastfading(:,2), 'type', 'Spearman');
correlations{7,2}=corr(objective_LIVE_779(:,1), objective_LIVE_779(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_LIVE_779_jp2k(:,1), objective_LIVE_779_jp2k(:,2), 'type', 'Kendall');
correlations{3,5}=corr(objective_LIVE_779_jpeg(:,1), objective_LIVE_779_jpeg(:,2), 'type', 'Kendall');
correlations{4,5}=corr(objective_LIVE_779_wn(:,1), objective_LIVE_779_wn(:,2), 'type', 'Kendall');
correlations{5,5}=corr(objective_LIVE_779_gblur(:,1), objective_LIVE_779_gblur(:,2), 'type', 'Kendall');
correlations{6,5}=corr(objective_LIVE_779_fastfading(:,1), objective_LIVE_779_fastfading(:,2), 'type', 'Kendall');
correlations{7,5}=corr(objective_LIVE_779(:,1), objective_LIVE_779(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_LIVE_779_jp2k(:,1), objective_LIVE_779_jp2k(:,2));
[correlations{3,3},correlations{3,4}] = PearsonLC(objective_LIVE_779_jpeg(:,1), objective_LIVE_779_jpeg(:,2));
[correlations{4,3},correlations{4,4}] = PearsonLC(objective_LIVE_779_wn(:,1), objective_LIVE_779_wn(:,2));
[correlations{5,3},correlations{5,4}] = PearsonLC(objective_LIVE_779_gblur(:,1), objective_LIVE_779_gblur(:,2));
[correlations{6,3},correlations{6,4}] = PearsonLC(objective_LIVE_779_fastfading(:,1), objective_LIVE_779_fastfading(:,2));
[correlations{7,3},correlations{7,4}] = PearsonLC(objective_LIVE_779(:,1), objective_LIVE_779(:,2));

save(['./methods/', evaluator, '/corr_LIVE_',evaluator,'.mat'], 'correlations');
disp(correlations);
