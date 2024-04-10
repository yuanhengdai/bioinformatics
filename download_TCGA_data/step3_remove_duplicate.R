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
data_path <- "C:/D/PHD/bioinformatics/TCGA data/"
file <- "GDCdata/TCGA-KIRC/KIRC_exp_fpkm_protein_coding.csv"


file_protein_coding_fpkm <- "KIRC_exp_fpkm_protein_coding.csv"
file_lncRNA_fpkm <- "KIRC_exp_fpkm_lncRNA.csv"

# 使用变量设置工作路径
setwd(data_path)

#读取下载的表达矩阵,TCGA数据的文件名（XXXX需要自行修改）
raw_file <- "raw_data/KIRC_expr_fpkm_protein_coding.csv"
rawdata <- read.csv(raw_file, check.names = FALSE)

# 将第一列命名为 'Ensembl_ID'
colnames(rawdata)[1] <- "Ensembl_ID"

suppressPackageStartupMessages(library(tidyverse))

expr_read <- file_protein_coding_fpkm %>% 
  as_tibble() %>% # tibble不支持row name，我竟然才发现！
  mutate(meanrow = rowMeans(.[,-1]), .before=2) %>% 
  arrange(desc(meanrow)) %>% 
  distinct(symbol_mrna,.keep_all=T) %>% 
  select(-meanrow) %>% 
  column_to_rownames(var = "symbol_mrna") %>% 
  as.data.frame()
