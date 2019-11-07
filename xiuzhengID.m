clear;clc;
folder_name_all = uigetdir('');%选择文件夹
filepathlist = dir(folder_name_all);
diary 'worklog.txt'
disp(' ');
time=clock;
t1=strcat(num2str(time(1)),'年',num2str(time(2)),'月',num2str(time(3)),'日',num2str(time(4)),'：',num2str(time(5)));
disp(['北京时间:',num2str(t1),'开始重命名']);
for j=24:length(filepathlist)
%for j=3:4 %24是文件夹222
    tic;
    a=filepathlist(j).name;
    subsublist=dir(strcat(folder_name_all,'\',a,'\','Dicom'));
    b=subsublist(3).name;
    dcm_name_all=num2str(strcat(folder_name_all,'\',a,'\','Dicom','\',b));
    cd(dcm_name_all);
    dcm_path_list = dir(strcat(folder_name_all,'\',a,'\','Dicom','\',b,'\','*.dcm'));
    for i=1:numel(dcm_path_list)
        oldname = dcm_path_list(i).name;
        dicomInformation = dicominfo(strcat(dcm_name_all,'\',oldname));
        imagenum = dicomInformation.InstanceNumber;
        newname=num2str(imagenum,'%d.dcm');
        cmd=['rename ',oldname,' ', newname];
        status = system(cmd);
        if status~=0
        disp([num2str(a),'修改不成功!']);
    end
    end
    disp([num2str(a),'重命名完毕，用时：',num2str(toc),'秒']);
end
time=clock;
t2=strcat(num2str(time(1)),'年',num2str(time(2)),'月',num2str(time(3)),'日',num2str(time(4)),'：',num2str(time(5)));
disp(['已经完成重命名，结束时间：',num2str(t2)]);
diary off
