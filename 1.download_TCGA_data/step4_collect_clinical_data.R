#date: 20240407
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: download the TCGA clinical data from GDC


# 安装 TCGAbiolinks 包
#BiocManager::install("TCGAbiolinks")

library(TCGAbiolinks)


# 设置下载路径
setwd("C:/D/PHD/bioinformatics/TCGA data/")
project = "TCGA-BRCA"
final_path = "GDCdata/TCGA-BRCA/clinical.csv"
load("GDCdata/TCGA-BRCA/exp.rda")

##下面的内容不要修改
# 提取clinical数据
clinical <- do.call(cbind,data@colData@listData)


###额外添加一步，避免后期格式问题
clinical <- apply(clinical,2,as.character)
clinical <- data.frame(clinical)
head(clinical)
dim(clinical)#[1] 44 201


meta = clinical[,c('sample','vital_status','gender','age_at_index',
                   'days_to_death','days_to_last_follow_up',
                   'ajcc_pathologic_t','ajcc_pathologic_m','ajcc_pathologic_n','ajcc_pathologic_stage')]
meta <- as.data.frame(meta)
meta$age_at_index <- as.numeric(meta$age_at_index)
meta$days_to_death <- as.numeric(meta$days_to_death)
meta$days_to_last_follow_up <- as.numeric(meta$days_to_last_follow_up)
meta = data.frame(meta)
colnames(meta) = c('sample','event','gender','age','days_to_death','days_to_last_follow_up','T','M','N','stage')
meta$sex <- ifelse(meta$gender == "male",1,0)
meta$status <- ifelse(meta$event == "Dead",1,0)

m1 <- as.numeric(meta$days_to_death)
m1[is.na(m1)] <- 0
m2 <- as.numeric(meta$days_to_last_follow_up)
m2[is.na(m2)] <- 0
m3 <- m1 + m2


Special <- which(meta$days_to_death != "" & meta$days_to_last_follow_up != "")
m3[Special] <- m1[Special]
###标注缺失样本
m3[which(is.na(meta$days_to_death) & is.na(meta$days_to_last_follow_up))] <- NA
meta$time <- m3
head(meta)

write.csv(meta,final_path,row.names = F)
