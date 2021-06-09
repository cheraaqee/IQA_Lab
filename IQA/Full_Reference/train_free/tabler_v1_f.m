function latable = tabler_v1_f(md_list,ds_list, table_name)
% md_list = {'psnr_index', 'ssim', 'GMSD', 'SSVD', 'HaarPSI', 'SIQM','WS_3HV', 'GFM', 'MDOGS', 'SQMS', 'SVQI'};
% % ds_list = {'SIQAD', 'SCID_1600', 'QACS'};
% ds_list = {'SCID_1600'};
% table_name = 'experiment_1';
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
table = cell(1,3);
table{1,1} = 'Dataset';
table{1,2} = 'Index';
table{1,3} = 'Distortion';
table(4:length(md_list)+3) = md_list;
% LaTeX
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
latable{end+1, 1} = '\begin{turn}{-90}\textbf{Dataset}\end{turn}&\begin{turn}{-90}\textbf{Index}\end{turn}&\begin{turn}{-90}\textbf{Distortion}\end{turn}';
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
row = 2;
row_latable = size(latable, 1)+1;
for ds_idx = 1:length(ds_profile)
    dst_list = ds_profile(ds_idx).dsts;
    first_num = length(index_list)*length(dst_list);
    % if length(dst_list)>4
    %         second_num = first_num*2;
    % else
    %         second_num = first_num;
    % end
    dd_name = ds_profile(ds_idx).name;
    splitted = strsplit(dd_name, '_');
    if size(splitted, 2)>1
        dd_name = strcat(splitted{1}, ['\_', splitted{2}]);
    end
    second_num = first_num*2;
    % latable{row_latable, 1} = ['\multirow{',num2str(first_num), '}[',...
    % num2str(second_num),']{*}{\begin{turn}{-90}',dd_name,...
    % '\end{turn}}'];
    latable{row_latable, 1} = ['\multirow{',num2str(first_num), '}',...
        '{*}{\begin{turn}{-90}',dd_name,...
        '\end{turn}}'];
    
    for index_idx = 1:length(index_list)
        first_num = length(dst_list);
        if first_num > 4
            second_num = first_num*2;
        else
            second_num = first_num;
        end
        % latable{row_latable, 2} = ['&\multirow{',num2str(first_num),'}[',...
        % num2str(second_num), ']{*}{\begin{turn}{-90}',index_list{index_idx},...
        % '\end{turn}}'];
        latable{row_latable, 2} = ['&\multirow{',num2str(first_num),'}',...
            '{*}{\begin{turn}{-90}',index_list{index_idx},...
            '\end{turn}}'];
        
        for dst_idx = 1:length(dst_list)
            table{row, 1} = ds_profile(ds_idx).name;
            table{row, 2} = index_list{index_idx};
            table{row, 3} = dst_list{dst_idx};
            if dst_idx ==1
                latable{row_latable, 3} = ['&', dst_list{dst_idx}];
            else
                latable{row_latable, 3} = ['&&', dst_list{dst_idx}];
            end
            for md_idx = 1:length(md_list)
                load(['./methods/',md_list{md_idx},'/corr_',...
                    ds_profile(ds_idx).name,'_',md_list{md_idx},'.mat']);
                row_of_dst = find(strcmp(correlations(:,1),...
                    dst_list{dst_idx}));
                col_of_index = find(strcmp(correlations(1,:),...
                    index_list{index_idx}));
                table{row, 3+md_idx} = abs(correlations{row_of_dst,...
                    col_of_index});
                latable{row_latable, md_idx+3} = ['&', num2str(round(abs(...
                    correlations{row_of_dst, col_of_index}), 4), '%.4f')];
            end
            row = row+1;
            latable{row_latable, end} = '\\';
            row_latable = row_latable+1;
            if dst_idx~=length(dst_list)
                latable{row_latable, 1} = ['\cmidrule{3-',...
                    num2str(3+length(md_list)),'}'];
                row_latable = row_latable+1;
            end
        end
        if index_idx~=length(index_list)
            latable{row_latable, 1} = ['\cmidrule{2-', ...
                num2str(3+length(md_list)),'}'];
            latable{row_latable, 2} = ['\cmidrule{2-', ...
                num2str(3+length(md_list)),'}'];
            row_latable = row_latable+1;
        end
    end
    latable{row_latable, 1} = '\midrule';
    latable{row_latable, 2} = '\midrule';
    row_latable = row_latable+1;
