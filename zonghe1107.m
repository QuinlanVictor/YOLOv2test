%%%综合程序，还没有改写成函数形式
clear;clc;
folder_name_all = uigetdir('');%选择文件夹

%%
filepathlist2 = dir(folder_name_all);
diary 'log1107.txt'
disp(' ');
time=clock;
t1=strcat(num2str(time(1)),'年',num2str(time(2)),'月',num2str(time(3)),'日',num2str(time(4)),'：',num2str(time(5)));
disp(['北京时间:',num2str(t1),'开始重命名']);
for j=1:length(filepathlist2)
%for j=3:4 %24是文件夹222
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
        disp([num2str(a),'修改不成功!']);
    end
    end
    disp([num2str(a),'重命名完毕，用时：',num2str(toc),'秒']);
end
time=clock;
t2=strcat(num2str(time(1)),'年',num2str(time(2)),'月',num2str(time(3)),'日',num2str(time(4)),'：',num2str(time(5)));
disp(['已经完成重命名，结束时间：',num2str(t2)]);
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
    img_path_list = dir(strcat(dcm_name_all,'\','*.dcm'));% 获取该文件夹中所有格式的图像  
    xml_path_list = dir(strcat(dcm_name_all,'\','*.xml'));

%  读取xml文件部分，只提取3mm-33mm的结节
xml_name = xml_path_list.name;
docNode= xmlread(strcat(dcm_name_all,'\',xml_name));
document = docNode.getDocumentElement();
readingSession = document.getElementsByTagName('readingSession');


sop_text = { }; %每个图片的标号
max_min_xy = []; %每个图像中肺结节的x和y的最小值和最大值
sop_num = 0;         %总结节个数？*


for r = 0:readingSession.getLength()-1
    unblinded_nodule = readingSession.item(r).getElementsByTagName('unblindedReadNodule');     %unblindedReadNodule一个节点标记，<unblindedReadNodule>节点数据包括在</unblindedReadNodule>*
    
    for u = 0 : unblinded_nodule.getLength()-1
       
        mal = unblinded_nodule.item(u).getElementsByTagName('malignancy');    %<malignancy>结节恶性度</malignancy>*
        roi = unblinded_nodule.item(u).getElementsByTagName('roi');   %item() 方法可返回节点列表中处于指定索引号的节点。*<roi>结节轮廓</roi>*
                

        if isempty(mal.item(0))
            continue;
        end
        
        mal_int = str2num(char(mal.item(0).getTextContent()));
        Num_roi = roi.getLength();   %该类别的图片的数量
        
        if mal_int>=4
        
        for i = 0 : Num_roi-1  %遍历*
            sop_id = roi.item(i).getElementsByTagName('imageSOP_UID');    %图片编号*
            sop_text{sop_num + i + 1} = char(sop_id.item(0).getTextContent());   %数组*
            edgeMap = roi.item(i).getElementsByTagName('edgeMap');   %边界*
            xy = [];
            for j = 0 :edgeMap.getLength()-1            %获得坐标*
                xCoord = edgeMap.item(j).getElementsByTagName('xCoord');
                xCoord_int = str2num(char(xCoord.item(0).getTextContent()));
                
                yCoord = edgeMap.item(j).getElementsByTagName('yCoord');
                yCoord_int = str2num(char(yCoord.item(0).getTextContent()));
                xy=[xy();xCoord_int,yCoord_int];
            end
            
            if edgeMap.getLength()==1
                max_min_xy = [max_min_xy();xy,xy];%如果是小结节，直接使用这个坐标即可
                continue;
            end
            [maxr,max_index] = max(xy);%因为坐标比较多，所以筛选出边缘坐标
            [minr,min_index] = min(xy);%为了后续的操作我应该要得到左上角和右下角的坐标
            max_min_xy = [max_min_xy();minr,maxr];
        end
        
        else
            Num_roi=0;
            
        end
        
        sop_num= Num_roi+sop_num;   %总个数
        
    end

end


% 进行扩展维度以方便最后导入xls文件中
sop_num = size(sop_text);   %  获得行列数，行：？ 列：图片数*
if sop_num==0
    disp([num2str(a),'没有恶性结节!']);
    continue;
    
end

dcm_number = [ ];   %图片编号*    
        

        
%  读取dicom文件头信息
for md= 1 : sop_num(2)      %修正维数，把维数调整一致           
    dcm_number= [dcm_number;0];
end
for j = 1:numel(img_path_list)    %遍历文件 numel()函数返回数组个数
    image_name = img_path_list(j).name;  %  图像名
    dicomInformation = dicominfo(strcat(dcm_name_all,'\',image_name)); %存储图片信息
    instance = dicomInformation.SOPInstanceUID;   
    imagenum = dicomInformation.InstanceNumber; 
  for s = 1 : sop_num(2)%对比
    if strcmpi(instance,sop_text(1,s))
        dcm_number(s) = imagenum;     %编号？？?*
    end
  end
end
total = [dcm_number,max_min_xy];
spilt_a=split(num2str(a),{'-0'});
numFile=char(spilt_a{2});
xlsname=strcat('case',num2str(numFile),'nodle.xls');
xlswrite(num2str(xlsname),total);     %导入到xls文件中
disp([num2str(a),'提取完成!','提取用时：',num2str(toc)]);

end
diary off


