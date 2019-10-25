import xlrd
import pandas as pd
import os


xls_data=xlrd.open_workbook("2.xls")
table=xls_data.sheet_by_index(0)
dcmnumber=table.col_values(2)
minx=table.col_values(3)
miny=table.col_values(4)
maxx=table.col_values(5)
maxy=table.col_values(6)
minx=[int(x) for x in minx]
miny=[int(x) for x in miny]
maxx=[int(x) for x in maxx]
maxy=[int(x) for x in maxy]
dcmnumber=[int(x) for x in dcmnumber]
dcmnumber=[str(x) for x in dcmnumber]

label_name='zuobiaoxinxi'
new_dict = {'fn':[],label_name:[]}
img_dir='E:\Study\Research\Program\Summer\Fenge\dicom'
path='E:\Study\Research\Program\LIDC-IDRL'
for num in range(len(dcmnumber)):
    zuobiao=[]
    path2=[]
    path2=os.path.join(img_dir,dcmnumber[num]+'.jpg')
    zuobiao.extend([minx[num],maxy[num],(maxx[num]-minx[num]),(maxy[num]-miny[num])])
    #path3.extend(path2)


    if zuobiao:
        new_dict.setdefault('fn', []).append(path2)
        new_dict.setdefault(label_name, []).append(' '.join(str(x) for x in zuobiao))
    #new_dict.setdefault(label_name, []).append(' '.join(zuobiao[num]))




print(zuobiao)
print(new_dict)
dataframe = pd.DataFrame(new_dict, columns=['fn',label_name])
dataframe.to_csv("test1022.csv",index=False)
