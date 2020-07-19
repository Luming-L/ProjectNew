# Overlap PRDM9 binding sites in laboratory human kidney cells transfected with PRDM9 with human DSB hotspots
## Input 
PRDM9 binding sites in laboratory human kidney cells transfected with PRDM9
```bash
# download
wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE99nnn/GSE99407/suppl/GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt.gz
# uncompress
gzip -d GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt.gz
# extract peak center
grep -v "center_start" GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt | awk '{FS=OFS="\t"; print $1,$2,$3;}' > PRDM9BindingSites_PeakCenter_Kidney.bed
# 
```
human DSB hotspots
## Process
## Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwMjE0MjM1MTQsMTk5MzYxMjUyLDEwOD
U5NTYyNDRdfQ==
-->