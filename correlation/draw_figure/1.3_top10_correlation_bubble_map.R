#date: 20240331
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw top 10 positive lncRNA bubble map of different gene
#update: improve the generality


#安装R包,已安装可跳过
#BiocManager::install("readr")
#BiocManager::install("tidyr")
#BiocManager::install("dplyr")
#BiocManager::install("ggplot2")
#BiocManager::install("ggrepel")

#设置工作路径
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/")

#读取文件
file_path <- "correlation/output_data/combined_top_20_correlations_with_rank.csv"
file_path <- "correlation/output_data/combined_top_20_correlations_with_rank.csv"
cor_data <- read_csv(file_path)

library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggrepel)

#设定读取的gene和顺序
factor_gene_list <- c(
  "GABRD", "GAD1", "GAD2", "ABAT"
)
gene_list <- factor_gene_list

# 确保cor_data的Gene列按照factor_gene_list的顺序排列
cor_data <- cor_data %>%
  filter(gene_name %in% factor_gene_list) %>%
  mutate(gene_name = factor(gene_name, levels = factor_gene_list))


# 绘制图表
ggplot(cor_data, aes(x=gene_name, y=rev(rank))) +
  geom_point(aes(size=correlation, color=p_value)) +  # 绘制点
  geom_text(aes(label = lncRNA), nudge_y = -0.3) +  # 每个点加上标签
  scale_size_continuous(name="Cor(R)", range=c(0.1, 7)) +  # 设置气泡大小范围
  scale_color_gradient(low="red", high="lightgrey") +  # 设置颜色渐变
  theme_bw() +  # 使用白色背景主题
  theme(
    panel.grid = element_blank(),  # 移除网格线
    axis.text.x = element_text(face="italic", size=10),  # 设置x轴文本为斜体并增大字体大小
    axis.text.y = element_blank(),  # 移除y轴文本
    axis.ticks.y = element_blank()  # 移除y轴刻度线
  ) +
  labs(x=NULL, y=NULL)  # 移除轴标签
