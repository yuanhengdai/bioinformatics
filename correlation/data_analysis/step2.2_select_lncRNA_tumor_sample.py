#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the tumor sample
#update: improve the generality

import os
import pandas as pd

#设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")


file = "correlation/output_data/lncRNA_matrix.csv"
final_file = "correlation/output_data/tumor_lncRNA_matrix.csv"

#读取文件
data = pd.read_csv(file, sep=',')


#找到第一列
first_column_name = data.columns[0]

print(first_column_name)
#选出原发肿瘤-01A结尾
filtered_columns = data.filter(regex='-01A$')

selected_columns = [first_column_name] + list(filtered_columns)

# 使用筛选后的列名列表来创建一个新的DataFrame
filtered_df = data[selected_columns]

print(filtered_df)
# 导出到CSV文件，不包含索引
filtered_df.to_csv(final_file, index=None)



