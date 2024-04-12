#date: 20240331
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: count the number of lncRNA with correlation absolute value greater than 0.4 for every gene 
#update: improve the generality

import pandas as pd
import os

# 设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 加载CSV文件到DataFrame
file_path = 'correlation/output_data/combined_correlation_results.csv'
output_file_path = 'correlation/output_data/correlation_counts_gene.csv'

data = pd.read_csv(file_path)

# 查看DataFrame的前几行以理解其结构
data.head()

# 获取所有唯一基因名称
all_genes = data['gene_name'].unique()

# 根据相关性值过滤数据，并计算每个基因名称的出现次数
correlation_threshold = 0.4
counts_above_threshold = data[data['correlation'] > correlation_threshold].groupby('gene_name').size()
counts_below_threshold = data[data['correlation'] < -correlation_threshold].groupby('gene_name').size()

# 确保所有基因都在结果中，即使计数为0
counts_above_threshold = counts_above_threshold.reindex(all_genes, fill_value=0)
counts_below_threshold = counts_below_threshold.reindex(all_genes, fill_value=0)

# 将结果合并为一个DataFrame以便更好的表示
result = pd.DataFrame({
    'count_correlation_pos_0.4': counts_above_threshold,
    'count_correlation_neg_0.4': counts_below_threshold
}).astype(int)  # 转换为整数

result.head()

# 将结果保存到CSV文件
result.to_csv(output_file_path)