%%%1216测试程序
%%%
%将得到的结节信息进一步进行筛选，把过小的区域图片去掉
%version：20191216
%20200107进行了使用
%%%
close all;clear;clc
xlsfile='huizong01063.xls';
[a]=xlsread(xlsfile,1,'A1:A8000');
[d]=xlsread(xlsfile,1,'B1:E8000');
[e]=xlsread(xlsfile,1,'A1:E8000');
num=[];

  for j=1:numel(a)
            minx=d(j,1);
            miny=d(j,2);
            maxx=d(j,3);
            maxy=d(j,4);
            c1=maxx-minx;
            c2=maxy-miny;
            
         if c1>=10||c2>=10
             if c1>=8&&c2>=8
                num=[num();e(j,:)];  
             end
         end
         
%          if c1>100||c2>100
%              disp([num2str(a(j)),'youwenti']);
%          end
         
%          if minx>500||maxx>500
%              disp([num2str(a(j)),'x,youwenti']);
%          end
%            if miny>500||maxy>500
%              disp([num2str(a(j)),'y,youwenti']);
%          end
%          
  end
  
cd('E:\Study\Research\Data\Result\LIDC\testdata\testxls2');
xlswrite('huizong0107DEL.xls',num);