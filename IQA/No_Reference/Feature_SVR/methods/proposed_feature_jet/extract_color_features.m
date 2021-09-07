%% ================================================================
%
% get_Invariance_Descriptors() evaluates color invariance descriptor maps 
% from provided input image
% This code was obtained from http://lear.inrialpes.fr/people/vandeweijer/research .
%
%============================================================================
function [im_s, im_h, im_ox, im_oy, im_ax, im_sx] = extract_color_features(in,sig)

    if(nargin == 1)
        sig = 1;
    end

    R=double(in(:,:,1));
    G=double(in(:,:,2));
    B=double(in(:,:,3));

    im_s = 1 - ((3*(min(min(R,G),B)) ./ (R + G + B + eps)));
    
    im_h = atan2((R-G)/sqrt(2),(R+G-(2*B))/sqrt(6));
    im_h(im_h < 0) = im_h(im_h < 0) + (2*pi);
    im_h(isnan(im_h)) = 0;  

    sigma = sig;
    Rx=gDer(R,sigma,1,0);   %R=gDer(R,sigma,0,0);
    Gx=gDer(G,sigma,1,0);   %G=gDer(G,sigma,0,0);
    Bx=gDer(B,sigma,1,0);   %B=gDer(B,sigma,0,0);    
    Ry=gDer(R,sigma,0,1);   %R=gDer(R,sigma,0,0);
    Gy=gDer(G,sigma,0,1);   %G=gDer(G,sigma,0,0);
    By=gDer(B,sigma,0,1);   %B=gDer(B,sigma,0,0);    

    
    f_O1_x = (Rx-Gx)/sqrt(2);
    f_O2_x = (Rx+Gx-2*Bx)/sqrt(6);
    im_ox = atan2(f_O1_x,f_O2_x);
    im_ox(im_ox < 0) = im_ox(im_ox < 0) + (2*pi);
    im_ox(isnan(im_ox)) = 0;      

    f_O1_y = (Ry-Gy)/sqrt(2);
    f_O2_y = (Ry+Gy-2*By)/sqrt(6);
    im_oy = atan2(f_O1_y,f_O2_y);
    im_oy(im_oy < 0) = im_oy(im_oy < 0) + (2*pi);
    im_oy(isnan(im_oy)) = 0;      
    
    t_01_x = (Gx.*R - Rx.*G) ./ sqrt(R.*R + G.*G + eps);
    t_02_x = (Rx.*R.*B + Gx.*G.*B - Bx.*R.*R - Bx.*G.*G) ./ sqrt((R.*R + G.*G + eps) .* (R.*R + G.*G + B.*B + eps));
    im_ax = atan2(t_01_x,t_02_x);
    im_ax(im_ax < 0) = im_ax(im_ax < 0) + (2*pi);
    im_ax(isnan(im_ax)) = 0;      
    
    shx = (R.*(Bx-Gx)+G.*(Rx-Bx)+B.*(Gx-Rx))./sqrt(2*(R.^2+G.^2+B.^2-R.*G-R.*B-G.*B));
    sx = (R.*(2*Rx-Gx-Bx)+G.*(2*Gx-Rx-Bx)+B.*(2*Bx-Rx-Gx))./sqrt(6*(R.^2+G.^2+B.^2-R.*G-R.*B-G.*B));
    im_sx = atan2(shx,sx);
    im_sx(im_sx < 0) = im_sx(im_sx < 0) + (2*pi);
    im_sx(isnan(im_sx)) = 0;      
    
    
end

%% ================================================================
%
% get_circ_diff() evaluates difference in angle. Output lies within [-pi pi)
%
%============================================================================
function diffA = get_circ_diff(A1, A2)
    diffA = A1 - A2;
    diffA(diffA >= pi) = diffA(diffA >= pi) - (2*pi); 
    diffA(diffA < -pi) = diffA(diffA < -pi) + (2*pi);
end

%% ================================================================
%
% get_circ_kurtosis() evaluates circular kurtosis of input angular samples
%
%============================================================================
function c_kurt = get_circ_kurtosis(theta)
    cosI1 = sum(cos(theta(:))); 
    sinI1 = sum(sin(theta(:)));
    mu    = atan2(sinI1,cosI1);
    c_kurt = sum(cos(2*get_circ_diff(theta,mu))) / numel(theta);

end


%% ================================================================
%
% circ_wcpar_estimate() computes the wrapped Cauchy distribution parameters
% from provided samples
%
%============================================================================
function [a, rho] = circ_wcpar_estimate(alpha)

    alpha = alpha(:);

    % Initialize two variables
    u1 = 0.3; u2 = 0.3;

    thres = 0.000001;
    k = 0;
    while (k < 500)  
        mu1 = u1;
        mu2 = u2;
        w = 1./(1 - mu1*cos(alpha) - mu2*sin(alpha) + eps);
        num1 = w.*cos(alpha);
        num2 = w.*sin(alpha);    
        u1 = sum(num1(:))/sum(w(:));
        u2 = sum(num2(:))/sum(w(:));
        k = k + 1;
        if ((abs(u1-mu1)< thres) && (abs(u2-mu2)< thres))
            break;
        end
    end
    if k == 500
        error('data do not converge');
    end

    a = atan2(u2,u1); 
    
    rho = (1 - sqrt(1 - u1^2 - u2^2))/sqrt(u1^2 + u2^2);
end

