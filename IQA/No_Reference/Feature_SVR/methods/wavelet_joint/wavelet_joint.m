function out = wavelet_joint(imd)

[cA,cH,cV,cD]=dwt2(imd,'Haar');
[cA2,cH2,cV2,cD2]=dwt2(cA,'Haar');
 
[X Y]=size(cD);
if (mod(X,2)==0)&& (mod(Y,2)==0)
HH1=cD(1:X-1,1:Y-1);
elseif (mod(X,2)==0)
        HH1=cD(1:X-1,1:Y);
elseif (mod(Y,2)==0)
              HH1=cD(1:X,1:Y-1);
else
    HH1=cD(1:X,1:Y);
end

HH2=interp2(cD2,'cubic');

HH1=abs(HH1);
% 

HH2=abs(HH2);

ratio=3;
HH2 = abs(HH2/(ratio));


sigma = 0.75;

 c0=0.25;
sigmaN = 2*sigma;
window1 = fspecial('gaussian',2*ceil(2*sigmaN)+1, sigmaN);%3*sigmaN
window1 = window1/sum(window1(:));
Nmap = sqrt(filter2(window1,mean(cat(3,HH2,HH1).^2,3),'same'))+c0;

% Nmap1=sqrt(mean(cat(3,HH2,HH1).^2,3))+c0;
   HH2 = (HH2)./Nmap;
   HH1 = (HH1)./Nmap;
% remove the borders, which may be the wrong results of a convolution
% operation
h = ceil(2*sigmaN);
HH2 = abs(HH2(h:end-h+1,h:end-h+1,:));
HH1 = abs(HH1(h:end-h+1,h:end-h+1));

ctrs{1} = 1:8;ctrs{2} = 1:8;
% histogram computation
step1 = 0.4;
step2 = 0.4;
HH2_qun = ceil(HH2/step1);
HH1_im_qun = ceil(HH1/step2);

N1 = hist3([HH2_qun(:),HH1_im_qun(:)],ctrs);
%hist3([grad_qun(:),log_im_qun(:)],ctrs);
N1 = N1/sum(N1(:));
NHH2 = sum(N1,2); NHH1 = sum(N1,1);

alpha1 = 0.0001;
% condition probability: Grad conditioned on LOG
cp_GL = N1./(repmat(NHH1,size(N1,1),1)+alpha1);
cp_GL_H=  sum(cp_GL,2)';
cp_GL_H = cp_GL_H/sum(cp_GL_H);
% condition probability: LOG conditioned on Grad
cp_LG = N1./(repmat(NHH2,1,size(N1,2))+alpha1);
cp_LG_H = sum(cp_LG,1);
cp_LG_H = cp_LG_H/(sum(cp_LG_H));

out = [NHH2', NHH1, cp_GL_H,cp_LG_H];


