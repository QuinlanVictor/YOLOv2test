%%%读取xls文件并转存对应图片
close all;clear;clc;
%filepathlist='E:\Study\Research\Data\Result\LIDC\dataframe\casenodle';
%xlspathlist=dir(strcat(num2str(filepathlist),'\','*.xls'));

xlsfilepathlist=uigetdir('E:\Study\Research\Data\Result\LIDC\dataframe');%选择文件夹
xlspathlist=dir(strcat(xlsfilepathlist,'\','*.xls'));

% diary 'worklog.txt'
% disp(' ');
% time=clock;
% t1=strcat(num2str(time(1)),'年',num2str(time(2)),'月',num2str(time(3)),'日',num2str(time(4)),'：',num2str(time(5)));
% disp(['北京时间:',num2str(t1),'开始复制图片']);

% for j=1:length(xlspathlist)
for j=17:18
    tic;
    xlsname = xlspathlist(j).name;
    xlsfile=strcat(xlsfilepathlist,'\',xlsname);
    %xlsfile=strcat(num2str(filepathlist),'\',xlsname);
    [a]=xlsread(num2str(xlsfile),1,'A1:A100');
    
    x=num2str(xlsname);
    split_xlsname=x(5:end-9);
    %spilt_xlsname=x(isstrprop(x,'digit'));
    casename=strcat('case',num2str(split_xlsname));
    mkdirpath=strcat('E:\Study\Research\Data\Result\LIDC\copyimg\',num2str(casename));
    
    mkdir(num2str(mkdirpath));
    
    oldpath=num2str(mkdirpath);
    img_path=strcat('G:\LIDC-jpg\',num2str(casename));
    img_path_list = dir(strcat('G:\LIDC-jpg\',num2str(casename),'\','*.jpg'));% 获取该文件夹中所有格式的图像
    
    cd(num2str(img_path));
    for i=1:numel(a)
        b=a(i);
        imagename=sprintf('%d.jpg',b);
        copyfile(imagename,oldpath);
    end
    disp([num2str(xlsname),'复制图片完成，用时：',num2str(toc)]);
end
% time=clock;
% t2=strcat(num2str(time(1)),'年',num2str(time(2)),'月',num2str(time(3)),'日',num2str(time(4)),'：',num2str(time(5)));
% disp(['完成复制，结束时间：',num2str(t2)]);
% diary off
