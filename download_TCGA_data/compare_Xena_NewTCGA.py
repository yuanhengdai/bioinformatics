import pandas as pd
import os

# 设置工作路径
work_path = 'C:/D/PHD/bioinformatics/TCGA data/GDCdata/TCGA-KIRC'
os.chdir(work_path)

# Load the two files into dataframes
file_1_path = 'expr_fpkm_symbol_protein_coding.csv'
file_2_path = 'coding_gene_matrix.csv'

# Read the files, assuming the first column contains the gene names
df1 = pd.read_csv(file_1_path, index_col=0)
df2 = pd.read_csv(file_2_path, index_col=0)

# Get the gene names from both files
genes_file_1 = df1.index.tolist()
genes_file_2 = df2.index.tolist()

# Compare the gene names in both files
unique_to_file_1 = set(genes_file_1) - set(genes_file_2)
unique_to_file_2 = set(genes_file_2) - set(genes_file_1)
common_genes = set(genes_file_1) & set(genes_file_2)

# Prepare the output
comparison_result = {
    "unique_to_file_1": list(unique_to_file_1),
    "unique_to_file_2": list(unique_to_file_2),
    "common_genes": list(common_genes),
    "total_unique_file_1": len(unique_to_file_1),
    "total_unique_file_2": len(unique_to_file_2),
    "total_common": len(common_genes)
}

print(comparison_result['unique_to_file_2'])