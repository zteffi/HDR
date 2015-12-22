close all

I1 = imread('Img/1.jpg');
I2 = imread('Img/2.jpg');
I3 = imread('Img/3.jpg');

inf1 = imfinfo('Img/1.jpg');
inf2 = imfinfo('Img/2.jpg');
inf3 = imfinfo('Img/3.jpg');

Imgs = zeros(3,size(I1,1),size(I1,2),size(I1,3));
Imgs(1,:,:,:) = I1;
Imgs(2,:,:,:) = I2;
Imgs(3,:,:,:) = I3;
logExps = [log(inf1.DigitalCamera.ExposureTime),...
    log(inf2.DigitalCamera.ExposureTime),...
    log(inf3.DigitalCamera.ExposureTime)];
%%
E = illuminationMap(Imgs, logExps);
%%
I = normalizeToneMap(E);
figure;imshow(I),title('Nomalization');
I = durand02(I);