% KNN classification
loadimagesets %load both training and testing image sets
train_number = 100; % for the final train we choose all traing images
Y_train = cell(15*train_number,1); % create training set labels
X_train = zeros(15*train_number,256);% create testing set labels
% load and transfer image into tiny image in each category 
for i = 1:15
    for j = 1:train_number
        num = (i-1)*train_number + j;
        imgRead = read(imgSets_train(i),j);
        X_train(num,:) = X_train(num,:) + tinyimage(imgRead);
        Y_train{num} = classname{i};  
    end
end
% training knn modle 
knnmodel = fitcknn(X_train,Y_train,'NSMethod','exhaustive',...
    'Distance','correlation','DistanceWeight','squaredinverse',...
    'NumNeighbors',12) % choose optimal neighbors and fitfunction paprameter
rloss = resubLoss(knnmodel) %compute loss of this model

%{
% test correction rate on the rest of training set
disp('testing...');
correct = 0;
for i = 1:15
    for j = train_number+1:classimages
        imgTest = read(imgSets_train(i),j);
        imgtest = tinyimage(imgTest);
        imgTest_class = predict(knnmodel, imgtest);
        if strcmp(imgTest_class,classname{i})
            correct = correct + 1;
        end
    end
end
rate = correct/(15*(100-train_number))
%}

% test on testing set & write classification result into run1.txt file
fileID = fopen('run1.txt', 'w');
len = length(imgTest_name);
for testi = 1:len
    imgTest = imread(fullfile(imgPath_test, imgTest_name{testi}));
    imgtest = tinyimage(imgTest);
    imgTest_class = predict(knnmodel, imgtest);
    fprintf(fileID,'%s %s\n',char(imgTest_name{testi}),char(imgTest_class));
end
fclose(fileID);
disp('writing into run1.txt complete')
%}
