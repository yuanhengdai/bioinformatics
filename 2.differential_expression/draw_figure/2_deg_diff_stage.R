#date: 20240422
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: draw the differential expression gene in different stage.
#update: 

#安装R包,已安装可跳过
#BiocManager::install("readr")
#BiocManager::install("ggplot2")
#BiocManager::install("ggsignif")
#BiocManager::install("ggsci")


library(ggplot2)
library(ggsignif)
library(tidyverse)  # 包括 dplyr, tidyr, 和其他 tidyverse 组件
library(ggsci) #配色

##准备工作
# 设置工作路径，设置文件名和图表标题
setwd("C:/D/PHD/bioinformatics/cancer_neuroscience/latest_clear_renal_cell_cancer")
file <- "output_data/step1_differential_expression_gene/deg_ngf_receptor.csv"

# 选出目的基因
gene <- c("SORT1")

##以下内容不要修改
# 读取CSV文件，
df <- read.csv(file)

#加载临床数据
clinical <- read.csv('output_data/matrix/clinical.csv')

# 将第一列命名为 'sample'
names(df)[1] <- "sample"

# 对除了 'sample' 和 'group' 列以外的所有列应用 log2(x+1) 转换
df_numeric <- df %>%
  mutate(across(.cols = -c(sample, group), .fns = ~log2(. + 1)))


# 选择sample, group, stage列和gene向量中指定的所有基因列
df_combined <- left_join(df_numeric, clinical[c("sample", "stage")], by = "sample") %>%
  mutate(stage = case_when(
    group == "Tumor" ~ stage,  # 如果 group 是 Tumor，保留 clinical 中的 stage
    group == "Normal" ~ "Normal",  # 如果 group 是 Normal，填入 "Normal"
    TRUE ~ stage  # 其他情况保持 stage 不变
  )) %>%
  select(sample, all_of(gene), group, stage) %>%
  filter(!is.na(stage))  # 过滤掉 stage 列为空的行

# 绘制小提琴图，并添加散点图和箱线图
p <- ggplot(df_combined, aes(x = stage, y = .data[[gene]], fill = stage)) +
  geom_violin(trim = FALSE) +  # 绘制小提琴图
  geom_boxplot(width = 0.3, outlier.shape = NA, alpha = 0.3) +  # 添加箱线图，使其半透明且隐藏异常值点
  labs(x = "Cancer Stage",
       y = paste("Expression of", gene, "\nLog2(FPKM+1)")) +
  theme_minimal() +
  scale_fill_npg()  # 使用NPG颜色



# 绘制小提琴图，并添加散点图和箱线图，同时去掉所有标签和图例
p <- ggplot(df_combined, aes(x = stage, y = .data[[gene]], fill = stage)) +
  geom_violin(trim = FALSE) +  # 绘制小提琴图
  geom_boxplot(width = 0.3, outlier.shape = NA, alpha = 0.3) +  # 添加箱线图，使其半透明且隐藏异常值点
  theme_minimal() +  # 使用简洁主题
  scale_fill_npg() +  # 使用 NPG 颜色方案
  labs(x = NULL,  # 去掉x轴标签
       y = NULL,  # 去掉y轴标签
       title = NULL,  # 如果有标题也去掉
       fill = NULL) +  # 去掉图例标题
  theme(axis.text = element_blank(),  # 去掉所有轴的刻度标签
        axis.ticks = element_blank(),  # 去掉轴的刻度线
        legend.position = "none")  # 完全去掉图例


# 打印绘图对象
print(p)

# 提取每个分期和Normal的数据
stage_I <- df_combined %>% filter(stage == "Stage I") %>% pull(gene)
stage_II <- df_combined %>% filter(stage == "Stage II") %>% pull(gene)
stage_III <- df_combined %>% filter(stage == "Stage III") %>% pull(gene)
stage_IV <- df_combined %>% filter(stage == "Stage IV") %>% pull(gene)
stage_Normal <- df_combined %>% filter(stage == "Normal") %>% pull(gene)

# 进行两两秩和检验，包括与Normal的比较
test_I_II <- wilcox.test(stage_I, stage_II, alternative = "two.sided")
test_I_III <- wilcox.test(stage_I, stage_III, alternative = "two.sided")
test_I_IV <- wilcox.test(stage_I, stage_IV, alternative = "two.sided")
test_I_Normal <- wilcox.test(stage_I, stage_Normal, alternative = "two.sided")
test_II_III <- wilcox.test(stage_II, stage_III, alternative = "two.sided")
test_II_IV <- wilcox.test(stage_II, stage_IV, alternative = "two.sided")
test_II_Normal <- wilcox.test(stage_II, stage_Normal, alternative = "two.sided")
test_III_IV <- wilcox.test(stage_III, stage_IV, alternative = "two.sided")
test_III_Normal <- wilcox.test(stage_III, stage_Normal, alternative = "two.sided")
test_IV_Normal <- wilcox.test(stage_IV, stage_Normal, alternative = "two.sided")

# 输出检验结果
list(
  test_I_II = test_I_II,
  test_I_III = test_I_III,
  test_I_IV = test_I_IV,
  test_I_Normal = test_I_Normal,
  test_II_III = test_II_III,
  test_II_IV = test_II_IV,
  test_II_Normal = test_II_Normal,
  test_III_IV = test_III_IV,
  test_III_Normal = test_III_Normal,
  test_IV_Normal = test_IV_Normal
)
