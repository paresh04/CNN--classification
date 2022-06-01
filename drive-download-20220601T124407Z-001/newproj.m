clc;
close all;

I=imread('D:\Softwares\Matlab 2019\bin\YS7.jpeg');
figure
subplot(3,5,1),imshow(I)
title('Original Image')
gmag = imgradient(I);
%gradient of image is obtained with the help  of edge detection, sobel
%operator is used by default
subplot(3,5,2),imshow(gmag,[])
title('Gradient Magnitude')
se = strel('disk',20);
%creates structuring element for morphological operations of opening and
%closing which is in a shape of disk, 20 is the radius in pixels
Io = imopen(I,se);
%pixels are added to blur the image
subplot(3,5,3)
imshow(Io)
title('Opening')
Ie = imerode(I,se);
%the pixels are removed from the image
Iobr = imreconstruct(Ie,I);
%the final aim of this opening,closing opeing closing operation is to
%smoothen the image
subplot(3,5,4)
imshow(Iobr)
title('Opening-by-Reconstruction')
Ioc = imclose(Io,se);
subplot(3,5,5)
imshow(Ioc)
title('Opening-Closing')
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
%image complement 
subplot(3,5,6)
imshow(Iobrcbr)
title('Opening-Closing by Reconstruction')
fgm = imregionalmax(Iobrcbr);
%returns the maxima in an image
subplot(3,5,7)
imshow(fgm)
title('Regional Maxima')
I2 = labeloverlay(I,fgm);
%imposes one image over other using labeloverlay function
subplot(3,5,8)
imshow(I2)
title('Regional Maxima Superimposed')
se2 = strel(ones(3,3));
%strel is a structuring element, here we create a matrix of ones, 3*3
%matrix
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);
fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
%regional image is smoothened
subplot(3,5,9)
imshow(I3)
title('Modified Regional Maxima')
bw = imbinarize(Iobrcbr,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
%thresholding of the image to obtain the maxima and minima of the image
subplot(3,5,10)
imshow(bw)
title('Thresholded Opening-Closing')
D = bwdist(bw);
%distance transform is taken to reverse the image maxima and minima
DL = watershed(D);
bgm = DL == 0;
%subplot(3,5,10)
%imshow(bgm)
%title('Watershed Ridge Lines')
gmag2 = imimposemin(gmag,bgm | fgm4);
%here we obtain the regional minima of our requiered area which is to be
%segmentated, imimposemin overlays the minima
L = watershed(gmag2);
labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);
subplot(3,5,11)
imshow(I4)
title('Markers and Object Boundaries Superimposed')
Lrgb = label2rgb(L,'jet','w','shuffle');
subplot(3,5,13)
imshow(Lrgb)
title('Colored Watershed Label Matrix')
subplot(3,5,15)
imshow(I)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Colored Labels Superimposed Transparently')


