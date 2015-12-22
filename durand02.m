function [I] = durand02(I)
I = rgb2ycbcr(I);
C = I(:,:,1);
Cbase = bfilter2(C,[2, 2], .3);
Cdetail = C - Cbase;


%% reinhard
lumOriginal = Cbase;
epsilon = 0.00001;
logImg = log(lumOriginal + epsilon);
logAvgLum = exp(mean(mean(logImg)));
lumKeyMapped = (0.18 ./ logAvgLum) .* lumOriginal;
Cbase = lumKeyMapped ./ (1.0 + lumKeyMapped);

%%
C = Cdetail + Cbase;
I(:,:,1) = Cdetail + Cbase;
I = ycbcr2rgb(I);
I = normalizeToneMap(I);
end

