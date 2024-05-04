#date: 20240422
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
library(dplyr)

#设置工作路径
setwd('C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer') 

#设置读取路径
raw_exp <- "output_data/step2_survival_analysis/tumor_coding_gene_matrix.csv"

#读取表达矩阵
gene_exp0 <- read.csv(raw_exp, row.names = 1, check.names = FALSE)  #把第一列作为索引

#加载临床数据
clinical <- read.csv('output_data/matrix/clinical.csv')

# 将时间单位转换为年
clinical$time <- round(clinical$time / 365, 2)

# 只选择 Stage I 和 Stage II 的病例
clinical <- clinical %>% filter(stage %in% c("Stage I","Stage II"))

# 只选择 Stage III 和 Stage IV 的病例
clinical <- clinical %>% filter(stage %in% c("Stage III", "Stage IV"))


#选择要分析的基因
selected_gene <- 'NTRK1'  
gene_exp <- gene_exp0[selected_gene,]

#对所选基因进行生存分析
GENE <- t(gene_exp)[rownames(t(gene_exp)) %in% clinical$sample, ]
low_quantile = quantile(GENE, 0.2, na.rm = TRUE)
high_quantile = quantile(GENE, 0.8, na.rm = TRUE)

GENE = data.frame(GENE) 
GENE$group = ifelse(GENE[,1] > high_quantile, 'high', 'low')


# 合并临床数据和基因表达数据
gene_clinical <- merge(clinical, GENE, by.x="sample", by.y="row.names")
colnames(gene_clinical)[ncol(gene_clinical)] <- "expression_group"

# 转换时间和状态变量为适当的格式
gene_clinical$time <- as.numeric(as.character(gene_clinical$time))
gene_clinical$status <- as.numeric(as.character(gene_clinical$status))

# 去除重复的样本，保留第一次出现的记录
gene_clinical <- gene_clinical %>%
  distinct(sample, .keep_all = TRUE)


# 进行生存分析
surv_obj <- Surv(gene_clinical$time, gene_clinical$status)
fit <- survfit(surv_obj ~ expression_group, data = gene_clinical)

# 使用ggsurvplot绘制生存曲线
ggsurvplot(fit, data = gene_clinical, pval = TRUE, conf.int = FALSE,
           risk.table = TRUE, 
           xlab = "Years", ylab = "Percentage survival",
           risk.table.height = 0.2, # 风险表的高度
           ggtheme = theme_minimal(), # 使用简洁主题
           palette = c("red", "blue"), # 定义组的颜色
           break.x.by = 2.5) # 设置x轴的刻度间隔

# 使用ggsurvplot绘制生存曲线，去除坐标轴标题、刻度标签和图例文字
ggsurvplot(
  fit, data = gene_clinical, conf.int = FALSE,
  risk.table.height = 0.2, # 风险表的高度
  ggtheme = theme_minimal() + 
    theme(axis.title = element_blank(),       # 移除所有轴标题
          axis.text = element_blank(),        # 移除所有轴刻度文字
          axis.ticks = element_blank(),       # 移除所有轴的刻度线
          legend.text = element_blank(),      # 移除图例文字
          legend.title = element_blank()),    # 移除图例标题
  xlab = "", ylab = "", # 移除坐标轴标题
  palette = c("red", "blue"), # 定义组的颜色
  break.x.by = 2.5 # 设置x轴的刻度间隔
)

