#date: 20240412
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the tumor sample
#update: improve the generality

import os
import pandas as pd

# 设置工作路径
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_breast_cancer")

# 文件列表
files = [
    ("output_data/step1/coding_gene_matrix.csv", "output_data/step4_correlation/1_tumor_coding_matrix.csv"),
    ("output_data/step1/lncRNA_matrix.csv", "output_data/step4_correlation/1_tumor_lncRNA_matrix.csv"),
    ("output_data/step1/combined_gene_matrix.csv", "output_data/step4_correlation/1_tumor_combined_matrix.csv")
]

# 遍历文件列表进行处理
for input_file, output_file in files:
    # 检查输出目录是否存在，如果不存在则创建
    if not os.path.exists(os.path.dirname(output_file)):
        os.makedirs(os.path.dirname(output_file))

    # 读取文件
    data = pd.read_csv(input_file, sep=',')

    # 找到第一列
    first_column_name = data.columns[0]

    # 使用正则表达式筛选列名
    filtered_columns = data.filter(regex='-(0[1-9]|10)[A-Z]$')

    # 构建所需的列名列表
    selected_columns = [first_column_name] + list(filtered_columns.columns)

    # 使用筛选后的列名列表来创建一个新的DataFrame
    filtered_df = data[selected_columns]

    # 导出到CSV文件，不包含索引
    filtered_df.to_csv(output_file, index=False)

    # 打印确认
    print(f"Processed and saved: {output_file}")


