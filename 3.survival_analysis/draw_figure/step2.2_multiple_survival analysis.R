

#安装R包,已安装可跳过
BiocManager::install("survival")
BiocManager::install("survminer")

library(survival)
library(survminer)
library(ggplot2)


#设置工作路径
setwd('C:/D/PHD/bioinformatics/Cancer neuroscience/') 

#设置读取路径（需要自行修改）
raw_exp <- "survival_analysis/output_data/tumor_coding_gene_matrix.csv"


#设置导出的文件名和路径
output_dir <- "/survival_analysis/figures/"
#如果不存在就创建
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

#设置基因列表
gene_list <- c('NTF4', 'GFRA1', 'NRTN', 'CNTFR', 'NGFR', 'NTRK2', 'NTRK3', 
               'CNTF', 'BDNF', 'NTF3', 'GDNF', 'NGF', 'NTRK1', 'SORT1', 'GFRA2', 
               'RET', 'GFRA3')

#读取表达矩阵
gene_exp0 <- read.csv(raw_exp, row.names = 1, check.names = FALSE)  #把第一列作为索引


#gene_list是用来做生存分析的基因列表
gene_exp <- gene_exp0[gene_list,]

#加载临床数据
clinical <- read.table('raw_data/survival_PRAD_survival.txt',check.names = FALSE,sep = '\t',header=T)


##survival_COADREAD_survival.txt是在UCSC xena上下载的,在这里可以下载到TCGA数据库中的各种癌症样本的生存信息。
#UCSC xena中TCGA癌症的生存数据的下载链接https://xenabrowser.net/datapages/?host=https%3A%2F%2Ftcga.xenahubs.net&removeHub=https%3A%2F%2Fxena.treehouse.gi.ucsc.edu%3A443

survival_Gene <- c()  #用来存放生存相关的基因
for (i in gene_list){
  GENE = t(gene_exp[which(row.names(gene_exp)==i),]) 
  low_quantile = quantile(GENE,0.5,na.rm = TRUE)  #0.5是将样本划分为两组。四分位数生存分析时此处为0.25
  high_quantile = quantile(GENE,0.5,na.rm = TRUE) 
  
  GENE = data.frame(GENE) 
  GENE2 = GENE
  
  GENE[GENE[,1]>high_quantile,] <- 'high'
  GENE[GENE2[,1]<=low_quantile,] <- 'low'
  
  #匹配合并
  gene_clinical = data.frame(clinical[match(rownames(GENE),clinical$sample),],GENE)
  
  #View(gene_clinical)
  gene_clinical <- gene_clinical[(gene_clinical[,12]=='high')|(gene_clinical[,12]=='low'),]
  
  gene_clinical[,12]<-ifelse((gene_clinical[,12]=='high'),1,2)  #高表达改为1，低表达改为2
  
  CRC <- gene_clinical
  colnames(CRC)[12] <- 'Genename'
  
  fit.surv <- Surv(CRC$OS.time,CRC$OS)
  km_2<- survfit(fit.surv~Genename,data=CRC)
  
  sdiff <- survdiff(Surv(CRC$OS.time,CRC$OS)~Genename, data=CRC)
  pval = 1 - pchisq(sdiff$chisq, length(sdiff$n) - 1)
  if(pval<=0.05) {
    survival_Gene <- append(survival_Gene,i)
  }
  output_filename <- paste0(output_dir, i, ".jpg")
  png(filename = output_filename)
  
  g <- ggsurvplot(km_2,size = 2,
                  title='Overall Survival',
                  font.title=c(26,'bold'),
                  legend='top',
                  legend.title=i,
                  legend.labs=c('high','low'),
                  font.legend=c(20,'bold'),
                  linetype = 'strata',
                  xlab='Days',
                  ylab='Percent survival',
                  font.x=c(24,'bold','black'),
                  font.y=c(24,'bold','black'),
                  font.tickslab=c(20,'bold','black'),
                  pval = TRUE,
                  pval.size=7,
                  pval.coor=c(2200,1),
                  pval.method = TRUE,
                  pval.method.size=7,
                  pval.method.coor=c(1300,1)
  )
  print(g)  #输出生存分析图，储存在当前工作目录下
  dev.off()
}

print(survival_Gene)  #"CHST1" "CHSY3" "COMP" 即为生存相关基因
print(length(survival_Gene))
