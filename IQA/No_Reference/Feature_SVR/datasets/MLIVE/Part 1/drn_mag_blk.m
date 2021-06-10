function [sim, dev] = drn_mag_blk( in_ref, in_dst,in_dirs, in_bsize,in_T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 5
        ref = in_ref;
        dst = in_dst;
        dirs = in_dirs;
        bsize = in_bsize;
        T = in_T;
    case 4
        ref = in_ref;
        dst = in_dst;
        dirs = in_dirs;
        bsize = in_bsize;
        T = 20;
    case 3
        ref = in_ref;
        dst = in_dst;
        dirs = in_dirs;
        bsize = 5;
        T = 20;
    case 2
        ref = in_ref;
        dst = in_dst;
        dirs = 10;
        bsize = 5;
        T = 20;
        
end
if length(size(ref))>2 % its RGB
    ref = double(rgb2gray(ref));
end
if length(size(dst))>2 % its RGB
    dst = double(rgb2gray(dst));
end
drn_ref = dir_mapR(ref, dirs);
drn_dst = dir_mapR(dst, dirs);

mag_ref = imgradient(ref);
mag_dst = imgradient(dst);


fun=@std2;


drn_dev_ref = blkproc(drn_ref, [bsize bsize], fun);
drn_dev_dst = blkproc(drn_dst, [bsize bsize], fun);

mag_dev_ref = blkproc(mag_ref, [bsize bsize], fun);
mag_dev_dst = blkproc(mag_dst, [bsize bsize], fun);

drn_sim_map = (2*drn_dev_ref.*drn_dev_dst + T) ./...
    (drn_dev_ref.^2+drn_dev_dst.^2 + T);
mag_sim_map = (2*mag_dev_ref.*mag_dev_dst + T) ./...
    (mag_dev_ref.^2+mag_dev_dst.^2 + T);

sim_drn = mean(drn_sim_map(:));
dev_drn = std2(drn_sim_map);
sim_mag = mean(mag_sim_map(:));
dev_mag = std2(mag_sim_map);

sim = power(sim_mag, 1)*power(sim_drn, 1);
dev = power(dev_mag, 1)*power(dev_drn, 1);
end

