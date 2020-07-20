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

# extract peak centers
grep -v "center_start" GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt | awk '{FS=OFS="\t"; print $1,$2,$3;}' > HEK293T_PRDM9Binding_PeakCenters.bed
# liftOver to hg38
~/Tools/liftOver HEK293T_PRDM9Binding_PeakCenters.bed ~/Tools/hg19ToHg38.over.chain HEK293T_PRDM9Binding_PeakCenters.hg38.bed unMapped

# extract peaks
grep -v "center_start" GSE99407_ChIPseq_Peaks.YFP_HumanPRDM9.antiGFP.protocolN.p10e-5.sep250.Annotated.txt | awk '{FS=OFS="\t"; print $1,$4,$5;}' > HEK293T_PRDM9Binding_Peaks.bed
# liftOver to hg38
OverlapPRDM9BoundPeaks]$ ~/Tools/liftOver HEK293T_PRDM9Binding_Peaks.bed ~/Tools/hg19ToHg38.over.chain HEK293T_PRDM9Binding_Peaks.hg38.bed unMapped
```
human DSB hotspots
```bash
cp ~/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt ./humanDSBhotspots_AA_AB.hg38.bed
```
pan cancer PRDM9 bound peaks
```bash
cp /exports/eddie/scratch/s1949868/SelectPRDM9BoundPeaks_pan/TCGA-ATAC_PanCancer_PRDM9_bound_peaks.bed ./
```
```bash
qlogin -l h_vmem=8G
module load igmm/apps/R/3.6.3
cd /exports/eddie/scratch/s1949868/OverlapPRDM9BoundPeaks
R
```
```r
pan_PRDM9BoundPeaks_df <- read.delim(file = "/exports/eddie/scratch/s1949868/OverlapPRDM9BoundPeaks/TCGA-ATAC_PanCancer_PRDM9_bound_peaks.bed", sep = "\t", header = FALSE)
colnames(pan_PRDM9BoundPeaks_df) <- c("chrom","start","end","name")
pan_PRDM9BoundPeaks_df$start <- pan_PRDM9BoundPeaks_df$start + 250
pan_PRDM9BoundPeaks_df$end <- pan_PRDM9BoundPeaks_df$end - 250

write.table(pan_PRDM9BoundPeaks_df,
	file="TCGA-ATAC_PanCancer_PRDM9_bound_peaks_peakCenters.bed",
	sep = "\t",
	append=FALSE,row.names = FALSE,col.names = FALSE,
	quote =FALSE
	)
```
# Process
## human DSB hotspots vs direct PRDM9 binding sites
```bash
Rscript overlapPeaksCentersWithIntervals.R HEK293T_PRDM9Binding_PeakCenters.hg38.bed humanDSBhotspots_AA_AB.hg38.bed
```
human DSB hotspots vs pan cancer PRDM9 bound peaks
direct PRDM9 binding sites vs pan cancer PRDM9 bound peaks
# Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTc2ODA0MjY2MywzNzEyNjkxMDcsMTc0Mj
Y0MjE2MSwtMTU0NzMzOTYxNSwtNTkzODk0NDE4LDc5MDI0MjYx
MSwtNTI0MzIzNjAwLDg3NTkyMTg1LC0xMjk0NTYzMjcyLDM5NT
EyODE4MSwtMTk5NTk0ODc2MSwxOTkzNjEyNTIsMTA4NTk1NjI0
NF19
-->