#为了进行聚类预测而修改制作csv文件的程序，使得更容易提取信息
import pandas as pd
import xlrd
import os

xls_data=xlrd.open_workbook("sorted1120.xls")
table=xls_data.sheet_by_index(0)
dcmnumber=table.col_values(0)
minx=table.col_values(1)
miny=table.col_values(2)
maxx=table.col_values(3)
maxy=table.col_values(4)
minx=[int(x) for x in minx]
miny=[int(x) for x in miny]
maxx=[int(x) for x in maxx]
maxy=[int(x) for x in maxy]
dcmnumber=[int(x) for x in dcmnumber]
dcmnumber=[str(x) for x in dcmnumber]


img_dir='E:\Data\LIDC\jpgdata'

path2=[]
w=[]
h=[]
for num in range(len(dcmnumber)):
    path3=os.path.join(img_dir,dcmnumber[num]+'.jpg')
    path2.append(path3)
    ww=maxx[num]-minx[num]
    w.append(ww)
    hh=maxy[num]-miny[num]
    h.append(hh)

dataframe = pd.DataFrame({'dcnumber':path2,'cell1':minx,'cell2':miny,'cell3':w,'cell4':h})
dataframe.to_csv("kmeans1120.csv",index=False)
