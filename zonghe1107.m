%%%�ۺϳ��򣬻�û�и�д�ɺ�����ʽ
clear;clc;
folder_name_all = uigetdir('');%ѡ���ļ���

%%
filepathlist2 = dir(folder_name_all);
diary 'log1107.txt'
disp(' ');
time=clock;
t1=strcat(num2str(time(1)),'��',num2str(time(2)),'��',num2str(time(3)),'��',num2str(time(4)),'��',num2str(time(5)));
disp(['����ʱ��:',num2str(t1),'��ʼ������']);
for j=1:length(filepathlist2)
%for j=3:4 %24���ļ���222
    tic;
    a=filepathlist2(j).name;
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
        disp([num2str(a),'�޸Ĳ��ɹ�!']);
    end
    end
    disp([num2str(a),'��������ϣ���ʱ��',num2str(toc),'��']);
end
time=clock;
t2=strcat(num2str(time(1)),'��',num2str(time(2)),'��',num2str(time(3)),'��',num2str(time(4)),'��',num2str(time(5)));
disp(['�Ѿ����������������ʱ�䣺',num2str(t2)]);
diary off

%%
diary on
filepathlist3 = dir(folder_name_all);
for k=3:length(filepathlist3)
%for k=3:5
    tic;
    a=filepathlist3(k).name;
    subfilepathlist = dir(strcat(folder_name_all,'\',a));
    subsublist=dir(strcat(folder_name_all,'\',a,'\','Dicom'));
    d=subsublist(3).name;
    dcm_name_all=num2str(strcat(folder_name_all,'\',a,'\','Dicom','\',d));
    img_path_list = dir(strcat(dcm_name_all,'\','*.dcm'));% ��ȡ���ļ��������и�ʽ��ͼ��  
    xml_path_list = dir(strcat(dcm_name_all,'\','*.xml'));

%  ��ȡxml�ļ����֣�ֻ��ȡ3mm-33mm�Ľ��
xml_name = xml_path_list.name;
docNode= xmlread(strcat(dcm_name_all,'\',xml_name));
document = docNode.getDocumentElement();
readingSession = document.getElementsByTagName('readingSession');


sop_text = { }; %ÿ��ͼƬ�ı��
max_min_xy = []; %ÿ��ͼ���зν�ڵ�x��y����Сֵ�����ֵ
sop_num = 0;         %�ܽ�ڸ�����*


for r = 0:readingSession.getLength()-1
    unblinded_nodule = readingSession.item(r).getElementsByTagName('unblindedReadNodule');     %unblindedReadNoduleһ���ڵ��ǣ�<unblindedReadNodule>�ڵ����ݰ�����</unblindedReadNodule>*
    
    for u = 0 : unblinded_nodule.getLength()-1
       
        mal = unblinded_nodule.item(u).getElementsByTagName('malignancy');    %<malignancy>��ڶ��Զ�</malignancy>*
        roi = unblinded_nodule.item(u).getElementsByTagName('roi');   %item() �����ɷ��ؽڵ��б��д���ָ�������ŵĽڵ㡣*<roi>�������</roi>*
                

        if isempty(mal.item(0))
            continue;
        end
        
        mal_int = str2num(char(mal.item(0).getTextContent()));
        Num_roi = roi.getLength();   %������ͼƬ������
        
        if mal_int>=4
        
        for i = 0 : Num_roi-1  %����*
            sop_id = roi.item(i).getElementsByTagName('imageSOP_UID');    %ͼƬ���*
            sop_text{sop_num + i + 1} = char(sop_id.item(0).getTextContent());   %����*
            edgeMap = roi.item(i).getElementsByTagName('edgeMap');   %�߽�*
            xy = [];
            for j = 0 :edgeMap.getLength()-1            %�������*
                xCoord = edgeMap.item(j).getElementsByTagName('xCoord');
                xCoord_int = str2num(char(xCoord.item(0).getTextContent()));
                
                yCoord = edgeMap.item(j).getElementsByTagName('yCoord');
                yCoord_int = str2num(char(yCoord.item(0).getTextContent()));
                xy=[xy();xCoord_int,yCoord_int];
            end
            
            if edgeMap.getLength()==1
                max_min_xy = [max_min_xy();xy,xy];%�����С��ڣ�ֱ��ʹ��������꼴��
                continue;
            end
            [maxr,max_index] = max(xy);%��Ϊ����Ƚ϶࣬����ɸѡ����Ե����
            [minr,min_index] = min(xy);%Ϊ�˺����Ĳ�����Ӧ��Ҫ�õ����ϽǺ����½ǵ�����
            max_min_xy = [max_min_xy();minr,maxr];
        end
        
        else
            Num_roi=0;
            
        end
        
        sop_num= Num_roi+sop_num;   %�ܸ���
        
    end

end


% ������չά���Է��������xls�ļ���
sop_num = size(sop_text);   %  ������������У��� �У�ͼƬ��*
if sop_num==0
    disp([num2str(a),'û�ж��Խ��!']);
    continue;
    
end

dcm_number = [ ];   %ͼƬ���*    
        

        
%  ��ȡdicom�ļ�ͷ��Ϣ
for md= 1 : sop_num(2)      %����ά������ά������һ��           
    dcm_number= [dcm_number;0];
end
for j = 1:numel(img_path_list)    %�����ļ� numel()���������������
    image_name = img_path_list(j).name;  %  ͼ����
    dicomInformation = dicominfo(strcat(dcm_name_all,'\',image_name)); %�洢ͼƬ��Ϣ
    instance = dicomInformation.SOPInstanceUID;   
    imagenum = dicomInformation.InstanceNumber; 
  for s = 1 : sop_num(2)%�Ա�
    if strcmpi(instance,sop_text(1,s))
        dcm_number(s) = imagenum;     %��ţ���?*
    end
  end
end
total = [dcm_number,max_min_xy];
spilt_a=split(num2str(a),{'-0'});
numFile=char(spilt_a{2});
xlsname=strcat('case',num2str(numFile),'nodle.xls');
xlswrite(num2str(xlsname),total);     %���뵽xls�ļ���
disp([num2str(a),'��ȡ���!','��ȡ��ʱ��',num2str(toc)]);

end
diary off


