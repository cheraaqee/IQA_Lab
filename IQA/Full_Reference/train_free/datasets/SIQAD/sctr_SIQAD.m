function sctr_SIQAD(evaluator)
mkdir(['./methods/',evaluator,'/scatter_plots_SIQAD'])
load(['./methods/',evaluator,'/objective_SIQAD_vec_',evaluator, '.mat']);
load(['./methods/',evaluator,'/objective_SIQAD_mtx_',evaluator, '.mat']);
load('./datasets/SIQAD/subjective_SIQAD_vec.mat');
load('./datasets/SIQAD/subjective_SIQAD_dst_wise.mat');
load('./datasets/SIQAD/DMOS_SIQAD.mat');
load(['./methods/',evaluator,'/objective_SIQAD_dst_wise_',evaluator, '.mat']);
obj_all = predicted_vec(:,1);
sbj_all = subjective_vec;
dst_all = ones(980,1);
for dst_idx = 1:7
    dst_all(1+(dst_idx-1)*140:dst_idx*140) = dst_idx;
end
dst_list = {'GN', 'GB', 'MB', 'CC', 'JPEG', 'JPEG2000', 'LSC';...
    1,2,3,4,5,6,7};
% in SCID_1600 the dst #7 is excluded, however, the last two dsts are still
% numbered 8 and 9, instead of 7 and 8. So their number is manually
% included in the 'dst_list'
for dst_idx = 1:size(dst_list, 2)
    dst_name = dst_list{1, dst_idx};
    dst_nmbr = dst_list{2, dst_idx};
    obj_dst = predicted_dst_wise(:,dst_idx);
    sbj_dst = subjective_dst_wise(:,dst_idx);
    plot(sbj_dst, obj_dst, '+'), title(dst_name), ylabel('Objective'),...
        xlabel('Subjective')
    savefig(['./methods/',evaluator, '/scatter_plots_SIQAD/dst_',dst_name,'.fig']);
    saveas(gcf, ['./methods/',evaluator, '/scatter_plots_SIQAD/dst_',dst_name,'.jpg']);
    pdfname = ['./methods/',evaluator, '/scatter_plots_SIQAD/dst_',dst_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
end
% gscatter(sbj_all, obj_all, dst_all, 'ymcrgbwk', 'o+*.xsd^', 8),...
gscatter(sbj_all, obj_all, dst_all, ...
    [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; ...
    0.85 0.325 0.0988], 'osd^p+>', 8),...
    legend(dst_list(1,:)), ylabel('Objective'), xlabel('Subjective');
savefig(['./methods/',evaluator, '/scatter_plots_SIQAD/all_',evaluator,'.fig']);
saveas(gcf, ['./methods/',evaluator, '/scatter_plots_SIQAD/all_',evaluator,'.jpg']);
pdfname = ['./methods/',evaluator, '/scatter_plots_SIQAD/all_',evaluator];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
%%
mkdir(['./methods/',evaluator,'/scatter_plots_SIQAD/by_refs_SIQAD'])
for ref_idx = 1:20
    ref_name = num2str(ref_idx);
    obj_ref = predicted_mtx(:,ref_idx);
    sbj_ref = DMOS(:,ref_idx);
    for dst_idx = 1:7
        dst_ref(1+(dst_idx-1)*7:dst_idx*7) = dst_idx;
    end
    dst_ref = dst_ref';
    ref_img_nme = ['./datasets/SIQAD/references/cim',num2str(ref_idx),'.bmp'];
    ref_img = imread(ref_img_nme);
    SROCC(ref_idx) = abs(corr(obj_ref, sbj_ref, 'type', 'Spearman'));
    [PLCC(ref_idx), RMSE(ref_idx)] = PearsonLC(sbj_ref, obj_ref);
    close all
    PLCC = abs(PLCC);
    RMSE = abs(RMSE);
    for dst_idx = 1:7
        rows_of_interest = find(dst_ref == dst_idx);
        obj_ref_dst = predicted_mtx(rows_of_interest, ref_idx);
        sbj_ref_dst = DMOS(rows_of_interest, ref_idx);
        SROCC_dst(dst_idx) = abs(corr(obj_ref_dst, sbj_ref_dst, 'type', 'Spearman'));
        [PLCC_dst(dst_idx), RMSE_dst(dst_idx)] = PearsonLC(sbj_ref_dst, obj_ref_dst);
        close all
        PLCC_dst = abs(PLCC_dst);
        RMSE_dst = abs(RMSE_dst);
    end
    close all
    new_legend = dst_list(1,:);
    for ii = 1:length(dst_list(1,:))
        new_legend{ii} = [dst_list{1,ii},...
            '[',num2str(SROCC_dst(ii),2), ...
            '][',num2str(PLCC_dst(ii),2),...
            '][',num2str(RMSE_dst(ii),2),']'];
    end
    gscatter(sbj_ref, obj_ref, dst_ref ,...
    [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; ...
    0.85 0.325 0.0988], 'osd^p+>', 8), title(['S= ',...
        num2str(SROCC(ref_idx),2), ' P= ', num2str(PLCC(ref_idx),2),...
        ' E= ', num2str(RMSE(ref_idx),2)]),...
        legend(new_legend), ylabel('Objective'), xlabel('Subjective')
    savefig(['./methods/',evaluator, '/scatter_plots_SIQAD/by_refs_SIQAD/ref_SIQAD_',...
        ref_name,'.fig']);
    saveas(gcf, ['./methods/',evaluator, '/scatter_plots_SIQAD/by_refs_SIQAD/ref_SIQAD_'...
        ,ref_name,'.jpg']);
    pdfname = ['./methods/',evaluator, '/scatter_plots_SIQAD/by_refs_SIQAD/ref_SIQAD_'...
        ,ref_name];
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',[0 0 screenposition(3:4)],...
        'PaperSize',[screenposition(3:4)]);
    print(pdfname, '-dpdf', '-painters');
    plt_img = imread(['./methods/',evaluator, '/scatter_plots_SIQAD/by_refs_SIQAD/ref_SIQAD_'...
        ,ref_name,'.jpg']);
    [plt_rows, plt_cls, ~]=size(plt_img);
    ref_img = imresize(ref_img, [plt_rows, NaN]);
    container = zeros(plt_rows, plt_cls+size(ref_img, 2),3);
    container(:,1:plt_cls, :) = plt_img;
    container(:,plt_cls+1:end,:) = ref_img;
    container = uint8(container);
    imwrite(container, ['./methods/',evaluator, ...
        '/scatter_plots_SIQAD/by_refs_SIQAD/refplt_SIQAD_'...
        ,ref_name,'.jpg'])
end
bar(abs([SROCC', PLCC', RMSE'])), xticks(1:20)
savefig(['./methods/',evaluator, '/scatter_plots_SIQAD/by_refs_SIQAD/bar_by_ref_SIQAD.fig']);
saveas(gcf, ['./methods/',evaluator, '/scatter_plots_SIQAD/by_refs_SIQAD/bar_by_ref_SIQAD.jpg']);
pdfname = ['./methods/',evaluator, '/scatter_plots_SIQAD/by_refs_SIQAD/bar_by_ref_SIQAD'];
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
close all
end