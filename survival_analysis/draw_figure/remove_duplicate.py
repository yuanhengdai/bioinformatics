import os
import csv

# 设置工作路径
work_path = r'C:\D\PHD\bioinformatics\TCGA data\GDCdata\TCGA-KIRC'
os.chdir(work_path)

# 读取CSV文件并获取特定列的数据
file_name = 'compare_patients_list.csv'  # 将文件名替换为您的CSV文件名
column_name = 'TCGA_official_website_16'  # 设定要读取的列名

# 读取CSV文件并收集指定列的数据
with open(file_name, mode='r') as csvfile:
    reader = csv.DictReader(csvfile)
    id_list = [row[column_name] for row in reader if row[column_name]]

# 计算每个ID出现的次数
id_counts = {}
for id in id_list:
    id_counts[id] = id_counts.get(id, 0) + 1

# 分别收集唯一的ID和重复的ID
unique_ordered_ids = [id for id, count in id_counts.items() if count == 1]
repeated_ids = [id for id, count in id_counts.items() if count > 1]

# 打印唯一ID的数量
print(f"Number of unique IDs: {len(unique_ordered_ids)}")

# 打印重复ID的数量
print(f"Number of repeated IDs: {len(repeated_ids)}")

# 导出唯一的ID
with open('unique_ids.txt', 'w') as f:
    for unique_id in unique_ordered_ids:
        f.write(unique_id + '\n')

# 导出重复的ID
with open('repeated_ids.txt', 'w') as f:
    for repeated_id in repeated_ids:
        f.write(repeated_id + '\n')

# 检查文件是否正确写入
print(f"Unique IDs are written to 'unique_ids.txt'.")
print(f"Repeated IDs are written to 'repeated_ids.txt'.")


