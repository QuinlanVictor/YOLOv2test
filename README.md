# YOLOv2test
YOLOv2进行测试自己数据集的项目  1017

10.25 对于程序进行一下总结和梳理
xiuzhengID.m   下载的LIDC数据文件名和dicom头信息中的图片编号不一致，将其统一方便后面编程
test.m  提取LIDC数据库中的XML文件结节信息，将其导入到xls文件中
test1017.py  python读取xls文件数据写入csv文件
test1022_24.m  依据csv文件为训练数据进行网络的参数设置，训练网络，得到yolov2模型
