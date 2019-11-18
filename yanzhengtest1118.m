%%%验证的测试程序1118
close all;clear;clc;
gpuDevice(1);

diary 'log1118.txt'

load detector_yolov2_test1113.mat
test_image_folder = uigetdir('E:\Study\Research\Data\Result\LIDC\testdata');%测试集位置
test_output_folder = 'E:\Study\Research\Data\Result\LIDC\testdata\output';%输出图片位置
test_files = dir(test_image_folder);

if ~isfolder(test_output_folder)
    fprintf(1, 'Making directory %s\n', test_output_folder);
    mkdir(test_output_folder);
end


for k = 3 : length(test_files)

    baseFileName = test_files(k).name;
    fullFileName = fullfile(test_image_folder, baseFileName);
    tic;
    I = imread(fullFileName);
    [bboxes,scores,labels] = detect(detector,I,'Threshold',0.5); %original = 0.5分类准确度阈值
    [bboxes,scores,labels] = selectStrongestBboxMulticlass(bboxes, scores, labels, ...
                'RatioType','Union', ... %original = 'Union'边框重叠度分母，'Union'以将比率计算为bboxA和之间的相交面积bboxB除以两者的并集面积
                'OverlapThreshold',0.01); %original = 0.01重叠率阈值 0.5默认
   
    if ~isempty(labels)
        I = insertObjectAnnotation(I,'rectangle',bboxes,scores,'LineWidth',3); %original=scores
    end

    
    [folder,output_base_name] = fileparts(fullFileName);
    imwrite(I,[test_output_folder,'/',output_base_name,'_output','.jpg']);
    fprintf(1, 'Processing time = %.3f seconds; Writing file %s\n', toc, [test_output_folder,'/',output_base_name,'_output','.png']);
end

diary off
