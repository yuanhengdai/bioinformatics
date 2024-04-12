#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: combine the results of gene-lncRNA correlation analysis into a single CSV file
#update: improve the generality

import pandas as pd
import glob
import os

#设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 指定包含CSV文件的文件夹路径
folder_path = 'correlation/output_data/gene_lncRNA_correlations/'  # 更改为你的文件夹路径
output_path = 'correlation/output_data/combined_correlation_results.csv'  # 输出文件的路径

# 初始化一个空的DataFrame用于累积合并结果
combined_results = pd.DataFrame()

# 使用glob遍历文件夹中的所有CSV文件
for file_path in glob.glob(os.path.join(folder_path, '*.csv')):
    # 从文件路径中提取基因名（文件名无扩展名）
    gene_name = os.path.splitext(os.path.basename(file_path))[0]
    
    # 读取CSV文件
    df = pd.read_csv(file_path)
    
    # 为每个记录添加基因名列
    df['gene_name'] = gene_name
    
    # 将当前文件的结果添加到累积的DataFrame中
    combined_results = pd.concat([combined_results, df])

# 重置索引
combined_results.reset_index(drop=True, inplace=True)

# 导出合并后的结果到CSV
combined_results.to_csv(output_path, index=False)

print(f"All files processed and combined results saved to: {output_path}")