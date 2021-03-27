function correlations = FR_TID2013_f(evaluator, state)
switch nargin
    case 1
        colorful = 0;
    case 2
        colorful = state;
end
mkdir(['./methods/', evaluator])
load('./datasets/TID2013/TID2013_data.mat');
in_TID2013 = 0;
objective_TID2013 = zeros(3000,5);
for reference = 1:25
    for distortion = 1:24
        for level = 1:5
            in_TID2013 = in_TID2013 +1
            dst_path = ['./datasets/TID2013/distorted_images/i',num2str(reference, '%02d'),'_',num2str(distortion,'%02d'),'_',num2str(level),'.bmp'];
            ref_path = ['./datasets/TID2013/reference_images/i',num2str(reference, '%02d'),'.bmp'];
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
            objective_TID2013(in_TID2013,1) = objective;
            objective_TID2013(in_TID2013,2) = mos_table{in_TID2013,1};
            objective_TID2013(in_TID2013,3) = reference;
            objective_TID2013(in_TID2013,4) = distortion;
            objective_TID2013(in_TID2013,5) = nigeb;
        end
    end
end

save(['./methods/', evaluator, '/objective_TID2013_',evaluator, '.mat'], 'objective_TID2013')

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
Change_Color_Saturation = 0;
Multiplicative_GN = 0;
Comfort_Noise = 0;
Lossy_Compression_Noisy = 0;
Color_Q_Dither = 0;
Chromatic_Aberrations = 0;
Sparse_SR = 0;
for aa = 1:3000
    switch objective_TID2013(aa,4)
        case 1
            Additive_Gaussian_Noise = Additive_Gaussian_Noise+1;
            objective_TID2013_AGN(Additive_Gaussian_Noise,:) = objective_TID2013(aa,:);
        case 2
            Dift_Addve_Noise_Col_Comp = Dift_Addve_Noise_Col_Comp+1;
            objective_TID2013_daNicc(Dift_Addve_Noise_Col_Comp,:) = objective_TID2013(aa,:);
        case 3
            Spatially_Correlated_Noise = Spatially_Correlated_Noise+1;
            objective_TID2013_scN(Spatially_Correlated_Noise,:) = objective_TID2013(aa,:);
        case 4
            Masked_Noise  = Masked_Noise+1;
            objective_TID2013_mN(Masked_Noise,:) = objective_TID2013(aa,:);
        case 5
            High_Frequency_Noise = High_Frequency_Noise+1;
            objective_TID2013_hfN(High_Frequency_Noise, :) = objective_TID2013(aa,:);
        case 6
            Impulse_Noise = Impulse_Noise+1;
            objective_TID2013_iN(Impulse_Noise,:) = objective_TID2013(aa,:);
        case 7
            Quantization_Noise = Quantization_Noise+1;
            objective_TID2013_qN(Quantization_Noise,:) = objective_TID2013(aa,:);
        case 8
            Gaussian_Blur = Gaussian_Blur+1;
            objective_TID2013_gB(Gaussian_Blur,:) = objective_TID2013(aa,:);
        case 9
            Image_Denoising = Image_Denoising+1;
            objective_TID2013_ID(Image_Denoising,:) = objective_TID2013(aa,:);
        case 10
            Jpeg_Compression = Jpeg_Compression+1;
            objective_TID2013_Jpeg(Jpeg_Compression,:) = objective_TID2013(aa,:);
        case 11
            Jp2k_Compression = Jp2k_Compression+1;
            objective_TID2013_Jp2k(Jp2k_Compression,:) = objective_TID2013(aa,:);
        case 12
            Jpeg_Transmission = Jpeg_Transmission+1;
            objective_TID2013_jpegT(Jpeg_Transmission,:) = objective_TID2013(aa,:);
        case 13
            Jp2k_Transmission = Jp2k_Transmission+1;
            objective_TID2013_jp2kT(Jp2k_Transmission,:) = objective_TID2013(aa,:);
        case 14
            Non_Eccentricity_Pattern_Noise = Non_Eccentricity_Pattern_Noise+1;
            objective_TID2013_nepN(Non_Eccentricity_Pattern_Noise,:) = objective_TID2013(aa,:);
        case 15
            Local_Block_Dst_of_diff_ints = Local_Block_Dst_of_diff_ints+1;
            objective_TID2013_lBddi(Local_Block_Dst_of_diff_ints,:) = objective_TID2013(aa,:);
        case 16
            Mean_Shift = Mean_Shift+1;
            objective_TID2013_ms(Mean_Shift,:) = objective_TID2013(aa,:);
        case 17
            Contrast_Change = Contrast_Change+1;
            objective_TID2013_cc(Contrast_Change,:) = objective_TID2013(aa,:);
        case 18
            Change_Color_Saturation = Change_Color_Saturation +1;
            objective_TID2013_ccs(Change_Color_Saturation,:) = objective_TID2013(aa,:);
        case 19
            Multiplicative_GN = Multiplicative_GN +1;
            objective_TID2013_mGN(Multiplicative_GN,:) = objective_TID2013(aa,:);
        case 20
            Comfort_Noise = Comfort_Noise+1;
            objective_TID2013_comN(Comfort_Noise,:) = objective_TID2013(aa,:);
        case 21
            Lossy_Compression_Noisy = Lossy_Compression_Noisy+1;
            objective_TID2013_lcNi(Lossy_Compression_Noisy,:) = objective_TID2013(aa,:);
        case 22
            Color_Q_Dither = Color_Q_Dither+1;
            objective_TID2013_CqD(Color_Q_Dither,:) = objective_TID2013(aa,:);
        case 23
            Chromatic_Aberrations = Chromatic_Aberrations+1;
            objective_TID2013_ChAb(Chromatic_Aberrations,:) = objective_TID2013(aa,:);
        case 24
            Sparse_SR = Sparse_SR+1;
            objective_TID2013_sSR(Sparse_SR,:) = objective_TID2013(aa,:);
    end 
