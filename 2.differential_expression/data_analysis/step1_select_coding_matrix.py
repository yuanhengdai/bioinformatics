#date: 202404013
#revesion: 1.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select coding gene matrix by gene list

import pandas as pd
import os

##准备工作
# 设置工作路径（可以修改的部分）
work_path = 'C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer'
os.chdir(work_path)

file = "output_data/matrix/coding_gene_matrix.csv"  # 设置输入文件名
gene_category = "neurotrophic_factors"   # 设置要筛选的基因类别 （neurotrophic_factors,neurotrophic_like_factors,axon_guidance_molecules）
final_file = "output_data/step1_differential_expression_gene/neurotrophic_factors_gene_matrix.csv" # 设置输出文件名（需要修改_gene_matrix.csv前面的内容）
os.makedirs(os.path.dirname(final_file), exist_ok=True) #创建输出文件夹

##以下内容不要修改
# 使用GeneManager类获取基因列表。把所有gene封装在了GeneManager类中，这样可以直接调用
from gene_manager import GeneManager #导入GeneManager类(自己制作的类)

gene_manager = GeneManager()
gene_list = gene_manager.get_genes_by_category(gene_category)
print(gene_list)


#读取文件
df = pd.read_csv(file, sep = ",", index_col=0)

##筛选基因
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
filtered_df.to_csv(final_file, sep=",")
absolute_path = os.path.abspath(final_file)  # 获取绝对路径

print(f"Filtered gene matrix saved to {absolute_path}")