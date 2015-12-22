function [E] = illuminationMap(Imgs, logExposure)
%% 1. Zistite krivku odozvy kamery z LDR obrázkov
tic;
SAMPLE_SIZE = 3500;
LAMBDA = 2; %(.1,5);
[photoCount, rowCount, colCount, channelCount] = size(Imgs);
perm = randperm(rowCount*colCount,SAMPLE_SIZE);
[rows,cols] = ind2sub(rowCount, perm);

Z = zeros(SAMPLE_SIZE, photoCount,channelCount);

for i = 1:SAMPLE_SIZE
    for j = 1:photoCount
        for c = 1:channelCount
            Z(i,j,c) = Imgs(j,rows(i),cols(i),c);
        end
    end
end
g = zeros(256,channelCount);
for c = 1:channelCount
[g(:,c), ~] = gsolve(Z(:,:,c), logExposure, LAMBDA);
end

meanLogExposure = mean(logExposure);

d = 0:255;
figure; plot(g(:,2), d); title('Krivka Odozvy');
toc;
tic;
%% 2. Vytvorte mapu osvetlenia sceny
logE = mean(Imgs) - meanLogExposure;

E = squeeze(logE);
toc;
end