end

save(['./methods/', evaluator, '/objective_TID2013_AGN_',evaluator, '.mat'], 'objective_TID2013_AGN')
save(['./methods/', evaluator, '/objective_TID2013_daNicc_',evaluator, '.mat'], 'objective_TID2013_daNicc')
save(['./methods/', evaluator, '/objective_TID2013_scN_',evaluator, '.mat'], 'objective_TID2013_scN')
save(['./methods/', evaluator, '/objective_TID2013_mN_',evaluator, '.mat'], 'objective_TID2013_mN')
save(['./methods/', evaluator, '/objective_TID2013_hfN_',evaluator, '.mat'], 'objective_TID2013_hfN')
save(['./methods/', evaluator, '/objective_TID2013_iN_',evaluator, '.mat'], 'objective_TID2013_iN')
save(['./methods/', evaluator, '/objective_TID2013_qN_',evaluator, '.mat'], 'objective_TID2013_qN')
save(['./methods/', evaluator, '/objective_TID2013_gB_',evaluator, '.mat'], 'objective_TID2013_gB')
save(['./methods/', evaluator, '/objective_TID2013_ID_',evaluator, '.mat'], 'objective_TID2013_ID')
save(['./methods/', evaluator, '/objective_TID2013_Jpeg_',evaluator, '.mat'], 'objective_TID2013_Jpeg')
save(['./methods/', evaluator, '/objective_TID2013_Jp2k_',evaluator, '.mat'], 'objective_TID2013_Jp2k')
save(['./methods/', evaluator, '/objective_TID2013_jpegT_',evaluator, '.mat'], 'objective_TID2013_jpegT')
save(['./methods/', evaluator, '/objective_TID2013_nepN_',evaluator, '.mat'], 'objective_TID2013_nepN')
save(['./methods/', evaluator, '/objective_TID2013_lBddi_',evaluator, '.mat'], 'objective_TID2013_lBddi')
save(['./methods/', evaluator, '/objective_TID2013_ms_',evaluator, '.mat'], 'objective_TID2013_ms')
save(['./methods/', evaluator, '/objective_TID2013_cc_',evaluator, '.mat'], 'objective_TID2013_cc')
save(['./methods/', evaluator, '/objective_TID2013_jp2kT_',evaluator, '.mat'], 'objective_TID2013_jp2kT')
save(['./methods/', evaluator, '/objective_TID2013_ccs_',evaluator, '.mat'], 'objective_TID2013_ccs')
save(['./methods/', evaluator, '/objective_TID2013_mGN_',evaluator, '.mat'], 'objective_TID2013_mGN')
save(['./methods/', evaluator, '/objective_TID2013_comN_',evaluator, '.mat'], 'objective_TID2013_comN')
save(['./methods/', evaluator, '/objective_TID2013_lcNi_',evaluator, '.mat'], 'objective_TID2013_lcNi')
save(['./methods/', evaluator, '/objective_TID2013_CqD_',evaluator, '.mat'], 'objective_TID2013_CqD')
save(['./methods/', evaluator, '/objective_TID2013_ChAb_',evaluator, '.mat'], 'objective_TID2013_ChAb')
save(['./methods/', evaluator, '/objective_TID2013_sSR_',evaluator, '.mat'], 'objective_TID2013_sSR')


