%%%��ȡxls�ļ���ת���ӦͼƬ
close all;clear;clc;

[a]=xlsread('1',1,'C1:C32');
folder_name_all = uigetdir('');%ѡ��ͼƬ�ļ���
oldpath='E:\Study\Research\Program\Summer\LIDC\outpath'
img_path_list = dir(strcat(folder_name_all,'\','*.jpg'));% ��ȡ���ļ��������и�ʽ��ͼ��
%mkdir outpath;
cd(folder_name_all);
for i=1:numel(a)
     b=a(i);
     imagename=sprintf('%d.jpg',b);
     %imagename=strcat(folder_name_all,'\',numestr(b),'.jpg');
     copyfile(imagename,oldpath);
 end
cd(oldpath);