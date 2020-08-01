# Input
**BigWig files**
ATAC-seq signal tracks that have been normalized by the number of reads in peaks. 
# Process
## convert BigWig to BedGraph
```bash
# download BigWigs
bigWigLinks.txt
downloadLinks.sh
qsub /home/s1949868/MScProject/Results/AllInOneGo/PeakRecall/downloadLinks.sh
# decompress files

```
```bash
# convert BigWig to BedGraph
rule bwTobg:
    output: "{dataset}.bg"
    input:  "/exports/eddie/scratch/s1949868/BigWig/{dataset}.bw"
    shell:  "/home/s1949868/Tools/bigWigToBedGraph {input} {output}"
```
## call peaks
```bash
rule calculatePoisLambda:
    output: "{dataset}.lambda.bg"
    input:  "{dataset}.bg"
    shell:  "python3 /home/s1949868/MScProject/Results/AllInOneGo/PeakRecall/calculatePoisLambda.py {input}"

rule recallPeaks:
    output: "{dataset}.bdgpeakcalls.bed"
    input:  "{dataset}.bg"
    shell:  r"""
    # Compare ATAC-seq signal and local lambda to get the scores in pvalue
    macs2 bdgcmp -t {input} -c {wildcards.dataset}.lambda.bg -m ppois -o {wildcards.dataset}.pvalue.bg
    # Call peaks on score track using a cutoff p-value=0.01
    macs2 bdgpeakcall -i {wildcards.dataset}.pvalue.bg -c 2 -l 150 -g 75 -o {output}
    """
```
### 1. build local bias track from control
### 2. compare ATAC signal and local lambda to get the scores in pvalue or qvalue
```bash
macs2 bdgcmp -t .bg -c .lambda.bg -m ppois -o .pvalue.bg
```
### 3. call peaks on score track using a cutoff
```bash
macs2 bdgpeakcall -i .pvalue.bg -c 2 -l 150 -g 75 -o .bdgpeakcalls.bed
```
## check files
sort files
```bash
# prepare the input of bedtools
echo "sort start: $(date)"
# sort and cut files of Cancer Type-specific PeakCalls
cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls # Cancer_Type_PeakCalls_path in peakOverlap.py
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/RefineRecalledPeaks/${file}.sorted; done
cd /exports/eddie/scratch/s1949868/RecallPeak # peaks_path in peakOverlap.py
for file in $(ls ./*insertions.peaks.bed); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3}}' > /exports/eddie/scratch/s1949868/RefineRecalledPeaks/${file}.sorted; done
echo "sort done: $(date)"
```
check reproducible recalled peak of a specific cancer type
compare them with `cancer type-specific peak set`
```bash
echo -e "cancerType\trecalled\toriginal\tfraction" > checkReproduciblePeaks.txt
for peakCalls in $(ls /exports/eddie/scratch/s1949868/RefineRecalledPeaks/*.txt.sorted); do echo $peakCalls; cancerType=`echo ${peakCalls#*/RefineRecalledPeaks/}`; cancerType=`echo ${cancerType%_peakCalls*}`; for file in $(ls /exports/eddie/scratch/s1949868/RefineRecalledPeaks/$cancerType*.peaks.bed.sorted); do bedtools intersect -a $peakCalls -b $file -f 0.5 -u >> ${cancerType}_PeakRecall.total.txt; done; a=`cut -f 4 ${cancerType}_PeakRecall.total.txt | sort | uniq -c | awk '{if($1>1){print $0}}' | wc -l | awk '{print $1}'`; b=`wc -l $peakCalls | awk '{print $1}'`; echo -e "$cancerType\t$a\t$b" >> checkReproduciblePeaks.txt; done
```
```r
# calculate fraction
repr <- read.delim("checkReproduciblePeaks.txt",header = TRUE, sep = "\t")
repr$fraction <- repr$recalled/repr$original
write.table(repr,
	file="/exports/eddie/scratch/s1949868/RefineRecalledPeaks/checkReproduciblePeaks2.txt",
	sep = "\t",
	append=FALSE,row.names = FALSE,col.names = TRUE,
	quote =FALSE
	)
```
```bash
rm checkReproduciblePeaks.txt
mv checkReproduciblePeaks2.txt checkReproduciblePeaks.txt
```
checkReproduciblePeaks.txt


## test on paper data
**Test file:** `ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg`
```bash
./peakRecall.py ./ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg
```
**Check peaks number, and Plot signal from BigWig file and peaks recalled to compare**

Region: chr1: 777499-1233399

`-c 2 -l 501`: 52519 

`-c 2 -l 150`: 210571 choose this 

`-c 2 -l 300`: 124102

`-c 2 -l 400`: 86186

`-c 3 -l 400`: 64905 
# Output
ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.peaks.bed
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE2MjUzOTMxNzUsMTEzNzczMzE3MiwyMT
gyNDQ2MTIsMjEyMjQ5MTAxNSwtMTkyMjM4NzkzLC0xOTgzODY5
ODk4LDI4ODg2MTQzLDYzNzI2MTQ2Nyw3MDAzMzY1MzMsNTUwOT
E0NzYzLDE5Njc3ODg5NDIsLTQ3NDc4Nzg0OCwxNjg2NjQ1NjQ1
LC0yMDk3OTI3OTc2LC0zMDk4MjQ2NDEsLTk1NDg4NjgzNiwyMD
UyOTU5MzQ3LC01MjYxNDg2MDQsMTMyNzYzNTI0NiwtMTcyODI3
MTQ3OF19
-->