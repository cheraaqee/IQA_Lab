% methods_list = {'psnr_index', 'ssim', 'GMSD', 'HaarPSI', 'WSC_3LHV','MDOGS', 'GFM', 'ESIM', 'SQMS', 'GSS', ...
%     'SVQI', 'cgsi', 'SIQM'};
addpath(genpath('./datasets'))
methods_list = {'WS_3HV_D2'};
for method_idx = 1:length(methods_list)
    evaluator = methods_list{method_idx};
    sctr_SCID(evaluator)
    %        sctr_SIQAD(evaluator)
    sctr_QACS(evaluator)
    sctr_SIQAD(evaluator)
    %     sctr_MLIVE(evaluator)
    %     sctr_MDID2013(evaluator)
    %     sctr_MDID(evaluator)
end