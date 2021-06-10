%% What is the name of your evaluator? place it here:
evaluator = 'drn_mag_blk';
%%
 
load('Imagelists.mat');
load('Scores.mat');

objective_MLIVE_N = zeros(225,6);%objective,mos,ref,exe_time,blur,jpeg
objective_MLIVE_N(:,2) = DMOSscores';
for aa = 1:225
    impath = strcat('./blurnoise/',distimgs{aa});
    ref_name = strcat(strtok(distimgs{aa}, '_'),'.bmp');
    ref_path = ['./blurnoise/',ref_name];
    image = imread(impath);
    ref_img = imread(ref_path);
    
    %% if your evaluator doesn't operate on RGB images, uncomment the following commands:
    image = double(rgb2gray(image));
    ref_img = double(rgb2gray(ref_img));
    %%
    
    ref_number = 1;
    while ~strcmp(refimgs(ref_number), strcat(strtok(distimgs(aa), '_'),'.bmp'))
        ref_number = ref_number+1;
    end
    
    begin = tic;
    objective = feval(evaluator,ref_img,image, 180);
    nigeb = toc(begin);
    objective_MLIVE_N(aa,1) = objective;
    objective_MLIVE_N(aa,3) = ref_number;
    objective_MLIVE_N(aa,4) = nigeb;
    objective_MLIVE_N(aa,5:6) = distimgdistlevels(aa,:);
    aa
end
save(['objective_MLIVE_N_',evaluator,'.mat'],'objective_MLIVE_N');