
loadimagesets
imds = imageDatastore('training/training/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames'); % load image set and labels
[trainingSet, testSet] = splitEachLabel(imds, 0.8, 'randomize');

net = resnet50() ; % resnet50()is the best network in compete with others like inceptionresnetv2()
net.Layers(end)
imageSize = net.Layers(1).InputSize; % get input image parameter of resnet50,  size = [224 224 3]
augmentedTrainingSet = augmentedImageDatastore(imageSize, imds, 'ColorPreprocessing', 'gray2rgb'); % reszie image and transfer it to rgb 
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');

featureLayer = 'fc1000';    %name of feature layer
%traing, in the last traning we use all images in training set to get best performance of feawture extraction
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
trainingLabels = imds.Labels;
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');% classifer parameter
disp('training classifier complete')

%test accuracy on test set 
%testFeatures = activations(net, augmentedTestSet, featureLayer, ...
%    'MiniBatchSize', 32, 'OutputAs', 'columns');
%predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');
%testLabels = testSet.Labels;
%accuracy = mean(predictedLabels == testLabels)

% test on testing set & write classification result into run3.txt file
fileID = fopen('run3.txt', 'w');
len = length(imgTest_name);
for testi = 1:len
    imgTest = imread(fullfile(imgPath_test, imgTest_name{testi}));
    ds = augmentedImageDatastore(imageSize, imgTest, 'ColorPreprocessing', 'gray2rgb');
    imageFeatures = activations(net, ds, featureLayer, 'OutputAs', 'columns');
    predictedLabels = predict(classifier, imageFeatures, 'ObservationsIn', 'columns');
    fprintf(fileID,'%s %s\n',char(imgTest_name{testi}),char(predictedLabels));
end
fclose(fileID);

%}