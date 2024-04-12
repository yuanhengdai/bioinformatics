#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: select the lncRNA expression matrix based on the count threshold
#update: improve the generality

import os
import pandas as pd

# 设置工作目录
os.chdir("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 文件路径配置
count_file = "correlation/output_data/count_0.4_results.csv"
file = "correlation/output_data/combined_correlation_results.csv"
final_file = "correlation/output_data/filtered_tumor_lncRNA_correlation.csv"
lncRNA_list_file = "correlation/output_data/filtered_lncRNA_list.txt"

# 设置lncRNA出现的次数阈值
count_threshold = 2

# 读取count文件，并基于count值过滤lncRNA
count_df = pd.read_csv(count_file)
filtered_lncRNA = count_df[count_df['count'] > count_threshold]['lncRNA'].tolist()

# 将筛选出的lncRNA保存到文本文件
with open(lncRNA_list_file, "w") as f:
    for lncRNA in filtered_lncRNA:
        f.write(lncRNA + "\n")

# 读取原始数据文件
df = pd.read_csv(file, sep=",", index_col=0)

filtered_df = pd.DataFrame()  # 创建一个空的DataFrame来存储过滤后的行

for lncRNA in filtered_lncRNA:
    try:
        # 尝试按基因名筛选行，并将其添加到filtered_df中
        lncRNA_row = df.loc[[lncRNA]]
        filtered_df = pd.concat([filtered_df, lncRNA_row])
    except KeyError:
        # 如果基因名不存在于索引中，打印消息并跳过
        print(f"基因 {lncRNA} 在DataFrame中未找到。")

# 将过滤后的DataFrame导出到CSV文件
filtered_df.to_csv(final_file, sep=",")