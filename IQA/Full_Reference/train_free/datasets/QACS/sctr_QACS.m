function sctr_QACS(evaluator)
mkdir(['./methods/',evaluator,'/scatter_plots_QACS'])
load(['./methods/',evaluator,'/objective_QACS_',evaluator, '.mat']);
load('./datasets/QACS/QACS_mos.mat');
obj_all = objective_QACS;
sbj_all = QACS_mos;
dst_all = QACS_ind(:,2);
dst_list = {'HEVC', 'SCC';...
    1,2};
% in SCID_1600 the dst #7 is excluded, however, the last two dsts are still
% numbered 8 and 9, instead of 7 and 8. So their number is manually
% included in the 'dst_list'
for dst_idx = 1:size(dst_list, 2)
    dst_name = dst_list{1, dst_idx};
    dst_nmbr = dst_list{2, dst_idx};
    rows_of_distortion = find(QACS_ind(:,2)==dst_idx);
    obj_dst = objective_QACS(rows_of_distortion);
    sbj_dst = QACS_mos(rows_of_distortion);
    plot(sbj_dst, obj_dst, '+'), title(dst_name), ylabel('Objective'),...
        xlabel('Subjective')
    savefig(['./methods/',evaluator, '/scatter_plots_QACS/dst_',dst_name,'.fig']);
    saveas(gcf, ['./methods/',evaluator, '/scatter_plots_QACS/dst_',dst_name,'.jpg']);
    pdfname = ['./methods/',evaluator, '/scatter_plots_QACS/dst_',dst_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
end
% gscatter(sbj_all, obj_all, dst_all, 'ymcrgbwk', 'o+*.xsd^', 8),...
gscatter(sbj_all, obj_all, dst_all, ...
    [1 0 0; 0 1 0], 'os', 8),...
    legend(dst_list(1,:)), ylabel('Objective'), xlabel('Subjective');
savefig(['./methods/',evaluator, '/scatter_plots_QACS/all_',evaluator,'.fig']);
saveas(gcf, ['./methods/',evaluator, '/scatter_plots_QACS/all_',evaluator,'.jpg']);
pdfname = ['./methods/',evaluator, '/scatter_plots_QACS/all_',evaluator];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
close all
mkdir(['./methods/',evaluator,'/scatter_plots_QACS/by_refs_QACS'])
for ref_idx = 1:max(QACS_ind(:,1))
    ref_name = num2str(ref_idx);
    rows_of_reference = find(QACS_ind(:,1)==ref_idx);
    obj_ref = objective_QACS(rows_of_reference);
    sbj_ref = QACS_mos(rows_of_reference);
    dst_ref = QACS_ind(rows_of_reference, 2);
    ref_img_nme = QACS_str{rows_of_reference(1),1};
    % linux path
%     ref_img_nme = strrep(ref_img_nme, '\', '/');
    ref_img = imread(['./datasets/', ref_img_nme]);
    SROCC(ref_idx) = corr(obj_ref', sbj_ref, 'type', 'Spearman');
    [PLCC(ref_idx), RMSE(ref_idx)] = PearsonLC(sbj_ref, obj_ref');
    for dst_idx = 1:max(QACS_ind(:,2))
        havij = QACS_ind(rows_of_reference, :);
        rows_of_interest = find(havij(:,2) == dst_idx);
        obj_ref_dst = objective_QACS(rows_of_interest);
        sbj_ref_dst = QACS_mos(rows_of_interest);
        SROCC_dst(dst_idx) = corr(obj_ref_dst', sbj_ref_dst, 'type', 'Spearman');
        [PLCC_dst(dst_idx), RMSE_dst(dst_idx)] = PearsonLC(sbj_ref_dst, obj_ref_dst');
    end
    close all
    new_legend = dst_list(1,:);
    for ii = 1:length(dst_list(1,:))
       new_legend{ii} = [dst_list{1,ii},...
           '[',num2str(SROCC_dst(ii),2), ...
           '][',num2str(PLCC_dst(ii),2),...
           '][',num2str(RMSE_dst(ii),2),']']; 
    end
    gscatter(sbj_ref, obj_ref, dst_ref, ...
    [1 0 0; 0 1 0], 'os', 8), title(['S= ',...
        num2str(SROCC(ref_idx),2), ' P= ', num2str(PLCC(ref_idx),2),...
        ' E= ', num2str(RMSE(ref_idx),2)]),...
        legend(new_legend), ylabel('Objective'), xlabel('Subjective')
    savefig(['./methods/',evaluator, '/scatter_plots_QACS/by_refs_QACS/ref_QACS_',...
        ref_name,'.fig']);
    saveas(gcf, ['./methods/',evaluator, '/scatter_plots_QACS/by_refs_QACS/ref_QACS_'...
        ,ref_name,'.jpg']);
    pdfname = ['./methods/',evaluator, '/scatter_plots_QACS/by_refs_QACS/ref_QACS_'...
        ,ref_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
    plt_img = imread(['./methods/',evaluator, '/scatter_plots_QACS/by_refs_QACS/ref_QACS_'...
        ,ref_name,'.jpg']);
    [plt_rows, plt_cls, ~]=size(plt_img);
    ref_img = imresize(ref_img, [plt_rows, NaN]);
    container = zeros(plt_rows, plt_cls+size(ref_img, 2),3);
    container(:,1:plt_cls, :) = plt_img;
    container(:,plt_cls+1:end,:) = ref_img;
    container = uint8(container);
    imwrite(container, ['./methods/',evaluator, ...
        '/scatter_plots_QACS/by_refs_QACS/refplt_QACS_'...
        ,ref_name,'.jpg'])
end
bar(abs([SROCC', PLCC', RMSE'])), xticks(1:max(QACS_ind(:,1)))
savefig(['./methods/',evaluator, '/scatter_plots_QACS/by_refs_QACS/bar_by_ref_QACS.fig']);
saveas(gcf, ['./methods/',evaluator, '/scatter_plots_QACS/by_refs_QACS/bar_by_ref_QACS.jpg']);
pdfname = ['./methods/',evaluator, '/scatter_plots_QACS/by_refs_QACS/bar_by_ref_QACS'];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
close all
end