#date: 20240404
#revesion: 1.0
#author: Yuanheng 
#email:Yuanheng.Dai@uon.edu.au
#function: create a function to get genes by category



class GeneManager:
    def __init__(self):
        # 初始化时将基因列表和基因类别数据存储在类实例中
        self.genes_dict = {
            "NGF": ["NGF", "BDNF", "NTF3", "NTF4"],
            "NGF_receptor": ["NGF", "NGFR", "NTRK1"],
            "GDNF": ["GDNF", "NRTN", "ARTN", "PSPN"],
            "CNTF": ["CNTF"],
            "EGF": ["EGF"],
            "FGF": [
                "FGF1", "FGF2", "FGF3", "FGF4", "FGF5", "FGF6", "FGF7", "FGF8", "FGF9",
                "FGF10", "FGF11", "FGF12", "FGF13", "FGF14", "FGF16", "FGF17", "FGF18",
                "FGF19", "FGF20", "FGF21", "FGF22", "FGF23"
            ],
            "IGF": ["IGF1", "IGF2"],
            "NTN": ["NTN1", "NTN2", "NTN3", "NTN4"],
            "SLIT": ["SLIT1", "SLIT2", "SLIT3"],
            "SEMA": [
                "SEMA3A", "SEMA3B", "SEMA3C", "SEMA3D", "SEMA3E", "SEMA3F", "SEMA3G",
                "SEMA4A", "SEMA4B", "SEMA4C", "SEMA4D", "SEMA4F", "SEMA4G", "SEMA5A",
                "SEMA5B", "SEMA6A", "SEMA6B", "SEMA6C", "SEMA6D", "SEMA7A"
            ],
            "EFN": ["EFNA1", "EFNA2", "EFNA3", "EFNA4", "EFNA5", "EFNB1", "EFNB2", "EFNB3"]
        }
        self.gene_categories = {
            "neurotrophic_factors": ["NGF", "GDNF", "CNTF"],
            "neurotrophic_like_factors": ["EGF", "FGF", "IGF"],
            "axon_guidance_molecules": ["NTN", "SLIT", "SEMA", "EFN"]
        }

    def get_genes_by_category(self, category_name):
        """
        根据指定的类别名称返回对应的基因详细列表。

        :param category_name: 类别名称（例如 "neurotrophic_factors"）
        :return: 该类别下所有基因的详细列表
        """
        genes = self.gene_categories.get(category_name, [])
        detailed_genes = []

        for gene in genes:
            detailed_genes.extend(self.genes_dict.get(gene, []))

        return detailed_genes
    
    