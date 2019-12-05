close all;clear;clc
gpuDevice(1);
imgdata = readtable('sorted1120.csv','Delimiter',',');
for i=1:length(imgdata{:,1})
    imgdata{i,2} = {str2double(reshape(strsplit(cell2mat(imgdata{i,2})),4,[])')};
end

%%
rng(0);

shuffledIndices = randperm(height(imgdata));
idx = floor(0.8 * length(shuffledIndices) );
trainingData = imgdata(shuffledIndices(1:idx),:);
testData = imgdata(shuffledIndices(idx+1:end),:);

imdsTrain = imageDatastore(trainingData{:,'fn'});
bldsTrain = boxLabelDatastore(trainingData(:,'zuobiaoxinxi'));

imdsTest = imageDatastore(testData{:,'fn'});
bldsTest = boxLabelDatastore(testData(:,'zuobiaoxinxi'));

trainingData = combine(imdsTrain,bldsTrain);
testData = combine(imdsTest,bldsTest);

%%
inputSize = [224 224 3];
numClasses = 1;
trainingDataForEstimation = transform(trainingData,@(data)preprocessData(data,inputSize));
numAnchors = 7;
[anchorBoxes, meanIoU] = estimateAnchorBoxes(trainingDataForEstimation, numAnchors);
baseNetwork = resnet50;
featureLayer = 'activation_40_relu';
lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,baseNetwork,featureLayer);

%%
augmentedTrainingData = transform(trainingData,@augmentData);
preprocessedTrainingData = transform(augmentedTrainingData,@(data)preprocessData(data,inputSize));
data = read(preprocessedTrainingData);

%%
options = trainingOptions('sgdm', ...
        'MiniBatchSize', 16, ....
        'InitialLearnRate',1e-3, ...
        'MaxEpochs',20,...
        'CheckpointPath', tempdir, ...
        'Shuffle','never');

if doTraining       

    [detector,info] = trainYOLOv2ObjectDetector(preprocessedTrainingData,lgraph,options);

end
model_name = 'detector_yolov2_test1204';
save (model_name, 'detector');
% doTraining = true;
% 
% model_name = 'detector_yolov2_test1204';
% if doTraining
%     options = trainingOptions('sgdm', ...
%         'MiniBatchSize', 2, ....
%         'InitialLearnRate',1e-5, ...
%         'MaxEpochs',10,...
%         'CheckpointPath', tempdir, ...
%         'Shuffle','every-epoch');    
%     tic;
%     [detector,info] = trainYOLOv2ObjectDetector(trainingData,lgraph,options);
%     trainingTime = toc;
%     save (model_name, 'detector','-v7.3');
% end
% 
figure
plot(info.TrainingLoss)
grid on
xlabel('Number of Iterations')
ylabel('Training Loss for Each Iteration')

%%
% preprocessedTestData = transform(testData,@(data)preprocessData(data,inputSize));
% detectionResults = detect(detector, preprocessedTestData);
% [ap,recall,precision] = evaluateDetectionPrecision(detectionResults, preprocessedTestData);
% figure
% plot(recall,precision)
% xlabel('Recall')
% ylabel('Precision')
% grid on
% title(sprintf('Average Precision = %.2f',ap))
