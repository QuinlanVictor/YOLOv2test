clear;clc;
folder_name_all = uigetdir('');%选择文件夹
img_path_list = dir(strcat(folder_name_all,'\','*.dcm'));% 获取该文件夹中所有格式的图像 
for i=1:numel(img_path_list)
    oldname = img_path_list(i).name;
    dicomInformation = dicominfo(strcat(folder_name_all,'\',oldname));
    imagenum = dicomInformation.InstanceNumber;
    newname=num2str(imagenum,'%d.dcm');
%     renstr=['!rename','"',oldname,'"',newname];
%     eval(renstr);

%     eval(['!rename',oldname,newname]);
    movefile(oldname,newname);
end
