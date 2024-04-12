#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw overview heatmap
#update: improve the generality

#安装R包,已安装可跳过
#BiocManager::install("readr")
#BiocManager::install("tidyr")
#BiocManager::install("dplyr")
#BiocManager::install("ggplot2")


#设置工作路径
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/")

library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

file <- "correlation/output_data/combined_correlation_results.csv"

#读入数据
df <- read.csv(file)

# 或者将NA替换为一个特定的值，例如0
df[is.na(df)] <- 0

# 指定x轴基因显示顺序
gene_order <- c(
  "NGF", "BDNF", "NTF3", "NTF4", "GDNF", "NRTN", "ARTN", "PSPN", "CNTF", 
  "NTN1", "NTN3", "NTN4", "SLIT1", "SLIT2", "SLIT3", "SEMA3A", "SEMA3B", 
  "SEMA3C", "SEMA3D", "SEMA3E", "SEMA3F", "SEMA3G", "SEMA4A", "SEMA4B", 
  "SEMA4C", "SEMA4D", "SEMA4F", "SEMA4G", "SEMA5A", "SEMA5B", "SEMA6A", 
  "SEMA6B", "SEMA6C", "SEMA6D", "SEMA7A", "EFNA1", "EFNA2", "EFNA3", 
  "EFNA4", "EFNA5", "EFNB1", "EFNB2", "EFNB3"
)

# 创建热图，并按照指定的gene_order顺序显示X轴
ggplot(df, aes(x = factor(gene_name, levels = gene_order), y = lncRNA, fill = correlation)) +
  geom_tile() +
  scale_fill_gradient2(low = "purple", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name="Cor(R)") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, face = "italic"),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank()
  ) +
  xlab(" ") +
  ylab("lncRNA")

