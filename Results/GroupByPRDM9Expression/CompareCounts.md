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

```bash
qlogin -l h_vmem=8G
module load igmm/apps/R/3.6.3
```
```r
pan_norm_ct <- readRDS(file="TCGA-ATAC_PanCan_Log2Norm_Counts.rds")
pan_norm_ct_distal <- pan_norm_ct[!pan_norm_ct$annotation == "Promoter",]
pan_norm_ct_distal <- data.matrix(pan_norm_ct_distal[,-c(1:7)])


install.packages('bigmemory',lib = "/exports/eddie/scratch/s1949868/R/library")
library('bigmemory',lib.loc = "/exports/eddie/scratch/s1949868/R/library")

```



columan is sample name
row is gene name
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTgzNzQ1NTQzNSwxNTEyNzU1MDYyLC0xNT
A3MzYyMjAyLDIwNzQyMTY3OTksNzA0MjI4OTg5LDgxMTExMDY3
OSwtMTgwMzY3MTE1LC0xMTcxODQ0OTA5LDIxMzE2NDQ1OTMsMT
E0MDE2Njc5OSwtMTUzNjA2MjUyMiwtMTcxMDk3ODkyNywxNzg5
MTYwNDEyLDEzNTUwNzE1MDgsLTIwOTgyOTc2MzAsLTQxNDg0MD
A4NywtMTU2NTg4MDY1MiwtMTc3NTg0NTU5OSwxMDYyMjEzMDMy
LDE1MDk1ODE0NF19
-->