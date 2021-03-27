function correlations = FR_TID2008_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
load('./datasets/TID2008/TID2008_data.mat');
in_TID2008 = 0;
objective_TID2008 = zeros(1700,5);
objective_TID2008(:,2) = mos_table{:,1};
objective_TID2008(:,3) = mos_table{:,3};
for reference = 1:25
    for distortion = 1:17
        for level = 1:4
            in_TID2008 = in_TID2008 +1
            dst_path = ['./datasets/TID2008/distorted_images/i',num2str(reference, '%02d'),'_',num2str(distortion,'%02d'),'_',num2str(level),'.bmp'];
            ref_path = ['./datasets/TID2008/reference_images/i',num2str(reference, '%02d'),'.bmp'];
            dst = imread(dst_path);
            ref = imread(ref_path);
            
            %
            switch colorful
                case 0
                    dst = double(rgb2gray(dst));
                    ref = double(rgb2gray(ref));
                case 1
                    dst = double(rgb2gray(dst));
                    ref = double(rgb2gray(ref));
                case 2
                    dst = dst;
                    ref = ref;
            end
            
            begin = tic;
            objective = feval(evaluator, ref, dst);
            nigeb = toc(begin);
            objective_TID2008(in_TID2008,1) = objective;
            objective_TID2008(in_TID2008,2) = mos_table{in_TID2008,1};
            objective_TID2008(in_TID2008,3) = reference;
            objective_TID2008(in_TID2008,4) = distortion;
            objective_TID2008(in_TID2008,5) = nigeb;
        end
    end
end

save(['./methods/', evaluator, '/objective_TID2008_',evaluator, '.mat'], 'objective_TID2008')

Additive_Gaussian_Noise = 0;
Dift_Addve_Noise_Col_Comp = 0;
Spatially_Correlated_Noise = 0;
Masked_Noise = 0;
High_Frequency_Noise = 0;
Impulse_Noise = 0;
Quantization_Noise = 0;
Gaussian_Blur = 0;
Image_Denoising = 0;
Jpeg_Compression = 0;
Jp2k_Compression = 0;
Jpeg_Transmission = 0;
Jp2k_Transmission = 0;
Non_Eccentricity_Pattern_Noise = 0;
Local_Block_Dst_of_diff_ints = 0;
Mean_Shift = 0;
Contrast_Change = 0;
for aa = 1:1700
    switch objective_TID2008(aa,4)
        case 1
            Additive_Gaussian_Noise = Additive_Gaussian_Noise+1;
            objective_TID2008_AGN(Additive_Gaussian_Noise,:) = objective_TID2008(aa,:);
        case 2
            Dift_Addve_Noise_Col_Comp = Dift_Addve_Noise_Col_Comp+1;
            objective_TID2008_daNicc(Dift_Addve_Noise_Col_Comp,:) = objective_TID2008(aa,:);
        case 3
            Spatially_Correlated_Noise = Spatially_Correlated_Noise+1;
            objective_TID2008_scN(Spatially_Correlated_Noise,:) = objective_TID2008(aa,:);
        case 4
            Masked_Noise  = Masked_Noise+1;
            objective_TID2008_mN(Masked_Noise,:) = objective_TID2008(aa,:);
        case 5
            High_Frequency_Noise = High_Frequency_Noise+1;
            objective_TID2008_hfN(High_Frequency_Noise, :) = objective_TID2008(aa,:);
        case 6
            Impulse_Noise = Impulse_Noise+1;
            objective_TID2008_iN(Impulse_Noise,:) = objective_TID2008(aa,:);
        case 7
            Quantization_Noise = Quantization_Noise+1;
            objective_TID2008_qN(Quantization_Noise,:) = objective_TID2008(aa,:);
        case 8
            Gaussian_Blur = Gaussian_Blur+1;
            objective_TID2008_gB(Gaussian_Blur,:) = objective_TID2008(aa,:);
        case 9
            Image_Denoising = Image_Denoising+1;
            objective_TID2008_ID(Image_Denoising,:) = objective_TID2008(aa,:);
        case 10
            Jpeg_Compression = Jpeg_Compression+1;
            objective_TID2008_Jpeg(Jpeg_Compression,:) = objective_TID2008(aa,:);
        case 11
            Jp2k_Compression = Jp2k_Compression+1;
            objective_TID2008_Jp2k(Jp2k_Compression,:) = objective_TID2008(aa,:);
        case 12
            Jpeg_Transmission = Jpeg_Transmission+1;
            objective_TID2008_jpegT(Jpeg_Transmission,:) = objective_TID2008(aa,:);
        case 13
            Jp2k_Transmission = Jp2k_Transmission+1;
            objective_TID2008_jp2kT(Jp2k_Transmission,:) = objective_TID2008(aa,:);
        case 14
            Non_Eccentricity_Pattern_Noise = Non_Eccentricity_Pattern_Noise+1;
            objective_TID2008_nepN(Non_Eccentricity_Pattern_Noise,:) = objective_TID2008(aa,:);
        case 15
            Local_Block_Dst_of_diff_ints = Local_Block_Dst_of_diff_ints+1;
            objective_TID2008_lBddi(Local_Block_Dst_of_diff_ints,:) = objective_TID2008(aa,:);
        case 16
            Mean_Shift = Mean_Shift+1;
            objective_TID2008_ms(Mean_Shift,:) = objective_TID2008(aa,:);
        case 17
            Contrast_Change = Contrast_Change+1;
            objective_TID2008_cc(Contrast_Change,:) = objective_TID2008(aa,:);
    end 
