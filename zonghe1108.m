%%%�ۺ�2
clear;clc;
folder_name_all = uigetdir('');%ѡ���ļ���

%%
filepathlist = dir(folder_name_all);
diary 'worklog.txt'
disp(' ');
time=clock;
t1=strcat(num2str(time(1)),'��',num2str(time(2)),'��',num2str(time(3)),'��',num2str(time(4)),'��',num2str(time(5)));
disp(['����ʱ��:',num2str(t1),'��ʼ��¼']);'

for j=3:length(filepathlist)
    tic;
    a=filepathlist(j).name;
    subfilepathlist = dir(strcat(folder_name_all,'\',a));
    for i=3:length(subfilepathlist)
        b=subfilepathlist(i).name;
        F=strfind(subfilepathlist(i).name,' ');
    if isempty(F)
        %continue; %continue��ֱ�ӽ�����һ��ѭ��������ִ����������
    else
        d=strrep(subfilepathlist(i).name,' ','');
        linshi1=strcat(folder_name_all,'\',a,'\',b);
        linshi2=strcat(folder_name_all,'\',a,'\',d);
        movefile(linshi1,linshi2);
        b=d;
    end
        subsublist=dir(strcat(folder_name_all,'\',a,'\',b));
        d=subsublist(3).name;
        img_path_list = dir(strcat(folder_name_all,'\',a,'\',b,'\',d,'\','*.dcm'));
        c=numel(img_path_list);
        
        
    
        oldname=strcat(folder_name_all,'\',a,'\',b);
        newname1='Dicom';
        newname2='Information';
        if c>=50
            cmd=['rename ',oldname,' ', newname1];
            status = system(cmd);
        else
            cmd=['rename ',oldname,' ', newname2];
            status = system(cmd);
        end
        if status~=0
        disp([num2str(a),'�޸Ĳ��ɹ�!']);
    end
    end
end
disp(['�޸��ļ�����ɣ���ʱ��',num2str(etime(clock,time))]);

%%
filepathlist2 = dir(folder_name_all);
for j=3:length(filepathlist2)
    a=filepathlist2(j).name;
    subfilepathlist = dir(strcat(folder_name_all,'\',a));
    b=subfilepathlist(3).name;
    if strcmpi('Dicom',num2str(b))
        continue;
    else
        disp([num2str(a),'û���޸ĳɹ�']);   
    end
end
disp('��֤���');
diary off