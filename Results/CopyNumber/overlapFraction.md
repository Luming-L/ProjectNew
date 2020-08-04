




```bash
echo -e "sampleID\tnumSVBs\tnumOverlap\toverlapFraction" > overlap_motif_VS_SVBSs200.txt

for SVBSFile in $(ls /exports/eddie/scratch/s1949868/CopyNumber/SVBS200/*SVBS200.txt); do 
	echo $SVBSFile; 
	sampleID=${SVBSFile#*SVBS200/}; 
	sampleID=${sampleID%.SVBS*};
	echo $sampleID
	
	motifFile=/exports/eddie/scratch/s1949868/MotifFind_fimo_404/allFimoGFF_CaseID/${sampleID}_peakCalls_fimo.gff
	echo $motifFile
	
	a=`cat $SVBSFile | wc -l`
	b=`bedtools intersect -a $SVBSFile -b $motifFile -F 1.0 -u | wc -l`
	
	c=`echo "scale=2;$b/$a" | bc`
	echo -e "$sampleID\t$a\t$b\t$c" >> overlap_motif_VS_SVBSs200.txt
done
```
```bash
for SVBFile in $(ls /exports/eddie/scratch/s1949868/CopyNumber/SVB/BRCA*); do 
	echo $SVBFile; 
	sampleID=${SVBFile#*SVB/}; 
	sampleID=${sampleID%.masked*};
	echo $sampleID
	
	PRDM9BoundPeaks=/exports/eddie/scratch/s1949868/SelectPRDM9BoundPeaks_404/${sampleID}_PRDM9_bound_peaks.bed
	echo $PRDM9BoundPeaks
	
	bedtools intersect -a $PRDM9BoundPeaks -b $SVBFile -F 1.0 -u | awk '{FS=OFS="\t"; print "'$sampleID'",$1,$2,$3,$4}' > ${sampleID}_PRDM9BoundPeaks.containSVB.txt
	 
done
```
```bash
 bedtools intersect -a ../../CompareCounts/pan_CompareCounts/pan_CompareCounts_WithAndWithoutPRDM9_t8_sigIncre100.txt -b pan.masked_cnv_breakpoints.txt -wa -wb
```
chr2    201139352       201139853       TGCT_12429      1.61226016510803e-05    1.16477224210653        0.00221710084561987  chr2     201139551       201139552       0.3126  TCGA-C8-A12T-01A
```bash
bedtools intersect -a /exports/eddie/scratch/s1949868/CompareCounts/BRCA_CompareCounts/BRCA_CompareCounts_WithAndWithoutPRDM9_sigIncre2t0_4t7.txt
 -b /exports/eddie/scratch/s1949868/CopyNumber/SVB/pan.masked_cnv_breakpoints.txt -wa -wb

```

# per sample level
## Input
Copy number variation (CNV)
```bash
wget https://gdc.xenahubs.net/download/GDC-PANCAN.masked_cnv.tsv.gz
gzip -d GDC-PANCAN.masked_cnv.tsv.gz
```
get structural variant breakpoints (SVBs) on per sample level
```bash
qlogin -l h_vmem=8G
module load igmm/apps/R/3.6.3
cd /exports/eddie/scratch/s1949868/CopyNumber
R --no-restore
```
```r
# read PRDM9 expression
PRDM9.expression <- read.delim("/home/s1949868/MScProject/Results/PRDM9ExpressionAndBinding/PRDM9Expression.txt", sep = "\t",header = TRUE)
# store sampleID in a new column
PRDM9.expression$sampleID <- substr(rownames(PRDM9.expression),6,21)

# read cnv
masked_cnv <- read.delim("GDC-PANCAN.masked_cnv.tsv",sep = "\t",header = TRUE)
masked_cnv$sample <- as.character(masked_cnv$sample)
masked_cnv$Chrom <- as.character(masked_cnv$Chrom)
masked_cnv$Chrom <- paste0("chr",masked_cnv$Chrom)

# select segments considered as gain or loss
masked_cnv <- masked_cnv[masked_cnv$value >= 0.3 | masked_cnv$value <= -0.3,]
# take the breakpoints
masked_cnv_start <- masked_cnv[,c(1,2,3,5)]
colnames(masked_cnv_start) <- c("sample", "Chrom", "End", "value")
masked_cnv_end <- masked_cnv[,c(1,2,4,5)]
masked_cnv_bp <- rbind(masked_cnv_start, masked_cnv_end)
masked_cnv_bp$Start <- masked_cnv_bp$End - 1
masked_cnv_breakpoints <- data.frame("sample" = masked_cnv_bp$sample, "Chrom" = masked_cnv_bp$Chrom, "Start" = masked_cnv_bp$Start, "End" = masked_cnv_bp$End, "value" = masked_cnv_bp$value, stringsAsFactors = FALSE)

# just keep samples containing RNA-seq, ATAC-seq and cnv data.
masked_cnv_breakpoints <- masked_cnv_breakpoints[masked_cnv_breakpoints$sample %in% PRDM9.expression$sampleID,]

# save breakpoints of each sample separately
for (i in unique(masked_cnv_breakpoints$sample)) {
  output <- masked_cnv_breakpoints[masked_cnv_breakpoints$sample == i,c(2,3,4,5)]
  cType_sampleID <- rownames(PRDM9.expression[PRDM9.expression$sampleID == i,])
  
  write.table(output,
	file=paste0(cType_sampleID,".masked_cnv_breakpoints.txt"),
	sep = "\t",
	append=FALSE,row.names = FALSE,col.names = FALSE,
	quote =FALSE
	)
}
```
get SVBSs (100/200bp)
```bash
module load igmm/apps/BEDTools/2.27.1

for bpFile in $(ls /exports/eddie/scratch/s1949868/CopyNumber/SVB/*breakpoints.txt); do 
	echo $bpFile; 
	sampleID=${bpFile#*SVB/}; 
	sampleID=${sampleID%.masked_cnv*};
	echo $sampleID
	
	bedtools slop -i ${bpFile} -g /home/s1949868/Tools/chr_length.hg38.txt -b 200 > ${sampleID}.SVBS200.txt
	done
```
## Process
## Output
# per cancer level
## Input
group samples of each cancer type by PRDM9 expression level (=0 and >0)
get SVBs in PRDM9 expressed group and not expressed group for each cancer type (23*2=46)
## Process


## Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk5NDEyNzkxOSwtMTY3MzEyNTYxMCwtMz
Q5NDQwODA1LC0xMTM3NTQ4NzI4LDIxMjE5NDQ1MDYsOTQyNDc3
MTkxLDE4NzUxMjU4MDVdfQ==
-->