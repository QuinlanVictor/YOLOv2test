%%%10.30�����������ļ�
close all;clear;clc;
files = dir('*.jpg');
len=length(files);
for i=1:len
    oldname=files(i).name;
    newname=num2str(i,'%04d.jpg');
    %eval(['!rename' ,oldname,newname]);
    cmd=['rename ',oldname,' ', newname];
    status = system(cmd);
    %movefile(oldname,newname);
end
