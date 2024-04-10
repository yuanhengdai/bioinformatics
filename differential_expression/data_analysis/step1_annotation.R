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
# 设置工作路径（需要自行修改）
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/20240408_TCGA")

#读取下载的表达矩阵,TCGA数据的文件名（XXXX需要自行修改）
raw_file <- "raw_data/KIRC_expr_fpkm_protein_coding.csv"
rawdata <- read.csv(raw_file, check.names = FALSE)

# 修改列名，只保留每个列名的前16个字符
colnames(rawdata) <- substr(colnames(rawdata), 1, 16)

# 将第一列命名为 'Ensembl_ID'
colnames(rawdata)[1] <- "Ensembl_ID"

# 找出重复列并计算平均值，只保留平均值最大的列
rawdata <- rawdata %>%
  select(Ensembl_ID, sort(unique(colnames(rawdata)[-1]))) %>%
  group_by(Ensembl_ID) %>%
  summarise(across(everything(), ~ mean(.[which.max(colMeans(.))], na.rm = TRUE)))

# 对于每个Ensembl_ID，选择最大的表达值
max_expr_data <- rawdata %>%
  group_by(Ensembl_ID) %>%
  summarise(across(starts_with("TCGA"), max, na.rm = TRUE))

#设置导出的文件名和路径（禁止修改）
coding_gene_file <- "differential_expression/output_data/coding_gene_matrix.csv"

# 如果不存在，创建输出文件夹
output_dir <- dirname(lncRNA_file)
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}


##正式开始
#读取注释文件
raw_annotation <- 'raw_data/gencode.v45.annotation.gtf.gz'
annotation <- rtracklayer::import(raw_annotation) %>% as.data.frame() #转换为dataframe

#提取protein_coding的基因
gtf_protein_GENECODE <- dplyr::select(annotation,c("gene_id","gene_type", "gene_name")) %>%
  subset(., gene_type == "protein_coding") %>% unique()

# 根据注释文件，转换protein_coding的gene_ID
exprSet <- rawdata %>%
  inner_join(gtf_protein_GENECODE, by = c("Ensembl_ID" = "gene_id")) %>%
  select(gene_name, starts_with("TCGA"))

#利用limma包取平均值去重
library(limma)
dim(exprSet_lncRNA)
exprSet_lncRNA <- as.data.frame(avereps(exprSet_lncRNA[,-1],ID = exprSet_lncRNA$gene_name) )
dim(exprSet_lncRNA)


##保存文件
#分别导出三个文件
write.csv(exprSet_lncRNA, file = lncRNA_file, fileEncoding = "UTF-8")
write.csv(exprSet_protein_coding, file = coding_gene_file, fileEncoding = "UTF-8")
write.csv(combined_exprSet, file = combined_file, fileEncoding = "UTF-8")
