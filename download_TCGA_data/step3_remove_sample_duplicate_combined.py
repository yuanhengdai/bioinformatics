#date: 20240411
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: remove duplicate sample for every patient

import pandas as pd
import os

# 设置工作目录
work_path = 'C:/D/PHD/bioinformatics/TCGA data/GDCdata/TCGA-KIRC'
os.chdir(work_path)

# 输入文件名
file_name = "KIRC_exp_fpkm_combined.csv"

# 读取CSV文件到DataFrame
df = pd.read_csv(file_name)

# 获取原始列名并截断前16个字符作为新列名
original_columns = df.columns
truncated_columns = [col[:16] for col in original_columns]

# 创建一个映射关系，将截断的列名映射回它们的原始列名
column_mapping = {}
for original, truncated in zip(original_columns, truncated_columns):
    column_mapping.setdefault(truncated, []).append(original)

# 保存将要删除的列名到一个列表中
columns_to_drop = []

# 遍历映射关系，处理重复的列
for truncated, originals in column_mapping.items():
    if len(originals) > 1:  # 仅处理重复的列
        # 计算每个原始列的平均值，并保留平均值最大的列
        max_mean_col = max(originals, key=lambda col: df[col].mean())
        columns_to_drop.extend(set(originals) - {max_mean_col})
        
        # 打印被删除的列名
        print(f"Deleted columns for {truncated}: {set(originals) - {max_mean_col}}")

# 删除列
df.drop(columns_to_drop, axis=1, inplace=True)

# 确保DataFrame使用更新后的列名
df.columns = [column_mapping.get(col[:16], [col])[0] for col in df.columns]

# 输出文件名
output_file_name = 'filtered_KIRC_exp_fpkm_protein_coding.csv'

# 保存处理后的DataFrame到新的CSV文件
df.to_csv(output_file_name, index=False)

# 将删除的列名保存到另外一个文件
deleted_columns_file = 'deleted_columns.txt'
with open(deleted_columns_file, 'w') as f:
    f.write('\n'.join(columns_to_drop))


