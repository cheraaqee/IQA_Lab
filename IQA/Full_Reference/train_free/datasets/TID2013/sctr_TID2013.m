function sctr_TID2013(evaluator)
mkdir(['./',evaluator,'/scatter_plots_TID2013'])
load(['./',evaluator,'/objective_TID2013_',evaluator, '.mat']);
obj_all = objective_TID2013(:,1);
sbj_all = objective_TID2013(:,2);
dst_all = objective_TID2013(:,4);
load('kinds_tid13.mat');
dst_list = cell(2, length(kinds));
dst_list(1,:) = kinds;
for ii = 1:length(kinds)
   dst_list{2,ii} = ii; 
end
% in SCID_1600 the dst #7 is excluded, however, the last two dsts are still
% numbered 8 and 9, instead of 7 and 8. So their number is manually
% included in the 'dst_list'
for dst_idx = 1:size(dst_list, 2)
    dst_name = dst_list{1, dst_idx};
    dst_nmbr = dst_list{2, dst_idx};
    rows_of_distortion = find(objective_TID2013(:,4)==dst_nmbr);
    obj_dst = objective_TID2013(rows_of_distortion, 1);
    sbj_dst = objective_TID2013(rows_of_distortion, 2);
    plot(sbj_dst, obj_dst, '+'), title(dst_name), ylabel('Objective'),...
        xlabel('Subjective')
    savefig(['./',evaluator, '/scatter_plots_TID2013/dst_',dst_name,'.fig']);
    saveas(gcf, ['./',evaluator, '/scatter_plots_TID2013/dst_',dst_name,'.jpg']);
    pdfname = ['./',evaluator, '/scatter_plots_TID2013/dst_',dst_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
end
% gscatter(sbj_all, obj_all, dst_all, 'ymcrgbwk', 'o+*.xsd^', 8),...
gscatter(sbj_all, obj_all, dst_all),...
    legend(dst_list(1,:)), ylabel('Objective'), xlabel('Subjective')
savefig(['./',evaluator, '/scatter_plots_TID2013/all_',evaluator,'.fig']);
gscatter(sbj_all, obj_all, dst_all),legend('off'),...
    ylabel('Objective'), xlabel('Subjective')
saveas(gcf, ['./',evaluator, '/scatter_plots_TID2013/all_',evaluator,'.jpg']);
pdfname = ['./',evaluator, '/scatter_plots_TID2013/all_',evaluator];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
%%
mkdir(['./',evaluator,'/scatter_plots_TID2013/by_refs_TID2013'])
for ref_idx = 1:max(objective_TID2013(:,3))
    ref_name = num2str(ref_idx);
    rows_of_reference = find(objective_TID2013(:,3)==ref_idx);
    obj_ref = objective_TID2013(rows_of_reference,1);
    sbj_ref = objective_TID2013(rows_of_reference,2);
    dst_ref = objective_TID2013(rows_of_reference,4);
    ref_img_nme = ['./reference_images_tid13/i',num2str(ref_idx, '%02d'),'.bmp'];
    ref_img = imread(ref_img_nme);
    SROCC(ref_idx) = abs(corr(obj_ref, sbj_ref, 'type', 'Spearman'));
    [PLCC(ref_idx), RMSE(ref_idx)] = PearsonLC(sbj_ref, obj_ref);
    close all
    PLCC = abs(PLCC);
    RMSE = abs(RMSE);
    for dst_idx = 1:24
        dst_nmbr = dst_list{2, dst_idx};
        rows_of_interest = find(objective_TID2013(rows_of_reference, 4)==dst_nmbr);
        obj_ref_dst = objective_TID2013(rows_of_interest, 1);
        sbj_ref_dst = objective_TID2013(rows_of_interest, 2);
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
    gscatter(sbj_ref, obj_ref, dst_ref), ...
        title(['S= ',num2str(SROCC(ref_idx),2), ' P= ', ...
        num2str(PLCC(ref_idx),2),' E= ', num2str(RMSE(ref_idx),2)]),...
        legend(new_legend), ylabel('Objective'), xlabel('Subjective')
    savefig(['./',evaluator, '/scatter_plots_TID2013/by_refs_TID2013/ref_TID2013_',...
        ref_name,'.fig']);
    gscatter(sbj_ref, obj_ref, dst_ref),legend('off'), ...
        title(['S= ',num2str(SROCC(ref_idx),2), ' P= ', ...
        num2str(PLCC(ref_idx),2),' E= ', num2str(RMSE(ref_idx),2)]),...
        ylabel('Objective'), xlabel('Subjective')
    saveas(gcf, ['./',evaluator, '/scatter_plots_TID2013/by_refs_TID2013/ref_TID2013_'...
        ,ref_name,'.jpg']);
    pdfname = ['./',evaluator, '/scatter_plots_TID2013/by_refs_TID2013/ref_TID2013_'...
        ,ref_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
    plt_img = imread(['./',evaluator, '/scatter_plots_TID2013/by_refs_TID2013/ref_TID2013_'...
        ,ref_name,'.jpg']);
    [plt_rows, plt_cls, ~]=size(plt_img);
    ref_img = imresize(ref_img, [plt_rows, NaN]);
    container = zeros(plt_rows, plt_cls+size(ref_img, 2),3);
    container(:,1:plt_cls, :) = plt_img;
    container(:,plt_cls+1:end,:) = ref_img;
    container = uint8(container);
    imwrite(container, ['./',evaluator, ...
        '/scatter_plots_TID2013/by_refs_TID2013/refplt_TID2013_'...
        ,ref_name,'.jpg'])
end
bar(abs([SROCC', PLCC', RMSE'])), xlim([0 26]), xticks(1:2:25)
savefig(['./',evaluator, '/scatter_plots_TID2013/by_refs_TID2013/bar_by_ref_TID2013.fig']);
saveas(gcf, ['./',evaluator, '/scatter_plots_TID2013/by_refs_TID2013/bar_by_ref_TID2013.jpg']);
pdfname = ['./',evaluator, '/scatter_plots_TID2013/by_refs_TID2013/bar_by_ref_TID2013'];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
close all
end