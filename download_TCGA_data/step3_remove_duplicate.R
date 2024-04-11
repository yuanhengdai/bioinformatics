#date: 20240407
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: remove duplicate（random choose）

# 安装 TCGAbiolinks 包
#BiocManager::install("TCGAbiolinks")
#BiocManager::install("SummarizedExperiment")
#BiocManager::install("tidyverse")

library(TCGAbiolinks)
library(SummarizedExperiment)
library(tidyverse)

# 设置工作路径变量
setwd("C:/D/PHD/bioinformatics/TCGA data/")
file <- "GDCdata/TCGA-KIRC/expr_fpkm_protein_coding.csv"

# 读取下载的表达矩阵, TCGA数据的文件名（XXXX需要自行修改）
df <- read.csv(file, check.names = FALSE)

# 将第一列命名为 'Ensembl_ID'
colnames(df)[1] <- "Ensembl_ID"

# 保留列名的前16个字符
colnames(df) <- substr(colnames(df), 1, 16)

# 查找重复的列名
dup_cols <- colnames(df)[duplicated(colnames(df)) | duplicated(colnames(df), fromLast = TRUE)]

# 初始化一个空数据框用于存储被删除的列
deleted_columns <- data.frame()

# 对于每一个重复的列名，保留平均值较大的列，删除较小的列
for (col_name in unique(dup_cols)) {
  # 获取所有重复列的索引
  cols <- which(colnames(df) == col_name)
  
  # 如果只有一个列，不做处理
  if (length(cols) <= 1) next
  
  # 计算每个重复列的平均值，并保留平均值较大的列
  max_col <- cols[which.max(sapply(cols, function(i) mean(df[[i]], na.rm = TRUE)))]
  
  # 要删除的列
  cols_to_delete <- setdiff(cols, max_col)
  
  # 添加要删除的列到deleted_columns数据框
  deleted_columns <- rbind(deleted_columns, df[, cols_to_delete, drop = FALSE])
  
  # 删除较小的列
  df <- df[, -cols_to_delete]
}

# 输出被删除的列
if (nrow(deleted_columns) > 0) {
  print("以下列被删除:")
  print(colnames(deleted_columns))
} else {
  print("没有列被删除。")
}


