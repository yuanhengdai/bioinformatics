#date: 20240504
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: snakemake workflow for whole gene sequencing data processing



rule all:
    input:

rule cutadapt:
    input:
    ""

output:
    "filtered_BRCA_exp_fpkm_combined.csv",
    "deleted_sample.txt"

log:
    "snakemake.log"

shell:
    "cutad"

rule bt2_mapping:
    input:
    ""
    output:
        ""
    log:    
        "bt2_mapping.log"
    shell:
        "bowtie2 -x genome -U {input} -S {output}"
