#date: 20240412
#revesion: 2.2
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: Calculate the pearson correlation coefficient and p value and create a csv file for each gene
#update: improve the generality


#导入需要用到的库
import pandas as pd
import numpy as np
from scipy.stats import pearsonr
import os  # 用于处理文件路径和文件名

#设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_breast_cancer")

#读取数据
file_select_coding = "output_data/step4_correlation/2_select_tumor_coding_matrix.csv"
file_lncRNA = "output_data/step4_correlation/1_tumor_lncRNA_matrix.csv"

#导出相关性文件目录
output_dir = "output_data/step4_correlation/3_gene_lncRNA_correlations"
os.makedirs(output_dir, exist_ok=True)  # 创建输出目录，如果目录已存在则忽略

#读取数据
gene_expr_df = pd.read_csv(file_select_coding, index_col=0)
lncRNA_expr_df = pd.read_csv(file_lncRNA, index_col=0)

print(lncRNA_expr_df)


print(gene_expr_df.shape)
print(lncRNA_expr_df.shape)

# 遍历基因表达矩阵中的每个基因
for gene in gene_expr_df.index:
    gene_data = gene_expr_df.loc[gene]
    results = []  # 存储当前基因的所有相关性结果
    
    # 遍历lncRNA表达矩阵中的每个lncRNA
    for lncRNA in lncRNA_expr_df.index:
        lncRNA_data = lncRNA_expr_df.loc[lncRNA]
        # 计算当前基因与当前lncRNA之间的Pearson相关性
        correlation, p_value = pearsonr(gene_data, lncRNA_data)
        
        # 添加结果到列表中
        results.append({
            'lncRNA': lncRNA,
            'correlation': correlation,
            'p_value': p_value
        })
    
    # 将结果列表转换为DataFrame
    results_df = pd.DataFrame(results)
    
    # 构建当前基因的输出文件路径
    output_file = os.path.join(output_dir, f"{gene}.csv")
    
    # 导出当前基因的相关性分析结果到CSV文件
    results_df.to_csv(output_file, index=False)
    
    print(f"Exported {gene}.csv")