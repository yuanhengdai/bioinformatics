#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the special gene expression matrix
#update: improve the generality

import os
import pandas as pd

# 设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 读取文件
file = "correlation/output_data/tumor_combined_matrix.csv"
data = pd.read_csv(file, sep=',')

# 定义要筛选的基因名(这里是需要修改的地方)
genes_to_filter = ['ENSG00000268287', 'NTF4']

# 筛选指定基因的数据
filtered_data = data[data['Unnamed: 0'].isin(genes_to_filter)]

# 转置筛选后的数据
transposed_data = filtered_data.set_index('Unnamed: 0').T

# 生成输出文件名基于筛选的基因名
output_filename = f"{'_'.join(genes_to_filter)}.csv"
final_file = f"correlation/output_data/{output_filename}"

# 保存转置后的数据到CSV文件，文件名根据基因名变化
transposed_data.to_csv(final_file)

print(f"File saved as {final_file}")

