clc; 
outputFolder=fullfile('Data2');%to create file path of dataset folder in variable
rootFolder=fullfile(outputFolder,'brain_tumor_dataset');

categories = {'yes','no'};%image categories

imds = imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');%images in above categories loded in imds with label
%imagedatastore has 2 argments "fullfile(rootFolder,categories" it is
%location of images and "LabelSource','foldernames" name and value pair
%name is labelsoure and valre is foldername images will be labeled as thier
%foldernames

tbl = countEachLabel(imds);%count images in folder
%no of images per category are not same it will cause prb so make them
%same
minSetCount = min(tbl{:,2});%gets min value from 2nd column of tbl
%so reduce the images per category to min value


imds = splitEachLabel(imds, minSetCount,'randomize'); %select random images from imds 
countEachLabel(imds);

yes = find(imds.Labels == 'yes',1);%find images from imds with label yes and sequence 1
no = find(imds.Labels == 'no',1);

figure
subplot(1,2,1);
imshow(readimage(imds,yes));
subplot(1,2,2);
imshow(readimage(imds,no));

net=resnet50();
figure
plot(net)
plot('arch of resnet');