kinds = cell(25, 1);
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
kinds{18,1} = 'Change_Color_Saturation';
kinds{19,1} = 'Multiplicative_Gaussian_Noise';
kinds{20,1} = 'Comfort_Noise';
kinds{21,1} = 'Lossy_Compression_Noisy';
kinds{22,1} = 'Color_Q_Dither';
kinds{23,1} = 'Chromatic_Aberrations';
kinds{24,1} = 'Sparse_SR';
kinds{25,1} = 'ALL';

indexes = cell(1,4);
indexes{1,1}= 'SROCC';
indexes{1,2}= 'PLCC';
indexes{1,3}= 'RMSE';
indexes{1,4}= 'KROCC';

correlations = cell(length(kinds)+1, length(indexes)+1);
correlations(1,2:end) = indexes;
correlations(2:end,1) = kinds;

correlations{2,2}=corr(objective_TID2013_AGN(:,1), objective_TID2013_AGN(:,2), 'type', 'Spearman');
correlations{3,2}=corr(objective_TID2013_daNicc(:,1), objective_TID2013_daNicc(:,2), 'type', 'Spearman');
correlations{4,2}=corr(objective_TID2013_scN(:,1), objective_TID2013_scN(:,2), 'type', 'Spearman');
correlations{5,2}=corr(objective_TID2013_mN(:,1), objective_TID2013_mN(:,2), 'type', 'Spearman');
correlations{6,2}=corr(objective_TID2013_hfN(:,1), objective_TID2013_hfN(:,2), 'type', 'Spearman');
correlations{7,2}=corr(objective_TID2013_iN(:,1), objective_TID2013_iN(:,2), 'type', 'Spearman');
correlations{8,2}=corr(objective_TID2013_qN(:,1), objective_TID2013_qN(:,2), 'type', 'Spearman');
correlations{9,2}=corr(objective_TID2013_gB(:,1), objective_TID2013_gB(:,2), 'type', 'Spearman');
correlations{10,2}=corr(objective_TID2013_ID(:,1), objective_TID2013_ID(:,2), 'type', 'Spearman');
correlations{11,2}=corr(objective_TID2013_Jpeg(:,1), objective_TID2013_Jpeg(:,2), 'type', 'Spearman');
correlations{12,2}=corr(objective_TID2013_Jp2k(:,1), objective_TID2013_Jp2k(:,2), 'type', 'Spearman');
correlations{13,2}=corr(objective_TID2013_jpegT(:,1), objective_TID2013_jpegT(:,2), 'type', 'Spearman');
correlations{14,2}=corr(objective_TID2013_jp2kT(:,1), objective_TID2013_jp2kT(:,2), 'type', 'Spearman');
correlations{15,2}=corr(objective_TID2013_nepN(:,1), objective_TID2013_nepN(:,2), 'type', 'Spearman');
correlations{16,2}=corr(objective_TID2013_lBddi(:,1), objective_TID2013_lBddi(:,2), 'type', 'Spearman');
correlations{17,2}=corr(objective_TID2013_ms(:,1), objective_TID2013_ms(:,2), 'type', 'Spearman');
correlations{18,2}=corr(objective_TID2013_cc(:,1), objective_TID2013_cc(:,2), 'type', 'Spearman');
correlations{19,2}=corr(objective_TID2013_ccs(:,1), objective_TID2013_ccs(:,2), 'type', 'Spearman');
correlations{20,2}=corr(objective_TID2013_mGN(:,1), objective_TID2013_mGN(:,2), 'type', 'Spearman');
correlations{21,2}=corr(objective_TID2013_comN(:,1), objective_TID2013_comN(:,2), 'type', 'Spearman');
correlations{22,2}=corr(objective_TID2013_lcNi(:,1), objective_TID2013_lcNi(:,2), 'type', 'Spearman');
correlations{23,2}=corr(objective_TID2013_CqD(:,1), objective_TID2013_CqD(:,2), 'type', 'Spearman');
correlations{24,2}=corr(objective_TID2013_ChAb(:,1), objective_TID2013_ChAb(:,2), 'type', 'Spearman');
correlations{25,2}=corr(objective_TID2013_sSR(:,1), objective_TID2013_sSR(:,2), 'type', 'Spearman');
correlations{26,2}=corr(objective_TID2013(:,1), objective_TID2013(:,2), 'type', 'Spearman');