end
no_rows_1 = size(latable, 1);
end_raw = row-1;
%% averaging
averagable_indexes = [1,2,4];
latable{end+1, 1} = ['\multirow{', num2str(length(averagable_indexes)), '}{*}{\begin{turn}{-90}AVERAGE\end{turn}}'];
averagable_indexes = index_list(averagable_indexes);
no_rows_current = size(latable, 1);
for index_idx = 1:length(averagable_indexes)
    the_index = averagable_indexes(index_idx);
    table{row, 1} = 'Average';
    table{row, 2} = the_index;
    table{row, 3} = the_index;
    latable{no_rows_current, 2} = ['&\multicolumn{2}{c||}{', the_index{1,1}, '}'];
    for md_idx = 1:length(md_list)
        sumw = 0;
        weight = 0;
        for ds_idx = 1:length(ds_profile)
            the_rows_of_db = find(strcmp(table(:,1),ds_profile(ds_idx).name)...
                & strcmp(table(:,2), the_index) &...
                strcmp(table(:,3), 'ALL'));
            %             the_rows_of_index = find(strcmp(table(the_rows_of_db,2), the_index));
            %             the_row_of_whole = find(strcmp(table(the_rows_of_index,3), 'ALL'));
            whole_method = table{the_rows_of_db, 3+md_idx};
            sumw = sumw+whole_method*ds_profile(ds_idx).nimg;
            weight = weight+ds_profile(ds_idx).nimg;
        end
        table{row, 3+md_idx} = sumw/weight;
        latable{no_rows_current, 3+md_idx} = ['&', num2str(round(abs(sumw/weight), 4), '%.4f')];
    end
    row = row+1;
    latable{no_rows_current+1, 1} = '\\';
    if index_idx ~= length(averagable_indexes)
        latable{no_rows_current+1, 2} = [' \cmidrule{2-', num2str(length(md_list)+3), '}'];
    else
        latable{no_rows_current+1, 2} = ' \midrule \midrule';
    end
    no_rows_current = no_rows_current+2;
end
end_average = row-1;
end_average_latable = size(latable, 1);
%% the tops
for ii = 2:row-1
    kk = 0;
    for jj = 4:3+length(md_list)
        kk = kk+1;
        the_row(kk) = table{ii, jj};
    end
    if strcmp(table{ii,2}, 'RMSE')
        the_row_sorted = sort(the_row);
    else
        the_row_sorted = sort(the_row, 'descend');
    end
    kk = 1;
    while kk<=length(the_row)
        the_winner = find(the_row-the_row_sorted(kk)==0);
        for hh = 1:length(the_winner)
            winners_idx(kk) = the_winner(hh);
            kk = kk+1;
        end
    end
    winners = md_list(winners_idx);
    table(ii, 4+length(md_list):3+2*length(md_list)) = winners;
