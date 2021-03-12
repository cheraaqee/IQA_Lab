function HHSIM = WS_HV(r_in,d_in, T4_in, T5_in, T6_in, T7_in, T8_in, T9_in)
% WS_HV recieves the luminace channel of two screen content images and returns their
% perceptual similarity as a score in (0, 1].
% This is an unoptimized implementation for the algorithm that is proposed
% in:
% Pooryaa Cheraaqee, Zahra Maviz, Azadeh Mansouri, Ahmand Mahmoudi Aznaveh,
% "Quality Assessment of Screen Content Images in Wavelet Domain," IEEE
% Transactions on Circuits and Systems for Video Technology, 2021
[M, N]=size(r_in);
f = min(3,round(max(M,N)/512));
aa=10*2^(f); % This is going to regulate the constant in the similarity relation. We see that the constant is determied based on the dimension of the images.
switch nargin
    case 2 % apart from the two image, the constant in the six instances of the similarity can be directly input to the algorithm (for experimenting)
        r = r_in;
        d = d_in;
        T4 = 2*aa;
        T9 = 2*aa;
        T8 = aa;
        T5 = aa;
        T6 = 3*aa;
        T7 = 3*aa;
    case 8
        r = r_in;
        d = d_in;
        T4 = T4_in;
        T5 = T5_in;
        T6 = T6_in;
        T7 = T7_in;
        T8 = T8_in;
        T9 = T9_in;
end
if length(size(r))>2 % this check should be omitted for evaluating the time complexity.
    r = double(rgb2gray(r));
    d = double(rgb2gray(d));
end

[rcA,rcH,rcV,rcD]=dwt2(r,'Haar');
[rcA2,rcH2,rcV2,rcD2]=dwt2(rcA,'Haar');
[~,rcH3,rcV3,~]=dwt2(rcA2,'Haar');


[dcA,dcH,dcV,~]=dwt2(d,'Haar');
[dcA2,dcH2,dcV2,dcD2]=dwt2(dcA,'Haar');
[~,dcH3,dcV3,~]=dwt2(dcA2,'Haar');

[X, Y]=size(rcD);
if (mod(X,2)==0)&& (mod(Y,2)==0)
    rHH1=rcD(1:X-1,1:Y-1);
    rh1 =rcH(1:X-1,1:Y-1);
    rv1 =rcV(1:X-1,1:Y-1);
    dh1 =dcH(1:X-1,1:Y-1);
    dv1 =dcV(1:X-1,1:Y-1);
elseif (mod(X,2)==0)
    rHH1=rcD(1:X-1,1:Y);
    rh1 =rcH(1:X-1,1:Y);
    rv1 =rcV(1:X-1,1:Y);
    dh1 =dcH(1:X-1,1:Y);
    dv1 =dcV(1:X-1,1:Y);
elseif (mod(Y,2)==0)
    rHH1=rcD(1:X,1:Y-1);
    rh1 =rcH(1:X,1:Y-1);
    rv1 =rcV(1:X,1:Y-1);
    dh1 =dcH(1:X,1:Y-1);
    dv1 =dcV(1:X,1:Y-1);
else
    rHH1=rcD(1:X,1:Y);
    rh1 =rcH(1:X,1:Y);
    rv1 =rcV(1:X,1:Y);
    dh1 =dcH(1:X,1:Y);
    dv1 =dcV(1:X,1:Y);
end

rHH2=interp2(rcD2,'cubic');
rh2 =interp2(rcH2,'cubic');
rv2 =interp2(rcV2,'cubic');
dHH2=interp2(dcD2,'cubic');
dh2 =interp2(dcH2,'cubic');
dv2 =interp2(dcV2,'cubic');

dh3 =interp2(dcH3,'cubic');
dv3 =interp2(dcV3,'cubic');

rh3 = interp2(rcH3, 'cubic');
rv3 = interp2(rcV3, 'cubic');
dh3 = interp2(dh3, 'cubic');
dv3 = interp2(dv3, 'cubic');
rh3 = interp2(rh3, 'cubic');
rv3 = interp2(rv3, 'cubic');

[a, b]=size(rHH1);
rh3  =imresize(rh3,  [a b]);
rv3  =imresize(rv3,  [a b]);
dh3  =imresize(dh3  ,[a b]);
dv3  =imresize(dv3  ,[a b]);
rh1 =abs(rh1);
rv1 =abs(rv1);
dh1 =abs(dh1);
dv1 =abs(dv1);
rHH2=abs(rHH2);
rh2 =abs(rh2);
rv2 =abs(rv2);
dHH2=abs(dHH2);
dh2 =abs(dh2);
dv2 =abs(dv2);
rh3  =abs(rh3);
rv3  =abs(rv3);
dh3  =abs(dh3);
dv3  =abs(dv3);

h_map3  = (2*rh3.*dh3+T4)./(rh3.^2+dh3.^2+T4);
h_map2  = (2*rh2.*dh2+T5)./(rh2.^2+dh2.^2+T5);
h_map1  = (2*rh1.*dh1+T6)./(rh1.^2+dh1.^2+T6);
v_map1  = (2*rv1.*dv1+T7)./(rv1.^2+dv1.^2+T7);
v_map2  = (2*rv2.*dv2+T8)./(rv2.^2+dv2.^2+T8);
v_map3  = (2*rv3.*dv3+T9)./(rv3.^2+dv3.^2+T9);
HH3m = max(rHH2, dHH2);
SimMatrix = h_map2.*h_map3.*h_map1.*v_map1...
    .*v_map2.*v_map3.*HH3m;
HHSIM = sum(sum(SimMatrix)) / sum(sum(HH3m));
end

