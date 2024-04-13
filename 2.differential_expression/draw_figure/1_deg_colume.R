#date: 20240405
#revesion: 1.1
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw the differential expression gene colume
#update: improve the generality, add the p value and fillter genes

#安装R包,已安装可跳过
#BiocManager::install("readr")
#BiocManager::install("ggplot2")
#BiocManager::install("ggsignif")

library(ggplot2)
library(ggsignif)
library(tidyverse)  # 包括 dplyr, tidyr, 和其他 tidyverse 组件

##准备工作
# 设置工作路径，设置文件名和图表标题
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer")
file <- "output_data/step1_differential_expression_gene/deg_neurotrophic_factors.csv"
title_of_figure <- "Differential Expression of Neurotrophic Genes"

# 指定x轴基因显示顺序
gene_order <- c(
  "NGF", "BDNF", "NTF3", "NTF4", "GDNF", "NRTN", "ARTN", "PSPN", "CNTF"
)

##以下内容不要修改
# 读取CSV文件，设定第一行为列名，第一列为行名
df <- read.csv(file, header = TRUE, row.names = 1)

# 对所有除'group'外的列执行对数转换
df_numeric <- df %>%
  mutate(across(-group, ~log2(as.numeric(as.character(.)) + 1)))

# 转换数据为长格式并过滤不在gene_order中的基因
df_long <- df_numeric %>%
  pivot_longer(cols = -group, names_to = "gene", values_to = "expression") %>%
  filter(gene %in% gene_order) %>%
  mutate(gene = factor(gene, levels = gene_order))  # 确保基因顺序

# 绘制箱线图
p <- ggplot(df_long, aes(x = gene, y = expression, fill = group)) +
  geom_boxplot(outlier.size = 0.5) +
  scale_x_discrete(name = "Gene") +
  scale_y_continuous(name = "Gene Expression \n (log2(FPKM+1))") +
  labs(title = title_of_figure, fill = "Group") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, face="italic"),
        axis.title.x = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual(values = c("Tumor" = "tomato", "Normal" = "blue"))

# 计算每个基因的 Tumor 和 Normal 组间的 t 检验
signif_annotations <- df_long %>%
  group_by(gene) %>%
  summarise(p.value = t.test(expression[group == "Tumor"], expression[group == "Normal"])$p.value) %>%
  mutate(signif = case_when(
    p.value < 0.001 ~ '***',
    p.value < 0.01 ~ '**',
    p.value < 0.05 ~ '*',
    TRUE ~ 'ns'
  )) %>%
  filter(p.value < 0.05)  # 仅保留有统计学意义的结果

# 添加显著性标记到图上
max_y <- max(df_long$expression, na.rm = TRUE) + 0.2  # Add a constant value to position the annotations
for(i in 1:nrow(signif_annotations)) {
  p <- p + geom_signif(
    annotation = signif_annotations$signif[i],
    y_position = max_y,
    xmin = which(gene_order == signif_annotations$gene[i]) - 0.4,
    xmax = which(gene_order == signif_annotations$gene[i]) + 0.4
  )
}

# 打印绘图对象
print(p)
