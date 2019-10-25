import pandas as pd
import xlrd


#读取xls文件的数据
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


#字典中的key值即为csv中列名
dataframe = pd.DataFrame({'dcnumber':dcmnumber,'cell1':minx,'cell2':maxy,'cell3':maxx,'cell4':miny})
#dataframe = pd.DataFrame({'dcnumber':dcmnumber,'cell1':minx,maxy,maxx,miny})
#将DataFrame存储为csv,index表示是否显示行名，default=True
dataframe.to_csv("test.csv",index=False)
