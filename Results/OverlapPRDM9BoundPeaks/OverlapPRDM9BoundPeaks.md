Overlap
human DSB hotspots vs direct PRDM9 binding sites
human DSB hotspots vs pan cancer PRDM9 bound peaks
direct PRDM9 binding sites vs pan cancer PRDM9 bound peaks
# Input 
direct PRDM9 binding sites
```bash
# download
wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE99nnn/GSE99407/suppl/GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt.gz
# uncompress
gzip -d GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt.gz
# extract peak center
grep -v "center_start" GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt | awk '{FS=OFS="\t"; print $1,$2,$3;}' > HEK293T_PRDM9Binding_PeakCenters.bed
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
eyJoaXN0b3J5IjpbMjI0Njk5MzY5LC01MjQzMjM2MDAsODc1OT
IxODUsLTEyOTQ1NjMyNzIsMzk1MTI4MTgxLC0xOTk1OTQ4NzYx
LDE5OTM2MTI1MiwxMDg1OTU2MjQ0XX0=
-->