function out = dir_mapR(in_image, in_n_bins)

switch nargin
    case 1
        image = in_image;
        n_bins = 10;
    case 2
        image = in_image;
        n_bins = in_n_bins;
end
if length(size(image))>2 % its RGB
    image = double(rgb2gray(image));
end
[Gmag,Gdir] = imgradient(image);
Gdir_p = Gdir+180; step = 360/n_bins;
v_b = zeros(1, n_bins); v_e = zeros(1, n_bins);
for nth_bin = 1:n_bins
   v_b(nth_bin) = (nth_bin-1)*step;
   v_e(nth_bin) = v_b(nth_bin)+step;
end
out = zeros(size(image));
for direction = 1:n_bins
    indexes = find(Gdir_p <= v_e(direction) & Gdir_p >= v_b(direction));
    out(indexes) = direction;
end

end