Quality Assessment Database for Super-resolved images: QADS 

QADS  is an image database especially designed for evaluating the performance of image
 quality assessment algorithms on super-resolved images(SRIs).It contains 20 source images and 980 
SRIs.All images are saved in database in Bitmap format without any compression.The source images 
are selected from MDID database[1] and Set 14 database[2].And the source images of MDID database 
are selected from ImageNet[3],SIPI[4],The Images of Groups Dataset[5],The Oxford Buildings Dataset[6],
DIP/e[7],and CSIQ[8].Three magnification scales are introduced to obtain the SRIs, including 2 times,3 
times,4 times.And twenty-one image super-resolution methods are applied to obtain the SRIs.The SRI 
names are organized in such a manner that the index of the source image, then the magnification 
number, and, finally, the index of super-resolution method: "imgXX_Y_ZZ.bmp". For example, the 
name "img03_2_08.bmp" means the 3-rd source image upscaled 2 times by the 8-th image super-
resolution method.

The file ¡®mos.txt¡¯ contains the Mean Opinion Score from subjective evaluations.Higher value 
of MOS (0 - minimal, 1 - maximal) corresponds to higher visual quality of the image.

The file ¡®mos_std.txt¡¯ contains the standard deviation of MOS. 

The file ¡®mos_with_names.txt¡¯ contains each mos corresponding to the super-resolved image.

We kindly inform you that any use of the images in QADS must respect the corresponding 
¡®terms of uses¡¯ as claimed in [1-8].  

All rights of the QADS Database are reserved. The database is only available for academic research 
and noncommercial purposes. Any commercial uses of this database are strictly prohibited.

If you have any questions, please feel free to contact Fei Zhou(flying.zhou@163.com). 

[1]Sun W, Zhou F, Liao Q. MDID: A multiply distorted image database for image quality 
    assessment[J]. Pattern Recognition, 2016, 61:153-168.
[2] Set 14: [Online]. Available: https://sites.google.com/site/romanzeyde/research-interests
[3] ImageNet: [Online]. Available: http://image-net.org/download-images
[4] SIPI: The USC-SIPI Image Database, [Online]. Available: http://sipi.usc.edu/database/
[5] A. Gallagher, T. Chen, ¡°Understanding Groups of Images of People,¡± IEEE Conference on 
    Computer Vision and Pattern Recognition, 2009.
[6] Philbin, J. , Chum, O. , Isard, M. , Sivic, J. and Zisserman. A, ¡°Object retrieval with 
    large vocabularies and fast spatial matching,¡± Proceedings of the IEEE Conference on 
    Computer Vision and Pattern Recognition, 2007.
[7] Rafael C. Gonzalez, Richard E. Woods, Didital Image Processing, Third edition, Beijing: 
    Publishing House of Electronics Industry, 2011
[8] E. C. Larson and D. M. Chandler, ¡°Most apparent distortion: Full-reference image quality 
    assessment and the role of strategy,¡± J. Electron. Imaging, vol. 19, no. 1, pp. 011006-1¨C
    011006-21, Jan. 2010.