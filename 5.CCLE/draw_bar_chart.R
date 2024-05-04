#date: 20240425
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw the gene expression in different cell line.
#update: 

#安装R包,已安装可跳过
#BiocManager::install("readr")
#BiocManager::install("ggplot2")
#BiocManager::install("ggsignif")
#BiocManager::install("ggsci")


library(ggplot2)
library(tidyverse)  # 包括 dplyr, tidyr, 和其他 tidyverse 组件
library(ggsci) #配色

##准备工作
# 设置工作路径，设置文件名和图表标题
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer")
file <- "output_data/step4_CCLE_cell_line/cell-line-selector from CCLE.csv"

##以下内容不要修改
# 读取CSV文件，
df <- read.csv(file,check.names = FALSE)

# 提取需要的列
df_selected <- df %>%
  select("displayName", "NGF") %>%
  drop_na()  # 去除缺失值

# 将 displayName 转换为因子，保留其原始顺序
df_selected$displayName <- factor(df_selected$displayName, levels = unique(df_selected$displayName))

# 绘制柱状图
ggplot(df_selected, aes(x = displayName, y = NGF)) +
  geom_bar(stat = "identity", fill = "steelblue", show.legend = FALSE) +
  theme_minimal() +
  labs(x = NULL, y = NULL, title = NULL) +  # 移除所有标题
  theme(axis.title.x = element_blank(),    # 移除x轴标题
        axis.title.y = element_blank(),    # 移除y轴标题
        plot.title = element_blank(),      # 移除图片标题
        axis.text.x = element_text(angle = 45, hjust = 1),  # 调整x轴文字
        plot.margin = margin(t = 10, r = 10, b = 10, l = 20, unit = "pt"))  # 调整图形边缘空间

# 筛选特定的细胞系
selected_cell_lines <- c("786O", "769P", "CAKI1", "A498", "A704")
df_selected <- df %>%
  filter(displayName %in% selected_cell_lines) %>%
  select(displayName, NGF) %>%
  drop_na()  # 去除缺失值

# 将 displayName 转换为因子，保留其原始顺序
df_selected$displayName <- factor(df_selected$displayName, levels = unique(df_selected$displayName))

# 绘制柱状图
ggplot(df_selected, aes(x = displayName, y = NGF)) +
  geom_bar(stat = "identity", fill = "steelblue", show.legend = FALSE) +
  theme_minimal() +
  labs(x = NULL, y = NULL, title = NULL) +  # 移除所有标题
  theme(axis.title.x = element_blank(),    # 移除x轴标题
        axis.title.y = element_blank(),    # 移除y轴标题
        plot.title = element_blank(),      # 移除图片标题
        axis.text.x = element_text(angle = 45, hjust = 1),  # 调整x轴文字
        axis.ticks.x = element_blank(),    # 移除x轴刻度
        plot.margin = margin(t = 10, r = 10, b = 10, l = 20, unit = "pt"), # 调整图形边缘空间
        panel.grid.minor = element_blank()) # 移除次要网格线
