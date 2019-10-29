%%%读取xls文件并转存对应图片
close all;clear;clc;

[a]=xlsread('1',1,'C1:C32');
folder_name_all = uigetdir('');%选择图片文件夹
oldpath='E:\Study\Research\Program\Summer\LIDC\outpath'
img_path_list = dir(strcat(folder_name_all,'\','*.jpg'));% 获取该文件夹中所有格式的图像
%mkdir outpath;
cd(folder_name_all);
for i=1:numel(a)
     b=a(i);
     imagename=sprintf('%d.jpg',b);
     %imagename=strcat(folder_name_all,'\',numestr(b),'.jpg');
     copyfile(imagename,oldpath);
 end
cd(oldpath);