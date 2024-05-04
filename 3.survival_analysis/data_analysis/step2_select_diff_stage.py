#date: 20240420
#revesion: 
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: sort the expression matrix of tumor samples
#update: for GDC-TCGA data, select the tumor samples with stage I, II, III, IV

import pandas as pd
import os

# 设置工作路径
work_path = 'C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer'
os.chdir(work_path)

#读取文件准备文件路径
file = "output_data/step2_survival_analysis/tumor_coding_gene_matrix.csv"
final_file = "output_data/step2_survival_analysis/tumor_coding_gene_matrix.csv"
os.makedirs(os.path.dirname(final_file), exist_ok=True) #创建输出文件夹

