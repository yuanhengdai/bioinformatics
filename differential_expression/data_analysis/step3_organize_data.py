#date: 20240405
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: organize data to make it ready for drawing differential expression figure

import pandas as pd
import os
import numpy as np

##准备工作
# 设置工作路径（可以修改的部分）
work_path = 'C:/D/PHD/bioinformatics/cancer_neuroscience/'
os.chdir(work_path)

file = "differential_expression/output_data/step2/neurotrophic_like_factors_gene_matrix.csv"  # 设置输入文件名

final_file = "differential_expression/output_data/step3/deg_neurotrophic_like_factors.csv" # 设置输出文件名（需要修改_gene_matrix.csv前面的内容）
os.makedirs(os.path.dirname(final_file), exist_ok=True) #创建输出文件夹

##以下内容不要修改
#读取文件
df = pd.read_csv(file, sep = ",", index_col=0)

# 转置
df = df.T

# 将表达量进行log2 转换
# 给所有值加上一个小常数以避免对零取对数
df += 0.01

# 对数转换，应用 log2
log2_df = np.log2(df)

# 添加 group 列，区分 Tumor 和 Normal
df['group'] = df.index.map(lambda x: 'Tumor' if int(x.split('-')[-1][:2]) < 11 else 'Normal')

# 导出筛选后的DataFrame到CSV文件
df.to_csv(final_file, sep=",")
