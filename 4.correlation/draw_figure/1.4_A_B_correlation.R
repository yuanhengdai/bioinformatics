#date: 20240331
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw plot figure of two different genes and show the correlation efficiency
#update: improve the generality


# 安装R包,已安装可跳过
BiocManager::install("readr")
BiocManager::install("ggplot2")
BiocManager::install("ggpubr")
BiocManager::install("dplyr")

# 加载必要的包
library(readr)
library(ggplot2)
library(ggpubr)
library(dplyr)

# 设置工作路径
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/")
file_name <- "correlation/output_data/ENSG00000268287_NTF4.csv"

# 读取文件
df <- read_csv(file_name)

# 输入想要绘制的基因名(需要修改)
gene_x <- "NTF4"
gene_y <- "ENSG00000268287"

# 绘制散点图并添加线性回归线
ggscatter(df, x = gene_x, y = gene_y,
          add = "reg.line", conf.int = TRUE,
          add.params = list(fill = "lightgray"),
          ggtheme = theme_minimal()) +
  stat_cor(method = "pearson",
           label.x = 1,  # 根据实际情况调整这些值
           label.y = 1,  # 以确保标签在图内
           color = "red", p.accuracy = 0.001) +
  labs(x = bquote("FPKM(" * italic(.(gene_x)) * ")"),  # 动态设置x轴标签，仅gene_x为斜体
       y = paste("FPKM(", gene_y, ")")) +  # 动态设置y轴标签
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))  # 调整边距

