#date: 20240330
#revision: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the top 10 correlations for each gene, add a rank column, and save them to a single CSV file
#update: improve the generality

import pandas as pd
import glob
import os

# 设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 指定包含CSV文件的文件夹路径
folder_path = 'correlation/output_data/gene_lncRNA_correlations/'  # 更改为你的文件夹路径
output_folder = 'correlation/output_data/'  # 设置输出目录的路径
os.makedirs(output_folder, exist_ok=True)  # 如果目录不存在，则创建它

# 初始化一个空的DataFrame来收集所有结果
all_results = pd.DataFrame()

# 使用glob遍历文件夹中的所有CSV文件
for file_path in glob.glob(os.path.join(folder_path, '*.csv')):
    # 从文件路径中提取基因名（文件名无扩展名）
    gene_name = os.path.splitext(os.path.basename(file_path))[0]
    
    # 读取CSV文件
    df = pd.read_csv(file_path)
    
    # 找到相关性最大的10个记录
    top_10 = df.nlargest(10, 'correlation')
    
    # 为top_10添加基因名和排名列
    top_10['gene_name'] = gene_name
    top_10['rank'] = range(1, 11)
    
    # 将筛选后的数据追加到all_results中
    all_results = pd.concat([all_results, top_10], ignore_index=True)

# 构建输出文件路径
output_file_path = os.path.join(output_folder, 'combined_top_10_correlations_with_rank.csv')

# 将合并后的结果导出到CSV
all_results.to_csv(output_file_path, index=False)

print(f"All data processed and saved to: {output_file_path}")
