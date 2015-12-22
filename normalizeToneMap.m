function [ I ] = normalizeToneMap(E)
chanCount = size(E,3);
emax = squeeze(max(max(E)))'; % vector of largest elements in each channel
emin = squeeze(min(min(E)))'; % vector smallest elements in each channel

I = zeros(size(E));
erange = emax - emin;
for c = 1: 3
    I(:,:,c) = (E(:,:,c) - emin(c))/erange(c);
end
%I = uint8(I*255);