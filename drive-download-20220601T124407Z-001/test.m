clc;    
close all;  
clear;  
workspace; 
format long g;
format compact;
fontSize = 20;
% Get the name of the image the user wants to use.

baseFileName = 'scr.png';
% baseFileName = 'sc4.jpg';
% Get the full filename, with path prepended.
folder = pwd;
fullFileName = fullfile(folder, baseFileName);



%===========================================================================================================
% Read in a demo image.
% grayImage = dicomread(fullFileName);
grayImage = imread('scr.png');
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorChannels] = size(grayImage);
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale by taking only the green channel.
	grayImage = grayImage(:, :, 1); % Take green channel.
end
% Display the image.
subplot(2, 3, 1);
imshow(grayImage, []);
axis on;
caption = sprintf('Original Grayscale Image\n%s', baseFileName);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo();
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Skull Removal', 'NumberTitle', 'Off') 

% Make the pixel info status line be at the top left of the figure.
hp.Units = 'Normalized';
hp.Position = [0.01, 0.97, 0.08, 0.05];

%===========================================================================================================
% Display the histogram so we can see what gray level we need to threshold it at.
subplot(2, 3, 2:3);
% For this image, there is a huge number of black pixels with gray level less than about 11,
% and that makes a huge spike at the first bin.  Ignore those pixels so we can get a histogram of just non-zero pixels.
% histObject = histogram(grayImage(grayImage >= 11))
[pixelCounts, grayLevels] = imhist(grayImage, 256);
faceColor = [0, 60, 190]/255; % Our custom color - a bluish color.
bar(grayLevels, pixelCounts, 'BarWidth', 1, 'FaceColor', faceColor);
% Find the last gray level and set up the x axis to be that range.
lastGL = find(pixelCounts>0, 1, 'last');
xlim([0, lastGL]);
grid on;
% Set up tick marks every 50 gray levels.
ax = gca;
ax.XTick = 0 : 50 : lastGL;
title('Histogram of Non-Black Pixels', 'FontSize', fontSize, 'Interpreter', 'None', 'Color', faceColor);
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Counts', 'FontSize', fontSize);
drawnow;

%===========================================================================================================
% Threshold the image to make a binary image.
thresholdValue = 55;
binaryImage = grayImage > thresholdValue;
% If it's a screenshot instead of an actual image, the background will be a big square, like with image sc4.
% So call imclearborder to remove that.
% If it's not a screenshow (which it should not be, you can skip this step).
%binaryImage = imclearborder(binaryImage);
% Display the image.
subplot(2, 3, 4);
imshow(binaryImage, []);
axis on;
caption = sprintf('Initial Binary Image\nThresholded at %d Gray Levels', thresholdValue);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

%===========================================================================================================
% Extract the two largest blobs, which will either be the skull and brain,
% or the skull/brain (if they are connected) and small noise blob.
binaryImage = bwareafilt(binaryImage, 2);		% Extract 2 largest blobs.
% Erode it a little with imdilate().
binaryImage = imopen(binaryImage, true(5));
% Now brain should be disconnected from skull, if it ever was.
% So extract the brain only - it's the largest blob.
binaryImage = bwareafilt(binaryImage, 1);		% Extract largest blob.
% Fill any holes in the brain.
binaryImage = imfill(binaryImage, 'holes');
% Dilate mask out a bit in case we've chopped out a little bit of brain.
binaryImage = imdilate(binaryImage, true(5));

% Display the final binary image.
subplot(2, 3, 5);
imshow(binaryImage, []);
axis on;
caption = sprintf('Final Binary Image\nof Skull Alone');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

%===========================================================================================================
% Mask out the skull from the original gray scale image.
skullFreeImage = grayImage; % Initialize
skullFreeImage(~binaryImage) = 0; % Mask out.
% Display the image.
subplot(2, 3, 6);
imshow(skullFreeImage, []);
axis on;
caption = sprintf('Gray Scale Image\nwith Skull Stripped Away');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

