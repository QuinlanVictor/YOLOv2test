%聚类预测anchor boxes
close all;clear;clc;
allBoxes=csvread('test1.csv',1,1);%直接读取下x,y,w,h信息

numAnchors = 3;

% Cluster using K-Medoids.
[clusterAssignments, anchorBoxes, sumd] = kmedoids(allBoxes(:,3:4),numAnchors,'Distance',@iouDistanceMetric);

% Display estimated anchor boxes. The box format is the [width height].
anchorBoxes
