Reference
[volcano plot](https://huntsmancancerinstitute.github.io/hciR/volcano.html)
[volcano plot example](https://www.biostars.org/p/268514/)

# PanCancer PeakSet
# CancerType-specific PeakSet
# Input
CancerType-specific PRDM9 bound peaks
CancerType-specific Count Matrices - log2normCounts
# Process
```bash
qsub ~/CompareCounts_batch.sh
```
```bash
echo -e "cancerType\ttotalPRDM9BoundPeaks\tP05\tP05LFC0\tP05LFC1" > CompareCounts_t11.txt

for file in $(ls /exports/eddie/scratch/s1949868/CompareCounts/PRDM9_Threshold11/*_CompareCounts_WithAndWithoutPRDM9.txt); do

	echo $file

	cancerType=`echo ${file#*PRDM9_Threshold11/}`; 
	cancerType=`echo ${cancerType%_CompareCounts_WithAndWithoutPRDM9*}`;
	echo $cancerType
	
	totalPRDM9BoundPeaks=`grep "chr" $file | wc -l`
	P05=`awk '{FS=OFS="\t";if($7 < 0.05){print $0}}' $file | wc -l`
	P05LFC0=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 0)){print $0}}' $file | wc -l`
	P05LFC1=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1)){print $0}}' $file | wc -l`

	echo -e "$cancerType\t$totalPRDM9BoundPeaks\t$P05\t$P05LFC0\t$P05LFC1" >> CompareCounts_t11.txt
done
```
0
5
6
7
8
9
10
# Output
5 types of cancer don't have enough observations to perform t-test 

```bash
awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1 || $6 < -1)){print $0}}' THCA_CompareCounts_WithAndWithoutPRDM9.txt | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > THCA.txt
```
```r
# read normalized counts
pan_norm_ct <- readRDS(file="~/TCGA-ATAC_PanCan_Log2Norm_Counts.rds")
# distal counts
pan_norm_ct_distal <- data.matrix(pan_norm_ct[!pan_norm_ct$annotation == "Promoter",-c(1:7)])
# var
Pvars<-rowVars(pan_norm_ct_distal)
# top 250000 var
pan_norm_ct_distal_top250000var <- pan_norm_ct_distal[order(Pvars, decreasing=TRUE)[1:250000],]
# save to rds
saveRDS(object = pan_norm_ct_distal_top250000var, file = "pan_norm_ct_distal_top250000var.rds")
```

```r
# read ID conversion table
samples.ids <- read.delim(file = "~/TCGA_identifier_mapping",sep = "\t",header=TRUE)
samples.ids$bam_prefix <- as.character(samples.ids$bam_prefix)
samples.ids$Case_ID <- as.character(samples.ids$Case_ID)
# add ID
samples.ids$cancerType <- substr(samples.ids$bam_prefix,1,4)
samples.ids$sample <- substr(samples.ids$Case_ID,1,16)
samples.ids$cancerType_sample <- paste0(samples.ids$cancerType,"_",samples.ids$sample)

# read normalized counts
pan_norm_ct <- readRDS(file="~/TCGA-ATAC_PanCan_Log2Norm_Counts.rds")
# get index of sampleID in pan_norm_ct
idx <- match(gsub("_","-",colnames(pan_norm_ct)[-c(1:7)]),samples.ids$bam_prefix)
# rename colnames of pan_norm_ct
colnames(pan_norm_ct)[-c(1:7)] <- samples.ids[idx,"cancerType_sample"]

# mark replicates 
duplicated.idx <- duplicated(colnames(pan_norm_ct)[-c(1:7)])
# mark rep1
colnames(pan_norm_ct)[-c(1:7)][!duplicated.idx] <- 
  paste0(colnames(pan_norm_ct)[-c(1:7)][!duplicated.idx],"_rep1")
# mark rep2
colnames(pan_norm_ct)[-c(1:7)][duplicated.idx] <- 
  paste0(colnames(pan_norm_ct)[-c(1:7)][duplicated.idx],"_rep2")

## calculate the mean of replicates
# This function will calculate the Means of the peaks for a given group
groupMeans <- function(df, groups, na.rm = TRUE){
  gm <- lapply(unique(groups), function(x){
    rowMeans(df[,grepl(x,colnames(df)),drop = F],na.rm=TRUE)
  }) %>% Reduce("cbind",.) # calculate rowMean and combine
  
  colnames(gm) <- unique(groups) # specify colnames to sampleID
  
  return(gm)
}
# calculate the mean of the replicates of each patient.  
matMerged <- groupMeans(df = pan_norm_ct, 
                        groups =  unique(samples.ids[idx,"cancerType_sample"]))
pan_norm_ct_merge <- matMerged
```


```bash
qlogin -l h_vmem=8G
module load igmm/apps/R/3.6.3
R --no-restore
```
```r
install.packages('Rtsne',lib = "/exports/eddie/scratch/s1949868/R/library")
library(Rtsne,lib.loc = "/exports/eddie/scratch/s1949868/R/library")

pan_norm_ct_merge_distal_top250000var_t <- readRDS(file="pan_norm_ct_merge_distal_top250000var_t.rds")
pan_norm_ct_merge_distal_top250000var_t_matrix <- as.matrix(pan_norm_ct_merge_distal_top250000var_t[,-250001])
tsne_out <- Rtsne(pan_norm_ct_merge_distal_top250000var_t_matrix,pca=FALSE,perplexity=30,theta=0.0)
plot(tsne_out$Y, asp=1)

install.packages('bigmemory',lib = "/exports/eddie/scratch/s1949868/R/library")
library('bigmemory',lib.loc = "/exports/eddie/scratch/s1949868/R/library")

```



columan is sample name
row is gene name
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTkwMjM5NDMzNiwxMjkzNTY3ODA2LC0xMj
QwODE1ODU0LDE1NjM2ODQyMjMsLTEyNDA4MTU4NTQsLTU4MDE3
MzY4NSwtMzU2OTgxMzAwLDYwMTA3Mzc3MiwtMjE0NDI4NzUwOC
wtODM3NDU1NDM1LDE1MTI3NTUwNjIsLTE1MDczNjIyMDIsMjA3
NDIxNjc5OSw3MDQyMjg5ODksODExMTEwNjc5LC0xODAzNjcxMT
UsLTExNzE4NDQ5MDksMjEzMTY0NDU5MywxMTQwMTY2Nzk5LC0x
NTM2MDYyNTIyXX0=
-->