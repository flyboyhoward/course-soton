
loadimagesets %load both training and testing image sets
run('vlfeat-0.9.21\toolbox\vl_setup')
train_number = 100;  %set number of training images in each category

% create bag of visual words
numClusters = 1000;  %number of clusters
gridStep = 4;
patchsize = 8;
imgBow =[];

for i = 1:15
    for j = 1:train_number
        num = (i-1)*train_number + j;
        imgRead = read(imgSets_train(i),j);
        imgbow = bow(imgRead, gridStep, patchsize);
        imgBow = cat(1, imgBow, imgbow);
        disp(num); %visualize data preparation progress
    end
end
disp('bag of visual words created');
imgBow = imgBow';
[centers, assignments] = vl_kmeans(imgBow, numClusters, 'verbose');
disp(' computing centers of clusters complete');

%create taining data
X_train = zeros(train_number*15,numClusters);
Y_train = cell(15*train_number,1);

for i = 1:15
    for j = 1:train_number
        num = (i-1)*train_number + j;
        imgRead = read(imgSets_train(i),j);
        imgbow = bow(imgRead, gridStep, patchsize);
        imgBowi = imgbow';
        
        for col = 1:length(imgBowi)
            [~, k] = min(vl_alldist(imgBowi(:,col), centers));
            X_train(num, k) = X_train(num, k) + 1;
        end
        Y_train{num} = classname{i};
        disp(num); %visualize training progress
    end
end
disp(' map taining data complete');

%{ train set of SVM
SVMModel = fitcecoc(X_train, Y_train,'Learners', 'Linear', 'Coding', 'onevsall','ClassNames',classname);%,'Learners',t,'ClassNames',classname

test
%{
% test correction rate on the rest of training set
disp('testing...');
correct = 0;

for i = 1:15
    for j = train_number+1:classimages
        X_test = zeros(1, numClusters);
        imgTest = read(imgSets_train(i),j);
        imgbow = bow(imgRead, gridStep, patchsize);
        imgBowi = imgbow';
        imgTest_class = 'unknown';
        
        for col = 1:length(imgBowi)
            [~, k] = min(vl_alldist(imgBowi(:,col), centers));
            X_test(1, k) = X_test(1, k) + 1;
        end
        for svmi = 1:numel(classes)
            label = predict(SVMModels{svmi},X_test); %test predict
            if label == 1
                imgTest_class = classname{svmi};
            end
        end
        
        if strcmp(imgTest_class,classname{i}) % for evaluate
            correct = correct + 1;
        end
    end
end
rate = correct/(15*(100-train_number))
%}
% test on testing set & write classification result into run2.txt file

fileID = fopen('run2.txt', 'w');
len = length(imgTest_name);
for testi = 1:len
    X_test = zeros(1, numClusters);
    imgTest = imread(fullfile(imgPath_test, imgTest_name{testi}));
    imgbow = bow(imgRead, gridStep, patchsize);
    imgBowi = imgbow';

    for col = 1:length(imgBowi)
        [~, k] = min(vl_alldist(imgBowi(:,col), centers));
        X_test(1, k) = X_test(1, k) + 1;
    end
    imgTest_class = predict(SVMModel,X_test);
    fprintf(fileID,'%s %s\n',char(imgTest_name{testi}),char(imgTest_class));
end
fclose(fileID);
