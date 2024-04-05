#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: count the number of lncRNA with correlation absolute value greater than 0.4
#update: improve the generality

import pandas as pd
import os

#设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 指定包含CSV文件的文件夹路径
file_path = 'correlation/output_data/combined_correlation_results.csv'  # 更改为你的文件夹路径
output_path = 'correlation/output_data/count_0.4_results.csv'  # 输出文件的路径


df = pd.read_csv(file_path)

# 只保留Correlation绝对值大于0.4的行
df_filtered = df[df['correlation'].abs() > 0.4]

# 在过滤后的数据上统计第一列（假设第一列是lncRNA的名字）中每个lncRNA出现的次数
lncRNA_counts = df_filtered.iloc[:, 0].value_counts().reset_index()
lncRNA_counts.columns = ['lncRNA', 'count']  # 重命名列以反映内容

# 导出统计结果到CSV文件
lncRNA_counts.to_csv(output_path, index=False)

print(f"lncRNA counts for Correlation absolute value greater than 0.4 have been calculated and saved to: {output_path}")

