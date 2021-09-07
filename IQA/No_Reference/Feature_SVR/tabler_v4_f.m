function latable = tabler_v4_f(algorithms, datasets, in_portions)
% This function aims to intelligently create tables for 'portion'-tests on
% 'datasets' from results obtained by the 'algorithms'

% we need the portions to be cell of strings:
portions = cell(1,1);
for idx_portion = 1:length(in_portions)
	portions{idx_portion} = num2str(in_portions(idx_portion), '%.0f');
end
%% Lets make the cube
cube_number= zeros(1,1,1)
for idx_dataset = 1:length(datasets)
	for idx_portion = 1:length(portions)
		for idx_algorithm = 1:length(algorithms)
			spear = load(['./methods/', ...
			algorithms{idx_algorithm},'/spear_', ...
			datasets{idx_dataset}, '_', ...
			num2str(portions{idx_portion}), '_', ...
			algorithms{idx_algorithm}, '.mat'])
			cube_number(idx_dataset, idx_portion, idx_algorithm) = ...
			spear.spear_median;
		end
	end
end
%% Let's make the cube_rank
cube_rank = zeros(size(cube_number))
for idx_dataset = 1:length(datasets)
	for idx_portion = 1:length(portions)
		ranks = ranker(cube_number(idx_dataset, idx_portion, :))
		cube_rank(idx_dataset, idx_portion, :) = ranks
	end
end
%% initialized table
latable = cell(1,1)
latable{1,1} = '\documentclass{article}'
latable{end+1, 1} = '\usepackage[margin=0.5cm, landscape, a3paper]{geometry}';
latable{end+1, 1} = '\usepackage{multirow}';
latable{end+1, 1} = '\usepackage[english]{babel}';
latable{end+1, 1} = '\usepackage{tabulary}';
latable{end+1, 1} = '\usepackage{colortbl}';
latable{end+1, 1} = '\usepackage{rotating}';
latable{end+1, 1} = '\usepackage{booktabs}';
latable{end+1, 1} = '\begin{document}';
latable{end+1, 1} = '\begin{table}';
latable{end+1, 1} = '\scriptsize';
latable{end+1, 1} = '\caption{Testing on Different Ratios for Train and Test}';
latable{end+1, 1} = '\label{tbl:portion}';
latable{end+1, 1} = '\begin{tabular}';
latable{end, 2} = '{';
latable{end, 3} = '||l|l||';
for col_idx = 1:length(algorithms)
    latable{end, 3+col_idx} = 'c';
end
latable{end, end+1} = '||}';
latable{end+1, 1} = '\toprule';
latable{end+1, 1} = '\toprule';
latable{end+1, 1} = '\begin{turn}{-90}\textbf{Dataset}\end{turn}&\begin{turn}{-90}\textbf{\% Train}\end{turn}';
for idx_algorithm= 1:length(algorithms)
    algorithm= algorithms{idx_algorithm};
    splitted = strsplit(algorithm, '_');
    if size(splitted, 2)>1
        md_name = strcat(splitted{1}, ['\_', splitted{2}]);
    else
        md_name = algorithm;
    end
    latable{end, idx_algorithm+1} = ['&\begin{turn}{-90}\textbf{', md_name, '}\end{turn}'];
end
latable{end, end+1} = '\\';
latable{end+1, 1} = '\midrule';
latable{end+1, 1} = '\midrule';
[row, col] = size(latable)
row = row +1
col = col +1
%% let's fill the rows
for idx_dataset = 1:length(datasets)
	latable{row, 1} = ['\multirow{',num2str(length(portions)), ...
	'}{*}{\begin{turn}{-90}', datasets{idx_dataset}, '\end{turn}}'];
	for idx_portion = 1:length(portions)
		latable{row, 2}=['&', num2str(portions{idx_portion})];
		for idx_algorithm = 1:length(algorithms)
			latable{row, idx_algorithm+2} = entry(idx_dataset,...
			idx_portion, idx_algorithm)
		end % algorithms
		latable{row, end+1} = '\\';
		row = row+1
		if idx_portion~=length(portions)
			latable{row, 1}=['\cmidrule{2-',...
			num2str(2+length(algorithms)),'}'];
			row = row+1
		end
	end % portions
	latable{row, 1} = '\midrule \midrule';
	row = row+1
end % datasets
latable{end+1,1} = '\end{tabular}';
latable{end+1,1} = '\end{table}';
latable{end+1,1} = '\end{document}';
latable{end+1, 1} = '% the generated table maybe much larger or smaller than the size of this document. Adjust the parameters below to take care of it.';
latable{end+1, 1} = '%\usepackage[left=10px,right=10px,top=10px,bottom=10px,paperwidth=8in,paperheight=20in]{geometry}';
fid = fopen('the_result_portion.tex', 'w');
for ii = 1:size(latable, 1)
	fprintf(fid, '%s', latable{ii, :});
	fprintf(fid, '\n');
end
fclose(fid)
function ranks = ranker(contestors)
	increasing_scores = sort(contestors, 'descend')
	unique_ranked = unique(increasing_scores)
    unique_ranked = sort(unique_ranked, 'descend');
	ranks = zeros(1,1)
	for contestor_idx = 1:length(contestors)
		for rank_idx = 1:length(unique_ranked)
			ranks(contestor_idx) = find(abs(unique_ranked-...
			contestors(contestor_idx))<0.0001)
		end
	end
end
function text = entry(idx_dataset, idx_portion, idx_algorithm)
if cube_rank(idx_dataset, idx_portion, idx_algorithm)==1
	text = ['&\textcolor[rgb]{1,0,0}{\textbf{',...
	num2str(round(abs(cube_number(idx_dataset, idx_portion, idx_algorithm)),4),'%.4f'),...
	'}}'];
elseif cube_rank(idx_dataset, idx_portion, idx_algorithm)==2
	text = ['&\textcolor[rgb]{0,0,1}{\textbf{',...
	num2str(round(abs(cube_number(idx_dataset, idx_portion, idx_algorithm)),4),'%.4f'),...
	'}}'];
elseif cube_rank(idx_dataset, idx_portion, idx_algorithm)==3
	text = ['&\textbf{',...
	num2str(round(abs(cube_number(idx_dataset, idx_portion, idx_algorithm)),4),'%.4f')...
	'}'];
else
	text = ['&',...
	num2str(round(abs(cube_number(idx_dataset, idx_portion, idx_algorithm)),4),'%.4f')];
end
end
end
