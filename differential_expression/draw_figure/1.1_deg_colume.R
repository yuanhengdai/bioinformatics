#date: 20240405
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw the differential expression gene colume
#update: improve the generality

#安装R包,已安装可跳过
#BiocManager::install("readr")
#BiocManager::install("ggplot2")
#BiocManager::install("ggsignif")

library(ggplot2)
library(ggsignif)

#设置工作路径
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/")

file <- "differential_expression/output_data/step3/deg_neurotrophic_factors.csv"

title_of_figure <- "Differential Expression of Neurotrophic Genes"
#读入数据
df <- read.csv(file)

# 指定x轴基因显示顺序
gene_order <- c(
  "NGF", "BDNF", "NTF3", "NTF4", "GDNF", "NRTN", "ARTN", "PSPN", "CNTF"
)

# 转换数据为长格式
df_long <- df %>%
  pivot_longer(cols = -c(1, group), names_to = "gene", values_to = "expression") %>%
  mutate(gene = factor(gene, levels = gene_order))  # 确保基因顺序

# 绘制箱线图
p <- ggplot(df_long, aes(x = gene, y = expression, fill = group)) +
  geom_boxplot(outlier.size = 0.5) +
  scale_x_discrete(name = "Gene") +
  scale_y_continuous(name = "The expression of gene \n log2(FPKM+1)") +
  labs(
    title = title_of_figure,
    fill = "Group"  # 设置图例标题
  ) +
  theme(
    axis.text.x = element_text(face="italic"),  # 更垂直的角度
    axis.title.x = element_blank(),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(hjust = 0.5)  # 居中标题
  ) +
  scale_fill_manual(values = c("Tumor" = "tomato", "Normal" = "darkkhaki"))

# 打印绘图对象
print(p)