end

save(['./methods/', evaluator, '/objective_TID2008_AGN_',evaluator, '.mat'], 'objective_TID2008_AGN')
save(['./methods/', evaluator, '/objective_TID2008_daNicc_',evaluator, '.mat'], 'objective_TID2008_daNicc')
save(['./methods/', evaluator, '/objective_TID2008_scN_',evaluator, '.mat'], 'objective_TID2008_scN')
save(['./methods/', evaluator, '/objective_TID2008_mN_',evaluator, '.mat'], 'objective_TID2008_mN')
save(['./methods/', evaluator, '/objective_TID2008_hfN_',evaluator, '.mat'], 'objective_TID2008_hfN')
save(['./methods/', evaluator, '/objective_TID2008_iN_',evaluator, '.mat'], 'objective_TID2008_iN')
save(['./methods/', evaluator, '/objective_TID2008_qN_',evaluator, '.mat'], 'objective_TID2008_qN')
save(['./methods/', evaluator, '/objective_TID2008_gB_',evaluator, '.mat'], 'objective_TID2008_gB')
save(['./methods/', evaluator, '/objective_TID2008_ID_',evaluator, '.mat'], 'objective_TID2008_ID')
save(['./methods/', evaluator, '/objective_TID2008_Jpeg_',evaluator, '.mat'], 'objective_TID2008_Jpeg')
save(['./methods/', evaluator, '/objective_TID2008_Jp2k_',evaluator, '.mat'], 'objective_TID2008_Jp2k')
save(['./methods/', evaluator, '/objective_TID2008_jpegT_',evaluator, '.mat'], 'objective_TID2008_jpegT')
save(['./methods/', evaluator, '/objective_TID2008_nepN_',evaluator, '.mat'], 'objective_TID2008_nepN')
save(['./methods/', evaluator, '/objective_TID2008_lBddi_',evaluator, '.mat'], 'objective_TID2008_lBddi')
save(['./methods/', evaluator, '/objective_TID2008_ms_',evaluator, '.mat'], 'objective_TID2008_ms')
save(['./methods/', evaluator, '/objective_TID2008_cc_',evaluator, '.mat'], 'objective_TID2008_cc')
save(['./methods/', evaluator, '/objective_TID2008_jp2kT_',evaluator, '.mat'], 'objective_TID2008_jp2kT')

