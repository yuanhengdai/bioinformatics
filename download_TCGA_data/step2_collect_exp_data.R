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
file_path <- "GDCdata/TCGA-BRCA/"
file_combined_fpkm <- "BRCA_exp_fpkm_combined.csv"

# 使用变量设置工作路径
setwd(data_path)

# 读取表达矩阵
load(file.path(file_path, "exp.rda"))

# 提取rowData
rowdata <- rowData(data)

# 确保 data 是 SummarizedExperiment 对象
if (!inherits(data, "SummarizedExperiment")) {
  stop("data 不是 SummarizedExperiment 对象")
}

# 提取表达矩阵
expr_fpkm_combined <- assay(data, "fpkm_unstrand")  # 'fpkm_unstrand' 获取count TPM FPKM的参数

# 保存数据
write.csv(expr_fpkm_combined, file = file.path(file_path, file_combined_fpkm))

