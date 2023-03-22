function [corr, zero_v, zero_h] = asmFastImageCorrelation(im1, im2)

sz = size(im1);
N2 = sz(1)*sz(2);

m = xsum2(im1)/N2;
imm1 = im1 - m;
m = xsum2(im2)/N2;
imm2 = im2 - m;
res = ifft2(fft2(imm1).*conj(fft2(imm2)));
norm = sqrt(xsum2(imm1.^2))*sqrt(xsum2(imm2.^2));
% corr = N2*res/norm;
corr = res/norm;
zero_v = floor((sz(1)-1)/2);
zero_h = floor((sz(2)-1)/2);
corr = circshift(circshift(corr, zero_v, 1), zero_h, 2);

end
