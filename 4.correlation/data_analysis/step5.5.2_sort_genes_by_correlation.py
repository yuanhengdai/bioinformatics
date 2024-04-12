
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

# 文件路径
df = pd.read_csv('correlation/output_data/combined_correlation_results.csv')
final_path = "correlation/output_data/sorted_genes_by_correlation.csv"  # 输出文件路径
sorted_genes_txt_path = "correlation/output_data/sorted_genes_list.txt"  # 排序后的基因列表文本文件路径

# 计算每个基因的相关性值的平均值
mean_correlation = df.groupby('gene_name')['correlation'].mean().reset_index()

# 取相关性平均值的绝对值
mean_correlation['abs_mean_correlation'] = mean_correlation['correlation'].abs()

# 按绝对平均相关性值从高到低排序
mean_correlation_sorted = mean_correlation.sort_values(by='abs_mean_correlation', ascending=False)

# 显示排序后的基因名称及其平均相关性
print(mean_correlation_sorted)

# 将排序后的结果保存为CSV文件
mean_correlation_sorted.to_csv(final_path, index=False, sep=',')

# 将排序后的基因名称保存为文本文件
sorted_genes = mean_correlation_sorted['gene_name'].tolist()
with open(sorted_genes_txt_path, "w") as f:
    for gene in sorted_genes:
        f.write(gene + "\n")