imds = imageDatastore('training/training/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[trainingImages, testImages] = splitEachLabel(imds, 0.8, 'randomize');

% Set the ImageDatastore ReadFcn
imds.ReadFcn = @(filename)readAndPreprocessImage2(filename);
trainingImages.ReadFcn = @readAndPreprocessImage2;
testImages.ReadFcn = @readAndPreprocessImage2;

net = alexnet;
layers = net.Layers

layers(23) = fullyConnectedLayer(15); % modify layers to fit this classification
layers(25) = classificationLayer

opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 32,...
                'ExecutionEnvironment', 'cpu', 'Plots','training-progress');

myNet = trainNetwork(imds, layers, opts);
%predictedLabels = classify(myNet, testImages);
%accuracy = mean(predictedLabels == testImages.Labels)


file_eval = fopen('label.txt','r');
imgPath_test = 'test';
imgSets_test = imageSet(imgPath_test, 'recursive');
S_test = dir(fullfile(imgPath_test, '*.jpg'));
disp(['total number of test images are: ',num2str(length({S_test.name}))]);
imgtest_name = {S_test.name};
newCa = reshape(imgtest_name, length({S_test.name}), 1);
imgTest_name = sort_nat(newCa);
len = length(imgTest_name);
correct = 0;
for testi = 1:len
    imgTest = readAndPreprocessImage2(fullfile(imgPath_test, imgTest_name{testi}));
    tline = fgetl(file_eval);
    linei = strsplit(tline);
    classi = linei{2};
    predictedLabels = classify(myNet, imgTest);
    if predictedLabels == classi
        correct = correct + 1;
    end
end
fclose(file_eval);
rate = correct/len
% test on testing set & write classification result into run2.txt file
%{
fileID = fopen('run3.txt', 'w');
len = length(imgTest_name);
for testi = 1:len
    imgTest = readAndPreprocessImage(fullfile(imgPath_test, imgTest_name{testi}));
    tline = fgetl(file_eval);
    linei = strsplit(tline);
    classi = linei{2};
    predictedLabels = classify(myNet, imgTest);

    fprintf(fileID,'%s %s\n',char(imgTest_name{testi}),char(imgTest_class));
end
fclose(fileID);
%}