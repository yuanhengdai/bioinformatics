#date: 20240412
#revesion: 2.2
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the special gene expression matrix
#update: improve the generality

import os
import pandas as pd

#设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer")

#要筛选的基因类别
gene_category = "neurotrophic_like_factors"   # 设置要筛选的基因类别 （neurotrophic_factors,neurotrophic_like_factors,axon_guidance_molecules）
#gene_dict = "NGF"

#需要处理的原始文件名
file = "output_data/step3_correlation/1_tumor_coding_matrix.csv"
output_file = "output_data/step3_correlation/2_select_tumor_coding_matrix.csv"

# 检查输出目录是否存在，如果不存在则创建
if not os.path.exists(os.path.dirname(output_file)):
    os.makedirs(os.path.dirname(output_file))

# 使用GeneManager类获取基因列表。把所有gene封装在了GeneManager类中，这样可以直接调用
from gene_manager import GeneManager #导入GeneManager类(自己制作的类)

gene_manager = GeneManager()
#gene_list  = gene_manager.genes_dict[gene_dict]
gene_list = gene_manager.get_genes_by_category(gene_category)
print(gene_list)

#读取文件
df = pd.read_csv(file, sep = ",", index_col=0)

filtered_df = pd.DataFrame()  # 创建一个空的DataFrame用于存放筛选出的行

for gene in gene_list:
    try:
        # 尝试按基因名筛选行，并将其添加到filtered_df中
        gene_row = df.loc[[gene]]
        filtered_df = pd.concat([filtered_df, gene_row])
    except KeyError:
        # 如果基因名不存在于索引中，则打印消息并跳过
        print(f"Gene {gene} not found in the DataFrame.")


# 导出筛选后的DataFrame到CSV文件
filtered_df.to_csv(output_file, sep=",")
