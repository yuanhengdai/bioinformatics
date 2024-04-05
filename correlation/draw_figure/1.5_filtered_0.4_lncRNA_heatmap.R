#date: 20240331
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: show the correlation efficiency
#update: improve the generality


# 安装R包,已安装可跳过
BiocManager::install("readr")
BiocManager::install("ggplot2")
BiocManager::install("ggpubr")
BiocManager::install("dplyr")

# 设置工作路径
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/")

# 载入R包
library(ggplot2)
library(dplyr)

genes_list <- c(
  'NTF4', 'NRTN', 'CNTF', 'BDNF', 'NTF3', 'GDNF', 'NGF', 'SORT1'
)

# 读入数据
df <- read.csv("correlation/output_data/filtered_lncRNA_correlation.csv")

file_path <- "correlation/output_data/filtered_lncRNA_list.txt"
lncRNA_list <- readLines(file_path) # 读取lncRNA列表
selected_top_lncRNA <- rev(c(lncRNA_list))  # 换一下排序

# 筛选gene_name在genes_list中的数据
df <- df %>%
  filter(gene_name %in% genes_list)

# 使用ggplot2绘图
# 绘制基本的热图，指定数据源，设置x轴为gene_name，y轴为lncRNA，填充颜色基于correlation值
ggplot(data = df, aes(y=lncRNA, x=gene_name, fill=correlation)) +
  geom_tile() +  # 添加瓦片图层，用于显示每个Gene和lncRNA之间的相关性
  geom_text(aes(label = ifelse(abs(correlation) > 0.7, sprintf("%.2f", correlation), "")), 
            color = "black", size = 2.5) +  # 添加文本图层，显示特定条件下的标签
  scale_fill_gradient2(low = "lightseagreen", high = "red3", mid = "white", 
                       midpoint = 0, limits = c(-1, 1)) +  # 设置填充颜色渐变
  theme_minimal() +  # 使用简约主题
  labs(fill = "Cor(R)") +  # 设置填充颜色图例的标签
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, face = "italic"),  # X轴文本样式设置为斜体，旋转45度
    axis.title.x = element_blank()  # 去掉X轴标题
  )

