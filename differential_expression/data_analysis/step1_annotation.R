#date: 20240327
#revesion: 2.0
#author: Yuanheng
#e-mail: Yuanheng.Dai@uon.edu.au
#function: Annotation
#update: improve generality

#安装R包,已安装可跳过
#BiocManager::install("tidyr")
#BiocManager::install("rtracklayer")
#BiocManager::install("dplyr")
#BiocManager::install("tibble")
#BiocManager::install("limma")

library(readr)
library(tidyr)
library(dplyr)
library(tibble)
library(rtracklayer)

## 前期准备
# 设置工作路径
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer")

# 读取表达矩阵
raw_file <- "raw_data/filtered_KIRC_exp_fpkm_combined.csv"
rawdata <- read.csv(raw_file, check.names = FALSE)

# 设置导出文件名和路径
coding_gene_file <- "output_data/coding_gene_matrix.csv"
lncRNA_file <- "output_data/lncRNA_matrix.csv"
combined_file <- "output_data/combined_gene_matrix.csv"

# 读取注释文件
raw_annotation <- 'raw_data/gencode.v45.annotation.gtf.gz'
annotation <- rtracklayer::import(raw_annotation) %>% as.data.frame()

# 提取protein_coding的基因
gtf_protein_GENECODE <- dplyr::select(annotation, c("gene_id", "gene_type", "gene_name")) %>%
  filter(gene_type == "protein_coding") %>%
  distinct()

# 根据注释文件，转换protein_coding的gene_ID
exprSet_protein_coding <- rawdata %>%
  inner_join(gtf_protein_GENECODE, by = c("Ensembl_ID" = "gene_id")) %>%
  select(gene_name, starts_with("TCGA"))

# 提取lncRNA的基因
gtf_lncRNA_GENECODE <- dplyr::select(annotation, c("gene_id", "gene_type", "gene_name")) %>%
  filter(gene_type == "lncRNA") %>%
  distinct()

# 根据注释文件，转换lncRNA的gene_ID
exprSet_lncRNA <- rawdata %>%
  inner_join(gtf_lncRNA_GENECODE, by = c("Ensembl_ID" = "gene_id")) %>%
  select(gene_name, starts_with("TCGA"))

# 合并两个表达矩阵
combined_exprSet <- rbind(exprSet_protein_coding, exprSet_lncRNA)

## 保存文件
write.csv(exprSet_protein_coding, file = coding_gene_file, row.names = FALSE, fileEncoding = "UTF-8")
write.csv(exprSet_lncRNA, file = lncRNA_file, row.names = FALSE, fileEncoding = "UTF-8")
write.csv(combined_exprSet, file = combined_file, row.names = FALSE, fileEncoding = "UTF-8")