correlations{2,5}=corr(objective_TID2013_AGN(:,1), objective_TID2013_AGN(:,2), 'type', 'Kendall');
correlations{3,5}=corr(objective_TID2013_daNicc(:,1), objective_TID2013_daNicc(:,2), 'type', 'Kendall');
correlations{4,5}=corr(objective_TID2013_scN(:,1), objective_TID2013_scN(:,2), 'type', 'Kendall');
correlations{5,5}=corr(objective_TID2013_mN(:,1), objective_TID2013_mN(:,2), 'type', 'Kendall');
correlations{6,5}=corr(objective_TID2013_hfN(:,1), objective_TID2013_hfN(:,2), 'type', 'Kendall');
correlations{7,5}=corr(objective_TID2013_iN(:,1), objective_TID2013_iN(:,2), 'type', 'Kendall');
correlations{8,5}=corr(objective_TID2013_qN(:,1), objective_TID2013_qN(:,2), 'type', 'Kendall');
correlations{9,5}=corr(objective_TID2013_gB(:,1), objective_TID2013_gB(:,2), 'type', 'Kendall');
correlations{10,5}=corr(objective_TID2013_ID(:,1), objective_TID2013_ID(:,2), 'type', 'Kendall');
correlations{11,5}=corr(objective_TID2013_Jpeg(:,1), objective_TID2013_Jpeg(:,2), 'type', 'Kendall');
correlations{12,5}=corr(objective_TID2013_Jp2k(:,1), objective_TID2013_Jp2k(:,2), 'type', 'Kendall');
correlations{13,5}=corr(objective_TID2013_jpegT(:,1), objective_TID2013_jpegT(:,2), 'type', 'Kendall');
correlations{14,5}=corr(objective_TID2013_jp2kT(:,1), objective_TID2013_jp2kT(:,2), 'type', 'Kendall');
correlations{15,5}=corr(objective_TID2013_nepN(:,1), objective_TID2013_nepN(:,2), 'type', 'Kendall');
correlations{16,5}=corr(objective_TID2013_lBddi(:,1), objective_TID2013_lBddi(:,2), 'type', 'Kendall');
correlations{17,5}=corr(objective_TID2013_ms(:,1), objective_TID2013_ms(:,2), 'type', 'Kendall');
correlations{18,5}=corr(objective_TID2013_cc(:,1), objective_TID2013_cc(:,2), 'type', 'Kendall');
correlations{19,5}=corr(objective_TID2013_ccs(:,1), objective_TID2013_ccs(:,2), 'type', 'Kendall');
correlations{20,5}=corr(objective_TID2013_mGN(:,1), objective_TID2013_mGN(:,2), 'type', 'Kendall');
correlations{21,5}=corr(objective_TID2013_comN(:,1), objective_TID2013_comN(:,2), 'type', 'Kendall');
correlations{22,5}=corr(objective_TID2013_lcNi(:,1), objective_TID2013_lcNi(:,2), 'type', 'Kendall');
correlations{23,5}=corr(objective_TID2013_CqD(:,1), objective_TID2013_CqD(:,2), 'type', 'Kendall');
correlations{24,5}=corr(objective_TID2013_ChAb(:,1), objective_TID2013_ChAb(:,2), 'type', 'Kendall');
correlations{25,5}=corr(objective_TID2013_sSR(:,1), objective_TID2013_sSR(:,2), 'type', 'Kendall');
correlations{26,5}=corr(objective_TID2013(:,1), objective_TID2013(:,2), 'type', 'Kendall');

