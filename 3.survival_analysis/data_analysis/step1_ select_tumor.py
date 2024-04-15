#date: 20240405
#revesion: 1.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: sort the expression matrix of tumor samples
#update: for GDC-TCGA data, the tumor samples are end with "-01A"

import pandas as pd
import os

# 设置工作路径
work_path = 'C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer'
os.chdir(work_path)

#读取文件准备文件路径
file = "output_data/matrix/coding_gene_matrix.csv"
final_file = "output_data/step2_survival_analysis/tumor_coding_gene_matrix.csv"
os.makedirs(os.path.dirname(final_file), exist_ok=True) #创建输出文件夹

# 读取文件
data = pd.read_csv(file, sep=',')

# 找到第一列
first_column_name = data.columns[0]

# 选出肿瘤组织
filtered_columns = data.filter(regex='-0[1-9].$|-10.$')

# 创建新的DataFrame，包含筛选后的列和第一列
filtered_df = pd.concat([data[[first_column_name]], filtered_columns], axis=1)

# 导出筛选后的DataFrame到CSV文件
filtered_df.to_csv(final_file,index=False, sep=",")
absolute_path = os.path.abspath(final_file)  # 获取绝对路径

print(f"Filtered gene matrix saved to {absolute_path}")