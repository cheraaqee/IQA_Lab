clear
clc
addpath(genpath('./datasets'));
addpath(genpath('./methods'));
%% HELP %%
% HELP: list your methods of interest in the variable 'md_list'. However, check thes
% e examples for getting an idea. (stay with me!)
% Your list will have two rows (the rows are separated with a semi-colon between the curley
% braces). The 1st row is the list of methods. Below each name,
% (i.e. the second row,) you should specify a number 1 or 2.
% 1 is for the methods that only operate on grayscale images, and 2 for methods that RGB
% images are mandatory for them.
% You specify the list of datasets in the 'ds_list'
% You're results will be saved in an .xls file that you specify its name in the var
% iable 'table_name' (without file extensions).
md_list = {'WS_HV', 'GMSD', 'MD_GD';1, 1, 1};
% md_list = {'WSC_3LHV_f','MDOGS', ...
%     'GFM','ESIM', 'SQMS', 'GSS', 'SVQI', 'cgsi', 'SIQM';
%     1,1,2,1,1,1,1,1,1 };
ds_list = {'MLIVE', 'MDID', 'MDID2013'};
table_name = 'multiple_distortion_experiments'
for md_idx = 1:size(md_list, 2)
    for ds_idx = 1:size(ds_list, 2)
        feval(['FR_', ds_list{ds_idx},'_f'], md_list{1, md_idx}, md_list{2, md_idx});
    end
end
tabler_v2_f(md_list(1,:), ds_list, table_name);
