#导入csv的测试程序1120
'''
制作yolov2训练数据csv的程序

vesion：1120
author：Quinlan
history：1215 对汇总1215文件进行处理
         1216 对修正过后的汇总文件进行处理
'''
import xlrd
import pandas as pd
import os


xls_data=xlrd.open_workbook("huizong1225.xls")
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

label_name='zuobiaoxinxi'
new_dict = {'fn':[],label_name:[]}
img_dir='E:\Data\LIDC\jpgdata1212'

for num in range(len(dcmnumber)):
    zuobiao=[]
    #path2=[]
    path2=os.path.join(img_dir,dcmnumber[num]+'.jpg')
    zuobiao.extend([minx[num],miny[num],(maxx[num]-minx[num]),(maxy[num]-miny[num])])
    #path3.extend(path2)


    if zuobiao:
        new_dict.setdefault('fn', []).append(path2)
        new_dict.setdefault(label_name, []).append(' '.join(str(x) for x in zuobiao))
    #new_dict.setdefault(label_name, []).append(' '.join(zuobiao[num]))




#print(zuobiao)
print(new_dict)
dataframe = pd.DataFrame(new_dict, columns=['fn',label_name])
dataframe.to_csv("yolo1225tr.csv",index=False)
