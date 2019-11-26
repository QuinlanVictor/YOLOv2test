%%%��֤�Ĳ��Գ���1118
close all;clear;clc;
gpuDevice(1);

diary 'log1121.txt'
showtime;

load detector_yolov2_test1120.mat
test_image_folder = uigetdir('E:\Study\Research\Data\Result\LIDC\testdata\testimg');%���Լ�λ��
test_output_folder = 'E:\Study\Research\Data\Result\LIDC\testdata\output\output141-1121';%���ͼƬλ��
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
    [bboxes,scores,labels] = detect(detector,I); %original = 0.5����׼ȷ����ֵ
    [bboxes,scores,labels] = selectStrongestBboxMulticlass(bboxes, scores, labels, ...
                'RatioType','Union', ... %original = 'Union'�߿��ص��ȷ�ĸ��'Union'�Խ����ʼ���ΪbboxA��֮����ཻ���bboxB�������ߵĲ������
                'OverlapThreshold',0.01); %original = 0.01�ص�����ֵ 0.5Ĭ��
   
    if ~isempty(labels)
        I = insertObjectAnnotation(I,'rectangle',bboxes,scores,'LineWidth',3); %original=scores
    end

    
    [folder,output_base_name] = fileparts(fullFileName);
    imwrite(I,[test_output_folder,'/',output_base_name,'_output','.jpg']);
    fprintf(1, 'Processing time = %.3f seconds; Writing file %s\n', toc, [test_output_folder,'/',output_base_name,'_output','.png']);
end
showtime;
diary off