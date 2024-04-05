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
#BiocManager::install("limma")

library(readr)
library(tidyr)
library(dplyr)
library(rtracklayer)
## 前期准备
# 设置工作路径（需要自行修改）
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/")

#读取下载的表达矩阵,TCGA数据的文件名（XXXX需要自行修改）
raw_file <- "raw_data/TCGA-KIRC.htseq_fpkm.tsv.gz"
TCGA_rawdata <- read_tsv(raw_file)

#设置导出的文件名和路径（禁止修改）
lncRNA_file <- "differential_expression/output_data/lncRNA_matrix.csv"
coding_gene_file <- "differential_expression/output_data/coding_gene_matrix.csv"
combined_file <- "differential_expression/output_data/combined_matrix.csv"


##正式开始
#读取注释文件
raw_annotation <- 'raw_data/gencode.v45.annotation.gtf.gz'
annotation <- rtracklayer::import(raw_annotation) %>% as.data.frame() #转换为dataframe

#去掉gene_ID .后的数字
TCGA_rawdata_1 <- separate(TCGA_rawdata, Ensembl_ID,into= c("Ensembl_ID"),sep="\\.")
TCGA_rawdata_1[1:4,1:4]


#提取lncRNA的基因
gtf_lncrna_GENECODE <- dplyr::select(annotation,c("gene_id","gene_type", "gene_name")) %>%
  subset(., gene_type == "lncRNA") %>% unique()

#去掉lncRNA gene_ID .后的数字
gtf_lncrna_GENECODE_1 <- separate(gtf_lncrna_GENECODE, gene_id,into= c("gene_id"),sep="\\.")


#提取protein_coding的基因
gtf_protein_GENECODE <- dplyr::select(annotation,c("gene_id","gene_type", "gene_name")) %>%
  subset(., gene_type == "protein_coding") %>% unique()

#去掉protein_coding gene_ID .后的数字
gtf_protein_GENECODE_1 <- separate(gtf_protein_GENECODE, gene_id,into= c("gene_id"),sep="\\.")


#根据注释文件，转换lncRNA的gene_ID
exprSet_lncRNA <- TCGA_rawdata_1 %>%
  inner_join(gtf_lncrna_GENECODE_1, by = c("Ensembl_ID" = "gene_id")) %>%
  select(gene_name, starts_with("TCGA") )

#根据注释文件，转换protein_coding的gene_ID
exprSet_protein_coding <- TCGA_rawdata_1 %>%
  inner_join(gtf_protein_GENECODE_1, by = c("Ensembl_ID" = "gene_id")) %>%
  select(gene_name, starts_with("TCGA") )

#利用limma包取平均值去重
library(limma)
dim(exprSet_lncRNA)
exprSet_lncRNA <- as.data.frame(avereps(exprSet_lncRNA[,-1],ID = exprSet_lncRNA$gene_name) )
dim(exprSet_lncRNA)

dim(exprSet_protein_coding)
exprSet_protein_coding <- as.data.frame(avereps(exprSet_protein_coding[,-1],ID = exprSet_protein_coding$gene_name) )
dim(exprSet_protein_coding)

# 合并lncRNA和protein_coding的表达集
combined_exprSet <- rbind(
  cbind(exprSet_lncRNA), 
  cbind(exprSet_protein_coding)
)



##保存文件
#分别导出三个文件
write.csv(exprSet_lncRNA, file = lncRNA_file, fileEncoding = "UTF-8")
write.csv(exprSet_protein_coding, file = coding_gene_file, fileEncoding = "UTF-8")
write.csv(combined_exprSet, file = combined_file, fileEncoding = "UTF-8")
