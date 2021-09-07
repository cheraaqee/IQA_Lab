% scores' vector, an SROCC, and the time.
close all;
clear all;
mtd_list = {'WS_3HV_D2', 'MDOGS', 'GFM', 'ESIM', 'SQMS', 'GSS', 'SVQI', ...
'cgsi', 'SIQM'};
mtd_list_2 = {'WS-HV', 'MDOGS', 'GFM', 'ESIM', 'SQMS', 'GSS', 'SVQI', ...
'CGSI', 'SIQM'};

bank_for_save = cell(3, length(mtd_list)+1);
bank_for_save(1,2:end) = mtd_list;
bank_for_save{2,1} = 'Time (s)';
bank_for_save{3,1} = 'SROCC';
for mtd_idx = 1:length(mtd_list)
	load(['./methods/',mtd_list{mtd_idx}, '/objective_SIQAD_vec_',...
	mtd_list{mtd_idx}, '.mat']);
	avg_time(mtd_idx) = mean(predicted_vec(:,2));
	bank_for_save{2, mtd_idx+1} = avg_time(mtd_idx);
	load(['./methods/',mtd_list{mtd_idx},'/corr_SIQAD_',...
	mtd_list{mtd_idx}, '.mat']);
	SROCC_SIQAD = abs(correlations{9, 2});
	load(['./methods/', mtd_list{mtd_idx}, '/corr_SCID_1600_',...
	mtd_list{mtd_idx},'.mat']);
	SROCC_SCID = abs(correlations{10, 2});
	load(['./methods/',mtd_list{mtd_idx}, '/corr_QACS_',...
	mtd_list{mtd_idx}, '.mat']);
	SROCC_QACS = abs(correlations{4, 2});
	avg_corr(mtd_idx) = (982*SROCC_SIQAD+1600*SROCC_SCID+492*SROCC_QACS...
	)/(982+1600+492);
	bank_for_save{3, mtd_idx+1} = avg_corr(mtd_idx);
end
figure,
gscatter(log(avg_time)', avg_corr', mtd_list_2'), text(log(avg_time)', ...
avg_corr', mtd_list_2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment',...
'left'), xlabel('Logarithm of Execution Time'), ylabel('Accuracy')
pdfname = 'time_complexity'
set(gcf, 'Units', 'inches');
screenposition = get(gcf, 'Position');
set(gcf, ...
'PaperPosition', [0 0 screenposition(3:4)],...
'PaperSize', [screenposition(3:4)]);
print(pdfname, '-dpdf', '-painters');