[correlations{2,3},correlations{2,4}] = PearsonLC(objective_TID2013_AGN(:,1),objective_TID2013_AGN(:,2));
[correlations{3,3},correlations{3,4}] = PearsonLC(objective_TID2013_daNicc(:,1),objective_TID2013_daNicc(:,2));
[correlations{4,3},correlations{4,4}] = PearsonLC(objective_TID2013_scN(:,1),objective_TID2013_scN(:,2));
[correlations{5,3},correlations{5,4}] = PearsonLC(objective_TID2013_mN(:,1),objective_TID2013_mN(:,2));
[correlations{6,3},correlations{6,4}] = PearsonLC(objective_TID2013_hfN(:,1),objective_TID2013_hfN(:,2));
[correlations{7,3},correlations{7,4}] = PearsonLC(objective_TID2013_iN(:,1),objective_TID2013_iN(:,2));
[correlations{8,3},correlations{8,4}] = PearsonLC(objective_TID2013_qN(:,1), objective_TID2013_qN(:,2));
[correlations{9,3},correlations{9,4}] = PearsonLC(objective_TID2013_gB(:,1), objective_TID2013_gB(:,2));
[correlations{10,3},correlations{10,4}] = PearsonLC(objective_TID2013_ID(:,1), objective_TID2013_ID(:,2));
[correlations{11,3},correlations{11,4}] = PearsonLC(objective_TID2013_Jpeg(:,1), objective_TID2013_Jpeg(:,2));
[correlations{12,3},correlations{12,4}] = PearsonLC(objective_TID2013_Jp2k(:,1), objective_TID2013_Jp2k(:,2));
[correlations{13,3},correlations{13,4}] = PearsonLC(objective_TID2013_jpegT(:,1), objective_TID2013_jpegT(:,2));
[correlations{14,3},correlations{14,4}] = PearsonLC(objective_TID2013_jp2kT(:,1), objective_TID2013_jp2kT(:,2));
[correlations{15,3},correlations{15,4}] = PearsonLC(objective_TID2013_nepN(:,1), objective_TID2013_nepN(:,2));
[correlations{16,3},correlations{16,4}] = PearsonLC(objective_TID2013_lBddi(:,1), objective_TID2013_lBddi(:,2));
[correlations{17,3},correlations{17,4}] = PearsonLC(objective_TID2013_ms(:,1), objective_TID2013_ms(:,2));
[correlations{18,3},correlations{18,4}] = PearsonLC(objective_TID2013_cc(:,1), objective_TID2013_cc(:,2));
[correlations{19,3},correlations{19,4}] = PearsonLC(objective_TID2013_ccs(:,1), objective_TID2013_ccs(:,2));
[correlations{20,3},correlations{20,4}] = PearsonLC(objective_TID2013_mGN(:,1), objective_TID2013_mGN(:,2));
[correlations{21,3},correlations{21,4}] = PearsonLC(objective_TID2013_comN(:,1), objective_TID2013_comN(:,2));
[correlations{22,3},correlations{22,4}] = PearsonLC(objective_TID2013_lcNi(:,1), objective_TID2013_lcNi(:,2));
[correlations{23,3},correlations{23,4}] = PearsonLC(objective_TID2013_CqD(:,1), objective_TID2013_CqD(:,2));
[correlations{24,3},correlations{24,4}] = PearsonLC(objective_TID2013_ChAb(:,1), objective_TID2013_ChAb(:,2));
[correlations{25,3},correlations{25,4}] = PearsonLC(objective_TID2013_sSR(:,1), objective_TID2013_sSR(:,2));
[correlations{26,3},correlations{26,4}] = PearsonLC(objective_TID2013(:,1),objective_TID2013(:,2));


save(['./methods/', evaluator, '/corr_TID2013_',evaluator,'.mat'], 'correlations');
disp(correlations);
