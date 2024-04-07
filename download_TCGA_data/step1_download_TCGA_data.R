#date: 20240407
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: download the TCGA data from GDC



# 安装 TCGAbiolinks 包
#BiocManager::install("TCGAbiolinks")

library(TCGAbiolinks)


# 设置下载路径
setwd("C:/D/PHD/bioinformatics/TCGA data/")

# 设置下载参数(下载gene表达原始数据)
query <- GDCquery(project = "TCGA-KIRC", 
                  data.category = "Transcriptome Profiling", 
                  data.type = "Gene Expression Quantification", 
                  workflow.type = "STAR - Counts")

# 根据设置的参数下载数据
GDCdownload(query)

query.exp.hg38 <- query 

# 提取表达矩阵
expdat <- GDCprepare(
  query = query.exp.hg38,
  save = TRUE, 
  save.filename = "GDCdata/TCGA-KIRC/exp.rda"
)
