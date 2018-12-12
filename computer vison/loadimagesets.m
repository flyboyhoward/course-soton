%loading training set
imgPath_train = 'training/training/';
imgSets_train = imageSet(imgPath_train,'recursive');
classname = {imgSets_train.Description};
S_train = dir(fullfile(imgPath_train, classname{1}, '*.jpg'));
classimages = length(S_train);
%loading testing set
imgPath_test = 'testing';
imgSets_test = imageSet(imgPath_test, 'recursive');
S_test = dir(fullfile(imgPath_test, '*.jpg'));
disp(['total number of test images are: ',num2str(length({S_test.name}))]);
imgtest_name = {S_test.name};
newCa = reshape(imgtest_name, 2985, 1);
imgTest_name = sort_nat(newCa); %sort image name, because matlab read image based on file create time instead the order in folder