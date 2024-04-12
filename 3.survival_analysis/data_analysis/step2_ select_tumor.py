#date: 20240405
#revesion: 1.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: sort the expression matrix of tumor samples
#update: for GDC-TCGA data, the tumor samples are end with "-01A"

import pandas as pd
import os

# 设置工作路径
work_path = 'C:/D/PHD/bioinformatics/cancer_neuroscience/'
os.chdir(work_path)

#读取文件准备文件路径
file = "survival_analysis/output_data/coding_gene_matrix.csv"
final_file = "survival_analysis/output_data/tumor_coding_gene_matrix.csv"

# 读取文件
data = pd.read_csv(file, sep=',')

# 找到第一列
first_column_name = data.columns[0]

# 选出原发肿瘤-01A结尾的列
filtered_columns = data.filter(regex='-01A$')

# 创建新的DataFrame，包含筛选后的列和第一列
filtered_df = pd.concat([data[[first_column_name]], filtered_columns], axis=1)

print(filtered_df)

# 导出到CSV文件，不包含索引
filtered_df.to_csv(final_file, index=False)