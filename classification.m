set(gca, 'YLim', [150 170]);

net.Layers(1)%input of 1st image specification
net.Layers(end)%last image

nume1(net.Layers(end).ClassNames)%numer of classes in network
[trainingset, testset] = splitEachlabel(imds, 0.3,'randomize');%how much dadaset is for training and how much for testing

imagesSize=net.Layers(1).InputSize;%size of input image

augmentTrainingSet=augmentedImageDatastore(imageSize,trainingset ,'colorProcessing','gray2rgb');%conversion of grey image into the RGB image for training dataset

augmentTestSet=augmentedImageDatastore(imageSize,testset ,'colorProcessing','gray2rgb');%conversion of grey image into the RGB image for testing dataset

w1=net.Layers(2).Weights;%weight of a matrics layer w1
W1=mat2gray(w1);

figure
montage(w1)
title('First conovolutional Layer Weight')

featureLayer = 'fc10000' ;
trainingFeatures = activations(net,augmentedTrainingSet , FeatureLayer ,'MiniBatchSize',32,'outputAs','columns');%minibatch creation

trainingLabels = trainingSet.Labels;
classifier = fitcecoc(trainigFeatures, trainingLabels ,'Learner' , 'Liners','coding' , 'onevsall','ObservationsIn', 'colums');%model creation funtion(video)

testFeatures = activations(net,augmentedTestSet , FeatureLayer ,'MiniBatchSize',32,'outputAs','columns');

predictLabels=predic(classifier , testFeature ,'ObservationIn','columns');%level of classifier

testLabels = testSet.Label;

confMat=confusionmat(testLabels,predictLabels );%final confustion matrix
confMat=bsxfun(@rdivide, convfMat, sum(confMat,2));%conversion of matrix in percentage

mean(diag(confMAt));

newImage = imread(fullfile('input image path in png or jpeg format'));

 ds= augmentedImageDatastore(imageSize, newImage ,'colorProcessing','gray2rgb');
 imageFeatures = activations(net,ds , FeatureLayer ,'MiniBatchSize',32,'outputAs','columns');
 labels=predic(classifier , imageFeatures ,'ObservationIn','columns');
 
 sprintf('The loaded image belongs to %s class',label);



