#date: 20240405
#revesion: 1.0
#author: Yuanheng
#e-mail: Yuanheng.Dai@uon.edu.au
#function: Survival analysis for single gene
#update: 

#安装R包,已安装可跳过
#BiocManager::install("readr")
#BiocManager::install("survival")
#BiocManager::install("survminer")
#BiocManager::install("ggplot2")

#加载必要的库
library(readr)
library(survival)
library(survminer)
library(ggplot2)

#设置工作路径
setwd('C:/D/PHD/bioinformatics/cancer_neuroscience/') 

#设置读取路径
raw_exp <- "survival_analysis/output_data/tumor_coding_gene_matrix.csv"

#读取表达矩阵
gene_exp0 <- read.csv(raw_exp, row.names = 1, check.names = FALSE)  #把第一列作为索引

#加载临床数据
clinical <- read_tsv('raw_data/TCGA-KIRC.survival.tsv')

#选择要分析的基因
selected_gene <- 'NGF'  #或其他你感兴趣的基因
gene_exp <- gene_exp0[selected_gene,]

#对所选基因进行生存分析
GENE = t(gene_exp[which(row.names(gene_exp) == selected_gene),]) 
low_quantile = quantile(GENE, 0.5, na.rm = TRUE)
high_quantile = low_quantile  # 对于中位数划分，高和低四分位数是相同的

GENE = data.frame(GENE) 
GENE$group = ifelse(GENE[,1] > high_quantile, 'high', 'low')
row.names(GENE) <- NULL  # 移除行名，以便于合并

# 合并临床数据和基因表达数据
gene_clinical <- merge(clinical, GENE, by="row.names")
colnames(gene_clinical)[ncol(gene_clinical)] <- "expression_group"


write.csv(gene_clinical, file = "survival_analysis/output_data/gene_clinical.csv", row.names = FALSE)

# 导入合并后的数据集
gene_clinical <- read.csv('gene_clinical.csv', check.names = FALSE)

# 转换时间和状态变量为适当的格式
gene_clinical$OS.time <- as.numeric(as.character(gene_clinical$OS.time))
gene_clinical$OS <- as.numeric(as.character(gene_clinical$OS))

# 进行生存分析
surv_obj <- Surv(gene_clinical$OS.time, gene_clinical$OS)
fit <- survfit(surv_obj ~ expression_group, data = gene_clinical)

# 使用ggsurvplot绘制生存曲线
ggsurvplot(fit, data = gene_clinical, pval = TRUE, conf.int = TRUE,
           risk.table = TRUE, 
           xlab = "Months", ylab = "Percentage survival",
           risk.table.height = 0.2, # 风险表的高度
           ggtheme = theme_minimal(), # 使用简洁主题
           palette = c("blue", "red")) # 定义组的颜色






