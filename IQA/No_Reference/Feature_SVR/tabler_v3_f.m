function tabler_v3_f(md_list,ds_list)
%% creating LaTeX table
latable = cell(1,1);
latable = initiate_table(latable);
%% loading DATASETs' information
load('portfolio.mat');
ds_looper_final = 1;
for ds_looper = 1:length(ds_list)
    current_ds = ds_list{ds_looper};
    for ii = 1:length(portfolio)
        if strcmp(portfolio(ii).name, current_ds)
            ds_profile(ds_looper_final) = portfolio(ii);
            ds_looper_final = ds_looper_final+1;
        end
    end
end
%% initializing the table
index_list = {'SROCC', 'PLCC', 'RMSE', 'KROCC'};
latable{end+1, 1} = '\begin{table}';
latable{end+1, 1} = '\scriptsize';
latable{end+1, 1} = '\caption{Entire Results}';
latable{end+1, 1} = '\label{tbl:whole}';
latable{end+1, 1} = '\begin{tabular}';
latable{end, 2} = '{';
latable{end, 3} = '||l|l|l||';
for col_idx = 1:length(md_list)
    latable{end, 3+col_idx} = 'c';
end
latable{end, end+1} = '||}';
latable{end+1, 1} = '\toprule';
latable{end+1, 1} = '\toprule';
latable{end+1, 1} = '\textbf{Dataset for Train}&\textbf{Dataset for Test}&\textbf{Index}';
for md_idx = 1:length(md_list)
    current_md = md_list{md_idx};
    splitted = strsplit(current_md, '_');
    if size(splitted, 2)>1
        md_name = strcat(splitted{1}, ['\_', splitted{2}]);
    else
        md_name = current_md;
    end
    latable{end, md_idx+1} = ['&\begin{turn}{-90}\textbf{', md_name, '}\end{turn}'];
end
latable{end, end+1} = '\\';
latable{end+1, 1} = '\midrule';
latable{end+1, 1} = '\midrule';

%% filling the rows
row = size(latable, 1)+1;
for dataset_train_idx= 1:length(ds_profile)
	dataset_train = ds_profile(dataset_train_idx).name;
	for dataset_test_idx = 1:length(ds_profile)
		dataset_test = ds_profile(dataset_test_idx).name;
		if ~strcmp(dataset_train, dataset_test)
			latable{row, 1} = ['\multirow{', num2str(length(index_list)), '}{*}{', dataset_train,'}']; 
			latable{row, 2} = ['&\multirow{', num2str(length(index_list)), '}{*}{', dataset_test,'}'];
			for index_idx =1:length(index_list)
				if index_idx ==1
					latable{row, 3} = ['&', index_list{index_idx}];
				else
					latable{row, 3} = ['&&', index_list{index_idx}];
				end
				for md_idx = 1:length(md_list) 
					load(['./methods/',md_list{md_idx},'/corr_cross_', dataset_train, '_', dataset_test, '_', md_list{md_idx}, '.mat'])
					col_of_index = find(strcmp(correlations(1,:),index_list{index_idx}));
					latable{row, md_idx+3} = ['&', num2str(round(abs(correlations{2, col_of_index}), 4), '%.4f')];
					if md_idx == length(md_list)
						latable{row, end+1} = '\\';
					end
				end % for the methods
				row = row+1;
				if index_idx~= length(index_list)
					latable{row, 1} = ['\cmidrule{3-',num2str(length(md_list)+3), '}'];
					row = row+1;
				end
				if index_idx == length(index_list)
					latable{row, 1} = '\midrule';
					row = row+1;
				end
			end % for indexes (SROCC, PLCC, ...) 
		end % if dataset_train != dataset_test
	end % for dataset_test
end % for datset_train
%% averaging
%%
latable{end+1,1} = '\end{tabular}';
latable{end+1,1} = '\end{table}';
latable{end+1,1} = '\end{document}';
latable{end+1, 1} = '% the generated table maybe much larger or smaller than the size of this document. Adjust the parameters below to take care of it.';
latable{end+1, 1} = '%\usepackage[left=10px,right=10px,top=10px,bottom=10px,paperwidth=8in,paperheight=20in]{geometry}';
fid = fopen('the_result_cross.tex', 'w');
for ii = 1:size(latable, 1)
	fprintf(fid, '%s', latable{ii, :});
	fprintf(fid, '\n');
end
fclose(fid)
end
function outputcell = initiate_table(latable)
% insert the common LaTeX commands between the tables...
latable{1,1} = '\documentclass{article}';
latable{end+1, 1} = '\usepackage[margin=0.5cm, landscape, a3paper]{geometry}';
latable{end+1, 1} = '\usepackage{multirow}';
latable{end+1, 1} = '\usepackage[english]{babel}';
latable{end+1, 1} = '\usepackage{tabulary}';
latable{end+1, 1} = '\usepackage{colortbl}';
latable{end+1, 1} = '\usepackage{rotating}';
latable{end+1, 1} = '\usepackage{booktabs}';
latable{end+1, 1} = '\begin{document}';
outputcell = latable;
end
