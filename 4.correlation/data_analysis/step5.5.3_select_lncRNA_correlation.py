#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: sort the gene by the mean correlation
#update: improve the generality

import os
import pandas as pd

# 设置工作目录
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 需要处理的原始文件名
file = "correlation/output_data/combined_correlation_results.csv"
final_file = "correlation/output_data/filtered_lncRNA_correlation.csv"
lncRNA_file_path = "correlation/output_data/filtered_lncRNA_list.txt"

# 从文件读取lncRNA list

with open(lncRNA_file_path, 'r') as f:
    selected_top_lncRNA = [line.strip() for line in f]

# 读取文件
df = pd.read_csv(file, sep=",", index_col=0)

filtered_df = pd.DataFrame()  # 创建一个空的DataFrame用于存放筛选出的行

for lncRNA in selected_top_lncRNA:
    try:
        # 尝试按基因名筛选行，并将其添加到filtered_df中
        lncRNA_row = df.loc[[lncRNA]]
        filtered_df = pd.concat([filtered_df, lncRNA_row])
    except KeyError:
        # 如果基因名不存在于索引中，则打印消息并跳过
        print(f"Gene {lncRNA} not found in the DataFrame.")

# 导出筛选后的DataFrame到CSV文件
filtered_df.to_csv(final_file, sep=",")