%% ================================================================
%
% estimateaggdparam() computes the assymetric generalized Gaussian distribution 
% parameters from provided samples
%
%   This code makes use of the 'BRISQUE Software Release' implementation by Anish Mittal. 
%   (http://live.ece.utexas.edu/research/quality/BRISQUE_release.zip)
%
%============================================================================
function [alpha, leftstd, rightstd] = estimateaggdparam(vec)
    gam   = 0.2:0.001:10;
    r_gam = ((gamma(2./gam)).^2)./(gamma(1./gam).*gamma(3./gam));

    leftstd            = sqrt(mean((vec(vec<0)).^2));
    rightstd           = sqrt(mean((vec(vec>0)).^2));
    gammahat           = leftstd/rightstd;
    rhat               = (mean(abs(vec)))^2/mean((vec).^2);
    rhatnorm           = (rhat*(gammahat^3 +1)*(gammahat+1))/((gammahat^2 +1)^2);
    [min_difference, array_position] = min((r_gam - rhatnorm).^2);
    alpha              = gam(array_position);
end

%% ================================================================
%
% estimateggdparam() computes generalized Gaussian distribution parameters
% from provided samples
%
%   This code makes use of the 'BRISQUE Software Release' implementation by Anish Mittal. 
%   (http://live.ece.utexas.edu/research/quality/BRISQUE_release.zip)
%
%============================================================================
function [gamparam, sigma] = estimateggdparam(vec)
    gam                              = 0.2:0.001:10;
    r_gam                            = (gamma(1./gam).*gamma(3./gam))./((gamma(2./gam)).^2);

    sigma_sq                         = mean((vec).^2);
    sigma                            = sqrt(sigma_sq);
    E                                = mean(abs(vec));
    rho                              = sigma_sq/E^2;
    [min_difference, array_position] = min(abs(rho - r_gam));
    gamparam                         = gam(array_position);  
end

%% ================================================================
%
% gDer() computes Gaussian derivatives
%
%   This code makes use of the 'Color Descriptor' implementation by Joost van de Weijer. 
%   (http://cat.uab.es/~joost/software.html)
%
%============================================================================
function [H]= gDer(f,sigma, iorder,jorder)
    % compute Gaussian derivatives

    break_off_sigma = 3.;
    filtersize = floor(break_off_sigma*sigma+0.5);

    f=fill_border(f,filtersize);

    x=-filtersize:1:filtersize;

    Gauss=1/(sqrt(2 * pi) * sigma)* exp((x.^2)/(-2 * sigma * sigma) );

    switch(iorder)
    case 0
        Gx= Gauss/sum(Gauss);
    case 1
        Gx  =  -(x/sigma^2).*Gauss;
        Gx  =  Gx./(sum(sum(x.*Gx)));
    case 2
        Gx = (x.^2/sigma^4-1/sigma^2).*Gauss;
        Gx = Gx-sum(Gx)/size(x,2);
        Gx = Gx/sum(0.5*x.*x.*Gx);
    end
    H = filter2(Gx,f);

    switch(jorder)
    case 0
        Gy= Gauss/sum(Gauss);
    case 1
        Gy  =  -(x/sigma^2).*Gauss;
        Gy  =  Gy./(sum(sum(x.*Gy)));
    case 2
        Gy = (x.^2/sigma^4-1/sigma^2).*Gauss;
        Gy = Gy-sum(Gy)/size(x,2);
        Gy = Gy/sum(0.5*x.*x.*Gy);
    end
    H = filter2(Gy',H);

    H=H(filtersize+1:size(H,1)-filtersize,filtersize+1:size(H,2)-filtersize);
end

function out=fill_border(in,bw)

    hh=size(in,1);
    ww=size(in,2);
    dd=size(in,3);

    if(dd==1)
        out=zeros(hh+bw*2,ww+bw*2);

        out(1:bw,1:bw)=ones(bw,bw).*in(1,1);
        out(bw+hh+1:2*bw+hh,1:bw)=ones(bw,bw).*in(hh,1);
        out(1:bw,bw+1+ww:2*bw+ww)=ones(bw,bw).*in(1,ww);
        out(bw+hh+1:2*bw+hh,bw+1+ww:2*bw+ww)=ones(bw,bw).*in(hh,ww);
        out( bw+1:bw+hh,bw+1:bw+ww )= in;
        out(1:bw,bw+1:bw+ww)=ones(bw,1)*in(1,:);
        out(bw+hh+1:2*bw+hh,bw+1:bw+ww)=ones(bw,1)*in(hh,:);
        out(bw+1:bw+hh,1:bw)=in(:,1)*ones(1,bw);
        out(bw+1:bw+hh,bw+ww+1:2*bw+ww)=in(:,ww)*ones(1,bw);
    else
        out=zeros(hh+bw*2,ww+bw*2,dd);
        for ii = 1:dd
            out(1:bw,1:bw,ii)=ones(bw,bw).*in(1,1,ii);
            out(bw+hh+1:2*bw+hh,1:bw,ii)=ones(bw,bw).*in(hh,1,ii);
            out(1:bw,bw+1+ww:2*bw+ww,ii)=ones(bw,bw).*in(1,ww,ii);
            out(bw+hh+1:2*bw+hh,bw+1+ww:2*bw+ww,ii)=ones(bw,bw).*in(hh,ww,ii);
            out( bw+1:bw+hh,bw+1:bw+ww,ii )= in(:,:,ii);
            out(1:bw,bw+1:bw+ww,ii)=ones(bw,1)*in(1,:,ii);
            out(bw+hh+1:2*bw+hh,bw+1:bw+ww,ii)=ones(bw,1)*in(hh,:,ii);
            out(bw+1:bw+hh,1:bw,ii)=in(:,1,ii)*ones(1,bw);
            out(bw+1:bw+hh,bw+ww+1:2*bw+ww,ii)=in(:,ww,ii)*ones(1,bw);
        end
    end
end
