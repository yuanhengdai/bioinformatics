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
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_breast_cancer")

# 读取表达矩阵
raw_file <- "raw_data/filtered_BRCA_exp_fpkm_combined.csv"
rawdata <- read.csv(raw_file, check.names = FALSE)

# 设置导出文件名和路径
coding_gene_file <- "output_data/step1/coding_gene_matrix.csv"
lncRNA_file <- "output_data/step1/lncRNA_matrix.csv"
combined_file <- "output_data/step1/combined_gene_matrix.csv"

# 更改第一列的列名为Ensembl_ID
colnames(rawdata)[1] <- "Ensembl_ID"

#去掉gene_ID .后的数字
rawdata_1 <- separate(rawdata, Ensembl_ID,into= c("Ensembl_ID"),sep="\\.")
rawdata_1[1:4,1:4]

# 将剩余列名截短为前16位
colnames(rawdata_1)[-1] <- substr(colnames(rawdata_1)[-1], 1, 16)


##正式开始
# 读取注释文件
raw_annotation <- 'raw_data/Homo_sapiens.GRCh38.111.gtf.gz' #https://ftp.ensembl.org/pub/release-111/gtf/homo_sapiens/
annotation <- rtracklayer::import(raw_annotation) %>% as.data.frame()

#提取protein_coding的基因
gtf_protein_Ensembl <- dplyr::select(annotation, c("gene_id", "gene_biotype", "gene_name")) %>%
  filter(gene_biotype == "protein_coding") %>%
  mutate(gene_name = ifelse(is.na(gene_name), gene_id, gene_name)) %>%
  distinct()

# 根据注释文件，转换protein_coding的gene_ID
exprSet_protein_coding <- rawdata_1 %>%
  inner_join(gtf_protein_Ensembl, by = c("Ensembl_ID" = "gene_id")) %>%
  select(gene_name, starts_with("TCGA"))

# 提取lncRNA的基因
gtf_lncRNA_Ensembl <- dplyr::select(annotation, c("gene_id", "gene_biotype", "gene_name")) %>%
  filter(gene_biotype == "lncRNA") %>%
  mutate(gene_name = ifelse(is.na(gene_name), gene_id, gene_name)) %>%
  distinct()

# 根据注释文件，转换lncRNA的gene_ID
exprSet_lncRNA <- rawdata_1 %>%
  inner_join(gtf_lncRNA_Ensembl, by = c("Ensembl_ID" = "gene_id")) %>%
  select(gene_name, starts_with("TCGA"))

#利用limma包取平均值去重
library(limma)
dim(exprSet_lncRNA)
exprSet_lncRNA <- as.data.frame(avereps(exprSet_lncRNA[,-1],ID = exprSet_lncRNA$gene_name) )
dim(exprSet_lncRNA)

dim(exprSet_protein_coding)
exprSet_protein_coding <- as.data.frame(avereps(exprSet_protein_coding[,-1],ID = exprSet_protein_coding$gene_name) )
dim(exprSet_protein_coding)


# 合并两个表达矩阵
combined_exprSet <- rbind(exprSet_protein_coding, exprSet_lncRNA)

# 保存文件
write.csv(exprSet_protein_coding, file = coding_gene_file, row.names = TRUE, fileEncoding = "UTF-8")
write.csv(exprSet_lncRNA, file = lncRNA_file, row.names = TRUE, fileEncoding = "UTF-8")
write.csv(combined_exprSet, file = combined_file, row.names = TRUE, fileEncoding = "UTF-8")
