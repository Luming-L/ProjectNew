Overlap 
PRDM9 binding sites in laboratory human kidney cells transfected with PRDM9 with human DSB hotspots
# Input 
PRDM9 binding sites in laboratory human kidney cells transfected with PRDM9
```bash
# download
wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE99nnn/GSE99407/suppl/GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt.gz
# uncompress
gzip -d GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt.gz
# extract peak center
grep -v "center_start" GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt | awk '{FS=OFS="\t"; print $1,$2,$3;}' > PRDM9BindingSites_PeakCenter_Kidney.bed
# liftOver to hg38
~/Tools/liftOver PRDM9BindingSites_PeakCenter_Kidney.bed ~/Tools/hg19ToHg38.over.chain PRDM9BindingSites_PeakCenter_Kidney.hg38.bed unMapped
```
human DSB hotspots
```bahs
cp ~/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt ./
```

# Process
### count overlap
```bash
# count overlap
bedtools intersect -a ~/project/OverlapPRDM9BoundPeaks/humanDSBhotspots_AA_AB.hg38.txt.temp -b ~/project/OverlapPRDM9BoundPeaks/PRDM9BindingSites_PeakCenter_Kidney.hg38.bed.temp -u | wc -l
```
### Overlap correction
```bash

```
# Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbMzIxMDI0OTU5LDg3NTkyMTg1LC0xMjk0NT
YzMjcyLDM5NTEyODE4MSwtMTk5NTk0ODc2MSwxOTkzNjEyNTIs
MTA4NTk1NjI0NF19
-->