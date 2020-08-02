Overlap
human DSB hotspots vs direct PRDM9 binding sites
human DSB hotspots vs pan cancer PRDM9 bound peaks
direct PRDM9 binding sites vs pan cancer PRDM9 bound peaks
human DSB hotspots vs pan cancer peaks
direct PRDM9 binding sites vs pan cancer peaks
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
pan cancer peaks
```r
pan_Peaks_df <- read.delim(file = "/exports/eddie/scratch/s1949868/PRDM9Binding/TCGA-ATAC_PanCancer_Peaks.bed", sep = "\t", header = TRUE)
pan_Peaks_df$start <- pan_Peaks_df$start + 250
pan_Peaks_df$end <- pan_Peaks_df$end - 250

write.table(pan_Peaks_df,
	file="TCGA-ATAC_PanCancer_Peaks_peakCenters.bed",
	sep = "\t",
	append=FALSE,row.names = FALSE,col.names = FALSE,
	quote =FALSE
	)
```
# Process
```bash
qlogin -l h_vmem=8G
module load igmm/apps/R/3.6.3
module load igmm/apps/BEDTools/2.27.1
```
## human DSB hotspots vs direct PRDM9 binding sites
```bash
Rscript overlapPeaksCentersWithIntervals.R humanDSBhotspots_AA_AB.hg38.bed HEK293T_PRDM9Binding_PeakCenters.hg38.bed
```
## human DSB hotspots vs pan cancer PRDM9 bound peaks
```bash
Rscript overlapPeaksCentersWithIntervals.R humanDSBhotspots_AA_AB.hg38.bed TCGA-ATAC_PanCancer_PRDM9_bound_peaks_peakCenters.bed
```
## direct PRDM9 binding sites vs pan cancer PRDM9 bound peaks
```bash
Rscript overlapPeaksCentersWithIntervals.R TCGA-ATAC_PanCancer_PRDM9_bound_peaks.bed HEK293T_PRDM9Binding_PeakCenters.hg38.bed
```
## human DSB hotspots vs pan cancer peaks
```bash
Rscript overlapPeaksCentersWithIntervals.R humanDSBhotspots_AA_AB.hg38.bed TCGA-ATAC_PanCancer_Peaks_peakCenters.bed
```
## direct PRDM9 binding sites vs pan cancer peaks
```bash
Rscript overlapPeaksCentersWithIntervals.R TCGA-ATAC_PanCancer_Peaks.bed HEK293T_PRDM9Binding_PeakCenters.hg38.bed
```
# Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0MzIyMTUxNjUsLTEyOTQ5MTg5NDMsMT
k3NDIzMDA3MiwxNTU1MTQzNzEsMzAxNjMwNjAzLDYwOTA2MDgx
LDU2NDM3NTcwOCwxNDg0ODUxMjU5LC00MzAwMTc5OTQsLTE5NT
g4NjY5NTYsMTMxOTM2ODQwMSwxNzQxMjcyNzQ3LDIxMTM5MjY1
MTYsLTI4ODY0NDIyOCwzNzEyNjkxMDcsMTc0MjY0MjE2MSwtMT
U0NzMzOTYxNSwtNTkzODk0NDE4LDc5MDI0MjYxMSwtNTI0MzIz
NjAwXX0=
-->