kinds = cell(18, 1);
kinds{1,1} = 'Additive_Gaussian_Noise';
kinds{2,1} = 'Dift_Addve_Noise_Col_Comp';
kinds{3,1} = 'Spatially_Correlated_Noise';
kinds{4,1} = 'Masked_Noise';
kinds{5,1} = 'High_Frequency_Noise';
kinds{6,1} = 'Impulse_Noise';
kinds{7,1} = 'Quantization_Noise';
kinds{8,1} = 'Gaussian_Blur';
kinds{9,1} = 'Image_Denoising';
kinds{10,1} = 'Jpeg_Compression';
kinds{11,1} = 'Jp2k_Compression';
kinds{12,1} = 'Jpeg_Transmission';
kinds{13,1} = 'Jp2k_Transmission';
kinds{14,1} = 'Non_Eccentricity_Pattern_Noise';
kinds{15,1} = 'Local_Block_Dst_of_diff_ints';
kinds{16,1} = 'Mean_Shift';
kinds{17,1} = 'Contrast_Change';
kinds{18,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KROCC';

correlations = cell(length(kinds)+1, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:end,1) = kinds;

correlations{2,2}=corr(objective_TID2008_AGN(:,1), objective_TID2008_AGN(:,2), 'type', 'Spearman');
correlations{3,2}=corr(objective_TID2008_daNicc(:,1), objective_TID2008_daNicc(:,2), 'type', 'Spearman');
correlations{4,2}=corr(objective_TID2008_scN(:,1), objective_TID2008_scN(:,2), 'type', 'Spearman');
correlations{5,2}=corr(objective_TID2008_mN(:,1), objective_TID2008_mN(:,2), 'type', 'Spearman');
correlations{6,2}=corr(objective_TID2008_hfN(:,1), objective_TID2008_hfN(:,2), 'type', 'Spearman');
correlations{7,2}=corr(objective_TID2008_iN(:,1), objective_TID2008_iN(:,2), 'type', 'Spearman');
correlations{8,2}=corr(objective_TID2008_qN(:,1), objective_TID2008_qN(:,2), 'type', 'Spearman');
correlations{9,2}=corr(objective_TID2008_gB(:,1), objective_TID2008_gB(:,2), 'type', 'Spearman');
correlations{10,2}=corr(objective_TID2008_ID(:,1), objective_TID2008_ID(:,2), 'type', 'Spearman');
correlations{11,2}=corr(objective_TID2008_Jpeg(:,1), objective_TID2008_Jpeg(:,2), 'type', 'Spearman');
correlations{12,2}=corr(objective_TID2008_Jp2k(:,1), objective_TID2008_Jp2k(:,2), 'type', 'Spearman');
correlations{13,2}=corr(objective_TID2008_jpegT(:,1), objective_TID2008_jpegT(:,2), 'type', 'Spearman');
correlations{14,2}=corr(objective_TID2008_jp2kT(:,1), objective_TID2008_jp2kT(:,2), 'type', 'Spearman');
correlations{15,2}=corr(objective_TID2008_nepN(:,1), objective_TID2008_nepN(:,2), 'type', 'Spearman');
correlations{16,2}=corr(objective_TID2008_lBddi(:,1), objective_TID2008_lBddi(:,2), 'type', 'Spearman');
correlations{17,2}=corr(objective_TID2008_ms(:,1), objective_TID2008_ms(:,2), 'type', 'Spearman');
correlations{18,2}=corr(objective_TID2008_cc(:,1), objective_TID2008_cc(:,2), 'type', 'Spearman');
correlations{19,2}=corr(objective_TID2008(:,1), objective_TID2008(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_TID2008_AGN(:,1), objective_TID2008_AGN(:,2), 'type', 'Kendall');
correlations{3,5}=corr(objective_TID2008_daNicc(:,1), objective_TID2008_daNicc(:,2), 'type', 'Kendall');
correlations{4,5}=corr(objective_TID2008_scN(:,1), objective_TID2008_scN(:,2), 'type', 'Kendall');
correlations{5,5}=corr(objective_TID2008_mN(:,1), objective_TID2008_mN(:,2), 'type', 'Kendall');
correlations{6,5}=corr(objective_TID2008_hfN(:,1), objective_TID2008_hfN(:,2), 'type', 'Kendall');
correlations{7,5}=corr(objective_TID2008_iN(:,1), objective_TID2008_iN(:,2), 'type', 'Kendall');
correlations{8,5}=corr(objective_TID2008_qN(:,1), objective_TID2008_qN(:,2), 'type', 'Kendall');
correlations{9,5}=corr(objective_TID2008_gB(:,1), objective_TID2008_gB(:,2), 'type', 'Kendall');
correlations{10,5}=corr(objective_TID2008_ID(:,1), objective_TID2008_ID(:,2), 'type', 'Kendall');
correlations{11,5}=corr(objective_TID2008_Jpeg(:,1), objective_TID2008_Jpeg(:,2), 'type', 'Kendall');
correlations{12,5}=corr(objective_TID2008_Jp2k(:,1), objective_TID2008_Jp2k(:,2), 'type', 'Kendall');
correlations{13,5}=corr(objective_TID2008_jpegT(:,1), objective_TID2008_jpegT(:,2), 'type', 'Kendall');
correlations{14,5}=corr(objective_TID2008_jp2kT(:,1), objective_TID2008_jp2kT(:,2), 'type', 'Kendall');
correlations{15,5}=corr(objective_TID2008_nepN(:,1), objective_TID2008_nepN(:,2), 'type', 'Kendall');
correlations{16,5}=corr(objective_TID2008_lBddi(:,1), objective_TID2008_lBddi(:,2), 'type', 'Kendall');
correlations{17,5}=corr(objective_TID2008_ms(:,1), objective_TID2008_ms(:,2), 'type', 'Kendall');
correlations{18,5}=corr(objective_TID2008_cc(:,1), objective_TID2008_cc(:,2), 'type', 'Kendall');
correlations{19,5}=corr(objective_TID2008(:,1), objective_TID2008(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_TID2008_AGN(:,1),objective_TID2008_AGN(:,2));
[correlations{3,3},correlations{3,4}] = PearsonLC(objective_TID2008_daNicc(:,1),objective_TID2008_daNicc(:,2));
[correlations{4,3},correlations{4,4}] = PearsonLC(objective_TID2008_scN(:,1),objective_TID2008_scN(:,2));
[correlations{5,3},correlations{5,4}] = PearsonLC(objective_TID2008_mN(:,1),objective_TID2008_mN(:,2));
[correlations{6,3},correlations{6,4}] = PearsonLC(objective_TID2008_hfN(:,1),objective_TID2008_hfN(:,2));
[correlations{7,3},correlations{7,4}] = PearsonLC(objective_TID2008_iN(:,1),objective_TID2008_iN(:,2));
[correlations{8,3},correlations{8,4}] = PearsonLC(objective_TID2008_qN(:,1), objective_TID2008_qN(:,2));
[correlations{9,3},correlations{9,4}] = PearsonLC(objective_TID2008_gB(:,1), objective_TID2008_gB(:,2));
[correlations{10,3},correlations{10,4}] = PearsonLC(objective_TID2008_ID(:,1), objective_TID2008_ID(:,2));
[correlations{11,3},correlations{11,4}] = PearsonLC(objective_TID2008_Jpeg(:,1), objective_TID2008_Jpeg(:,2));
[correlations{12,3},correlations{12,4}] = PearsonLC(objective_TID2008_Jp2k(:,1), objective_TID2008_Jp2k(:,2));
[correlations{13,3},correlations{13,4}] = PearsonLC(objective_TID2008_jpegT(:,1), objective_TID2008_jpegT(:,2));
[correlations{14,3},correlations{14,4}] = PearsonLC(objective_TID2008_jp2kT(:,1), objective_TID2008_jp2kT(:,2));
[correlations{15,3},correlations{15,4}] = PearsonLC(objective_TID2008_nepN(:,1), objective_TID2008_nepN(:,2));
[correlations{16,3},correlations{16,4}] = PearsonLC(objective_TID2008_lBddi(:,1), objective_TID2008_lBddi(:,2));
[correlations{17,3},correlations{17,4}] = PearsonLC(objective_TID2008_ms(:,1), objective_TID2008_ms(:,2));
[correlations{18,3},correlations{18,4}] = PearsonLC(objective_TID2008_cc(:,1), objective_TID2008_cc(:,2));
[correlations{19,3},correlations{19,4}] = PearsonLC(objective_TID2008(:,1),objective_TID2008(:,2));

save(['./methods/', evaluator, '/corr_TID2008_',evaluator,'.mat'], 'correlations');
disp(correlations);
