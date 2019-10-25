close all;clear;clc
gpuDevice(1);
GDSDataset = readtable('test1022.csv','Delimiter',',');
for i=1:length(GDSDataset{:,1})
    GDSDataset{i,2} = {str2double(reshape(strsplit(cell2mat(GDSDataset{i,2})),4,[])')};
end

%%
rng(0);

trainingData = GDSDataset;

imageSize = [512 512 3];
numClasses =  width(GDSDataset)-1;
anchorBoxes = [33,31;35,41;24,23];%这应该用聚类预测
baseNetwork = resnet50;
featureLayer = 'activation_40_relu';
lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,baseNetwork,featureLayer);
%%
doTraining = true;%自己修改模型

model_name = 'detector_yolov2_test';
if doTraining
    options = trainingOptions('sgdm', ...
        'MiniBatchSize', 2, ....
        'InitialLearnRate',1e-5, ...
        'MaxEpochs',10,...
        'CheckpointPath', tempdir, ...
        'Shuffle','every-epoch');    
    tic;
    [detector,info] = trainYOLOv2ObjectDetector(trainingData,lgraph,options);
    trainingTime = toc;
    save (model_name, 'detector','-v7.3');
else
    %否则调用已经预训练过的模型
    pretrained = load('standard_cell2_detector_yolov2_0610_epoch50_2.mat');
    detector = pretrained.detector;
end