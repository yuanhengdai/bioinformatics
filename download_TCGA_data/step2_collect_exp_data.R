#date: 20240407
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: prepare the TCGA data to expression matrix
#reference: https://mp.weixin.qq.com/s?__biz=MzUzOTQzNzU0NA==&mid=2247492462&idx=1&sn=0773b4ad0ecdd7e3cf206cd611249399&chksm=facad3e9cdbd5aff246e43133b012d0eee40ccd71e15dd97e3fa44940f0d838e082518ef937f&scene=21#wechat_redirect


# 安装 TCGAbiolinks 包
#BiocManager::install("TCGAbiolinks")
#BiocManager::install("SummarizedExperiment")
#BiocManager::install("tidyverse")

library(TCGAbiolinks)
library(SummarizedExperiment)
library(tidyverse)

# 设置工作路径变量
data_path <- "C:/D/PHD/bioinformatics/TCGA data/"
file_path <- "GDCdata/TCGA-KIRC/"
file_protein_coding_fpkm <- "KIRC_exp_fpkm_protein_coding.csv"
file_lncRNA_fpkm <- "KIRC_exp_fpkm_lncRNA.csv"

# 使用变量设置工作路径
setwd(data_path)

# 读取表达矩阵
load(file.path(data_path, "exp.rda"))

df <- data

# 提取rowData
rowdata <- rowData(df)

# 根据gene_type取子集
df_protein_coding <- df[rowdata$gene_type == "protein_coding",]
df_lncRNA <- df[rowdata$gene_type == "lncRNA"]

# 获取各种表达矩阵
#expr_counts_protein_coding <- assay(df_protein_coding,"unstranded")
#expr_tpm_protein_coding <- assay(df_protein_coding,"tpm_unstrand")
expr_fpkm_protein_coding <- assay(df_protein_coding,"fpkm_unstrand")
#expr_counts_lncRNA <- assay(df_lncRNA,"unstranded")
#expr_tpm_lncRNA <- assay(df_lncRNA,"tpm_unstrand")
expr_fpkm_lncRNA <- assay(df_lncRNA,"fpkm_unstrand")



# 保存数据
#write.csv(expr_counts_protein_coding, file = file.path(file_path, "expr_counts_protein_coding.csv"))
#write.csv(expr_tpm_protein_coding, file = file.path(file_path, "expr_tpm_protein_coding.csv"))
write.csv(expr_fpkm_protein_coding, file = file.path(file_path, file_protein_coding_fpkm))
#write.csv(expr_counts_lncRNA, file = file.path(file_path, "expr_counts_lncRNA.csv"))
#write.csv(expr_tpm_lncRNA, file = file.path(file_path, "expr_tpm_lncRNA.csv"))
write.csv(expr_fpkm_lncRNA, file = file.path(file_path, file_lncRNA_fpkm))