end
latable{end+1, 1} = ['\multirow{', num2str(length(index_list)), '}{*}{\begin{turn}{-90}HIT-COUNT\end{turn}}'];
no_rows_current = size(latable, 1);
%% hit-count
for index_idx = 1:4
    table{row, 1} = 'Hit-Count';
    table{row, 2} = index_list{index_idx};
    table{row, 3} = index_list{index_idx};
    current_index = index_list{index_idx};
    latable{no_rows_current, 2} = ['&\multicolumn{2}{c||}{', current_index, '}'];
    for md_idx = 1:length(md_list)
        current_method = md_list{md_idx};
        count = 0;
        jj = 0;
        for ii = 2:end_raw
            jj = jj+2;
            if strcmp(table{ii, 2}, current_index)
                if strcmp(current_method, table{ii, 4+length(md_list)})
                    count = count+1;
                    value = latable{18+jj, md_idx+3};
                    ifitscell = fix_value(value, 'red');
                    latable{18+jj, md_idx+3} = fix_value(value, 'red');
                elseif strcmp(current_method, table{ii, 5+length(md_list)})
                    count = count+1;
                    value = latable{18+jj, md_idx+3};
                    latable{18+jj, md_idx+3} = fix_value(value, 'blue');
                elseif strcmp(current_method, table{ii, 6+length(md_list)})
                    count = count+1;
                    value = latable{18+jj, md_idx+3};
                    latable{18+jj, md_idx+3} = fix_value(value, 'black');
                end
            end
        end
        table{row, md_idx+3} = count;
        latable{no_rows_current, md_idx+3} = ['&', num2str(count)];
    end
    if index_idx~=4
        latable{no_rows_current+1, end+1} = '\\';
        latable{no_rows_current+1, end+1} = [' \cmidrule{2-', num2str(length(md_list)+3), '}'];
    else
        latable{no_rows_current+1, end+1} = '\\';
        latable{no_rows_current+1, end+1} = ' \midrule \midrule';
    end
    row = row+1;
    no_rows_current = no_rows_current+2;
end

for ii = end_average+1:row-1
    kk = 0;
    for jj = 4:3+length(md_list)
        kk = kk+1;
        the_row(kk) = table{ii, jj};
    end
    the_row_sorted = sort(the_row, 'descend');
    
    kk = 1;
    while kk<=length(the_row)
        the_winner = find(the_row-the_row_sorted(kk)==0);
        for hh = 1:length(the_winner)
            winners_idx(kk) = the_winner(hh);
            kk = kk+1;
        end
    end
    winners = md_list(winners_idx);
    table(ii, 4+length(md_list):3+2*length(md_list)) = winners;
end
begin_average = end_raw+1;
end_hitcount = size(table, 1);
% begin_average in latable = no_rows_1
% end_hitCount in latable = size(latable, 1);
row_pointer_in_latable = no_rows_1+1;
%% Ranking Average and Hit-Count
for row_pointer_in_table = begin_average:end_hitcount
    for md_idx = 1:length(md_list)
        current_method = md_list{md_idx};
        if strcmp(current_method, table{row_pointer_in_table, 4+length(md_list)})
            value = latable{row_pointer_in_latable, md_idx+3};
            latable{row_pointer_in_latable, md_idx+3} = fix_value(value, 'red');
        elseif strcmp(current_method, table{row_pointer_in_table, 5+length(md_list)})
            value = latable{row_pointer_in_latable, md_idx+3};
            latable{row_pointer_in_latable, md_idx+3} = fix_value(value, 'blue');
        elseif strcmp(current_method, table{row_pointer_in_table, 6+length(md_list)})
            value = latable{row_pointer_in_latable, md_idx+3};
            latable{row_pointer_in_latable, md_idx+3} = fix_value(value, 'black');
        end
    end
    row_pointer_in_table = row_pointer_in_table+1;
    row_pointer_in_latable = row_pointer_in_latable+2;
end


%%
latable{end+1,1} = '\end{tabular}';
latable{end+1,1} = '\end{table}';
latable{end+1,1} = '\end{document}';
save([table_name,'.mat'], 'table');
input.data = table;
xlswrite([table_name,'.xlsx'], table);
fid = fopen('the_result.tex', 'w');
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
function fixed_value = fix_value(cell_content, the_color)
% fix the color of a ranked index
splitted = strsplit(cell_content, '&');
numeric_value = splitted{1,2};
fixed_value = ['&\textbf{\textcolor{', the_color, '}{', numeric_value,'}}'];
end