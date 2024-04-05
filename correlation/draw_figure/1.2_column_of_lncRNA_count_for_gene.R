#date: 20240330
#revesion: 2.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw overview heatmap
#update: improve the generality


#安装R包,已安装可跳过
##BiocManager::install("tidyr")
#BiocManager::install("dplyr")
#BiocManager::install("ggplot2")

# 加载必要的库
library(ggplot2)
library(tidyr)
library(dplyr)

#设置工作路径
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/")
file_path <- "correlation/output_data/correlation_counts_gene.csv"

# 加载必要的库
library(ggplot2)
library(tidyr)
library(dplyr)

# 读取数据
result <- read.csv(file_path)

# 转换数据为长格式
long_data <- pivot_longer(result, cols = c('count_correlation_pos_0.4', 'count_correlation_neg_0.4'),
                          names_to = "Type", values_to = "Count")

# 重新编码 'Type' 列以获得更有意义的图例标签
long_data <- long_data %>%
  mutate(Type = recode(Type,
                       'count_correlation_pos_0.4' = 'R > 0.4 (Positive)',
                       'count_correlation_neg_0.4' = 'R < -0.4 (Negative)'))

# 定义接受体基因列表
factor_gene_list <- rev(c( 
  "NGF", "BDNF", "NTF3", "NTF4", "GDNF", "NRTN", "ARTN", "PSPN", "CNTF", 
  "NTN1", "NTN3", "NTN4", "SLIT1", "SLIT2", "SLIT3", "SEMA3A", "SEMA3B", 
  "SEMA3C", "SEMA3D", "SEMA3E", "SEMA3F", "SEMA3G", "SEMA4A", "SEMA4B", 
  "SEMA4C", "SEMA4D", "SEMA4F", "SEMA4G", "SEMA5A", "SEMA5B", "SEMA6A", 
  "SEMA6B", "SEMA6C", "SEMA6D", "SEMA7A", "EFNA1", "EFNA2", "EFNA3", 
  "EFNA4", "EFNA5", "EFNB1", "EFNB2", "EFNB3"
  ))

# 确保基因名按照列表顺序
long_data$`gene_name` <- factor(long_data$`gene_name`, levels = factor_gene_list)

# 筛选接受体基因，保持给定列表的顺序
factor_data <- long_data %>%
  filter(`gene_name` %in% factor_gene_list)

# 绘制接基因图
ggplot(factor_data, aes(x = `gene_name`, y = Count, fill = Type)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Number of lncRNAs with Strong Correlation to Neurotrophic Factor Genes", x = "", y = "", fill = "Cor(R)") +
  scale_y_continuous(limits = c(0, 150)) +  # 由于使用了coord_flip，这里使用scale_y_continuous来设置x轴的范围
  scale_fill_manual(values = c('R > 0.4 (Positive)' = 'red', 'R < -0.4 (Negative)' = 'blue')) +
  theme_minimal() +
  theme(axis.text.y = element_text(face = "italic"))

