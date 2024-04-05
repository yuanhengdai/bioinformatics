#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the special gene expression matrix
#update: improve the generality

import os
import pandas as pd

#设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

#需要处理的原始文件名
file = "correlation/output_data/tumor_coding_matrix.csv"
final_file = "correlation/output_data/select_tumor_coding_matrix.csv"

#gene list
genes_to_select = [
   "GABRD", "GAD1", "GAD2", "ABAT"
]

#读取文件
df = pd.read_csv(file, sep = ",", index_col=0)
print(df)


filtered_df = pd.DataFrame()  # 创建一个空的DataFrame用于存放筛选出的行

for gene in genes_to_select:
    try:
        # 尝试按基因名筛选行，并将其添加到filtered_df中
        gene_row = df.loc[[gene]]
        filtered_df = pd.concat([filtered_df, gene_row])
    except KeyError:
        # 如果基因名不存在于索引中，则打印消息并跳过
        print(f"Gene {gene} not found in the DataFrame.")


# 导出筛选后的DataFrame到CSV文件
filtered_df.to_csv(final_file, sep=",")
