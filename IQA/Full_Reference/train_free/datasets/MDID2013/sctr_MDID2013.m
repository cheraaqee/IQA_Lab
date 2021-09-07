function sctr_MDID2013(evaluator)
mkdir(['./',evaluator,'/scatter_plots_MDID13'])
load(['./',evaluator,'/objective_MDID2013_',evaluator, '.mat']);
obj_all = objective_MDID13(:,1);
sbj_all = objective_MDID13(:,2);
dst_all = ones(324, 1);
dst_list = {'ALL';...
    1};
% in MDID the dst #7 is excluded, however, the last two dsts are still
% numbered 8 and 9, instead of 7 and 8. So their number is manually
% included in the 'dst_list'
for dst_idx = 1:size(dst_list, 2)
    dst_name = dst_list{1, dst_idx};
    dst_nmbr = dst_list{2, dst_idx};
    rows_of_distortion = find(dst_all==dst_nmbr);
    obj_dst = objective_MDID13(rows_of_distortion, 1);
    sbj_dst = objective_MDID13(rows_of_distortion, 2);
    plot(sbj_dst, obj_dst, '+'), title(dst_name), ylabel('Objective'),...
        xlabel('Subjective')
    savefig(['./',evaluator, '/scatter_plots_MDID13/dst_',dst_name,'.fig']);
    saveas(gcf, ['./',evaluator, '/scatter_plots_MDID13/dst_',dst_name,'.jpg']);
    pdfname = ['./',evaluator, '/scatter_plots_MDID13/dst_',dst_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
end
% gscatter(sbj_all, obj_all, dst_all, 'ymcrgbwk', 'o+*.xsd^', 8),...
gscatter(sbj_all, obj_all, dst_all, ...
    [1 0 0], 'o', 8),...
    legend(dst_list(1,:)), ylabel('Objective'), xlabel('Subjective')
savefig(['./',evaluator, '/scatter_plots_MDID13/all_',evaluator,'.fig']);
saveas(gcf, ['./',evaluator, '/scatter_plots_MDID13/all_',evaluator,'.jpg']);
pdfname = ['./',evaluator, '/scatter_plots_MDID13/all_',evaluator];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
%%
mkdir(['./',evaluator,'/scatter_plots_MDID13/by_refs_MDID13'])
for ref_idx = 1:max(objective_MDID13(:,3))
    ref_name = num2str(ref_idx);
    rows_of_reference = find(objective_MDID13(:,3)==ref_idx);
    obj_ref = objective_MDID13(rows_of_reference,1);
    sbj_ref = objective_MDID13(rows_of_reference,2);
    dst_ref = dst_all(rows_of_reference);
%     ref_img_nme = ['SCI', num2str(ref_idx,'%02.f'),'.bmp'];
    ref_img_nme = ['./MDID2013/org',num2str(ref_idx,'%03.f'),'.png'];
    ref_img = imread(ref_img_nme);
    SROCC(ref_idx) = abs(corr(obj_ref, sbj_ref, 'type', 'Spearman'));
    [PLCC(ref_idx), RMSE(ref_idx)] = PearsonLC(sbj_ref, obj_ref);
    close all
    PLCC = abs(PLCC);
    RMSE = abs(RMSE);
    for dst_idx = 1:1
        dst_nmbr = dst_list{2, dst_idx};
        rows_of_interest = find(dst_all(rows_of_reference)==dst_nmbr);
        obj_ref_dst = objective_MDID13(rows_of_interest, 1);
        sbj_ref_dst = objective_MDID13(rows_of_interest, 2);
        SROCC_dst(dst_idx) = abs(corr(obj_ref_dst, sbj_ref_dst, 'type', 'Spearman'));
%         [PLCC_dst(dst_idx), RMSE_dst(dst_idx)] = PearsonLC(sbj_ref_dst, obj_ref_dst);
        close all
    end
    close all
    new_legend = dst_list(1,:);
    for ii = 1:length(dst_list(1,:))
        new_legend{ii} = [dst_list{1,ii},...
            '[',num2str(SROCC_dst(ii),2),']'];
    end
    gscatter(sbj_ref, obj_ref, dst_ref,[1 0 0], 'o', 8), ...
        title(['S= ',num2str(SROCC(ref_idx),2), ' P= ', ...
        num2str(PLCC(ref_idx),2),' E= ', num2str(RMSE(ref_idx),2)]),...
        legend(new_legend), ylabel('Objective'), xlabel('Subjective')
    savefig(['./',evaluator, '/scatter_plots_MDID13/by_refs_MDID13/ref_MDID13_',...
        ref_name,'.fig']);
    saveas(gcf, ['./',evaluator, '/scatter_plots_MDID13/by_refs_MDID13/ref_MDID13_'...
        ,ref_name,'.jpg']);
    pdfname = ['./',evaluator, '/scatter_plots_MDID13/by_refs_MDID13/ref_MDID13_'...
        ,ref_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
    plt_img = imread(['./',evaluator, '/scatter_plots_MDID13/by_refs_MDID13/ref_MDID13_'...
        ,ref_name,'.jpg']);
    [plt_rows, plt_cls, ~]=size(plt_img);
    ref_img = imresize(ref_img, [plt_rows, NaN]);
    container = zeros(plt_rows, plt_cls+size(ref_img, 2),3);
    container(:,1:plt_cls, :) = plt_img;
    container(:,plt_cls+1:end,:) = ref_img;
    container = uint8(container);
    imwrite(container, ['./',evaluator, ...
        '/scatter_plots_MDID13/by_refs_MDID13/refplt_MDID13_'...
        ,ref_name,'.jpg'])
end
bar(abs([SROCC', PLCC', RMSE'])), xlim([0 13]), xticks(1:2:12)
savefig(['./',evaluator, '/scatter_plots_MDID13/by_refs_MDID13/bar_by_ref_MDID13.fig']);
saveas(gcf, ['./',evaluator, '/scatter_plots_MDID13/by_refs_MDID13/bar_by_ref_MDID13.jpg']);
pdfname = ['./',evaluator, '/scatter_plots_MDID13/by_refs_MDID13/bar_by_ref_MDID13'];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
close all
end