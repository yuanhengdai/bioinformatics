#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the top 10 and bottom 10 correlations for each gene and save them to separate CSV files
#update: improve the generality

import pandas as pd
import glob
import os
#设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 指定包含CSV文件的文件夹路径
folder_path = 'correlation/output_data/gene_lncRNA_correlations/'  # 更改为你的文件夹路径
output_folder = 'correlation/output_data/top10'  # 设置输出目录的路径
os.makedirs(output_folder, exist_ok=True)  # 创建输出目录，如果目录已存在则忽略

# 使用glob遍历文件夹中的所有CSV文件
for file_path in glob.glob(os.path.join(folder_path, '*.csv')):
    # 从文件路径中提取基因名（文件名无扩展名）
    gene_name = os.path.splitext(os.path.basename(file_path))[0]
    
    # 读取CSV文件
    df = pd.read_csv(file_path)
    
    # 找到相关性最大的10个
    top_10 = df.nlargest(10, 'correlation')
    
    # 找到相关性最小的10个
    bottom_10 = df.nsmallest(10, 'correlation')
    
    # 合并结果
    result = pd.concat([top_10, bottom_10])
    
    # 构建输出文件名，包含基因名
    output_file_name = f"{gene_name}.csv"
    output_path = os.path.join(output_folder, output_file_name)
    
    # 导出到CSV
    result.to_csv(output_path, index=False)

    print(f"Processed and saved: {output_path}")