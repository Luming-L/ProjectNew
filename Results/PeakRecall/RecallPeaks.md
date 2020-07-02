# Input
**BigWig files**
ATAC-seq signal tracks that have been normalized by the number of reads in peaks. 
# Process
## convert BigWig to BedGraph
```bash
# download BigWigs
bigWigLinks.txt
downloadLinks.sh
qsub ~/BedGraph/downloadLinks.sh
# decompress files
for file in $(ls ./*); do
	tar xvzf $file
	mv oak/stanford/groups/howchang/users/mcorces/temp/bigwigs/* ./bigwigs
	rm -r oak
done
```
```bash
# convert BigWig to BedGraph
qsub ~/BigWigtoBedGraph_batch.sh
```
## call peaks
```bash
peakRecall.py
qsub ~/peakRecall_batch.sh
```
### build local bias track from control
### compare ATAC signal and local lambda to get the scores in pvalue or qvalue
```bash
macs2 bdgcmp -t .bg -c .lambda.bg -m ppois -o .pvalue.bg
```
### call peaks on score track using a cutoff
```bash
macs2 bdgpeakcall -i .pvalue.bg -c 2 -l 150 -g 75 -o .peaks.bed
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


```bash
for file in $(ls ./ACCx_*); do bedtools intersect -a ACC_peakCalls.txt.sorted -b $file -f 0.5 -u >> ACC_peakRecall.txt; done
cut -f 4 ACC_peakRecall.txt | sort | uniq -c | awk '{if($1>1){print $0}}' | wc -l
```
```bash
for peakCalls in $(ls /exports/eddie/scratch/s1949868/RefineRecalledPeaks/*.txt.sorted); do echo $peakCalls;  cancerType=`echo ${peakCalls#*/RefineRecalledPeaks/}`;  cancerType=`echo ${cancerType%_peakCalls*}`; for file in $(ls /exports/eddie/scratch/s1949868/RefineRecalledPeaks/$cancerType*.peaks.bed.sorted); do bedtools intersect -a $peakCalls -b $file -f 0.5 -u >> ${cancerType}_PeakRecall.total.txt; done; a=`cut -f 4 ${cancerType}_PeakRecall.total.txt | sort | uniq -c | awk '{if($1>1){print $0}}' | wc -l | awk '{print $1}'`; b=`wc -l $peakCalls | awk '{print $1}'`; echo -e "$cancerType\t$a\t$b" ; done
```
```bash
for peakCalls in $(ls /exports/eddie/scratch/s1949868/RefineRecalledPeaks/*.txt.sorted); do  echo $peakCalls;  cancerType=`echo ${peakCalls#*/RefineRecalledPeaks/}`;  cancerType=`echo ${cancerType%_peakCalls*}`; echo $cancerType; for file in $(ls /exports/eddie/scratch/s1949868/RefineRecalledPeaks/$cancerType*.peaks.bed.sorted); do bedtools intersect -a $peakCalls -b $file -f 0.5 -u >> ${cancerType}_PeakRecall.total.txt; done; Recalled = `cut -f 4 ${cancerType}_PeakRecall.total.txt | sort | uniq -c | awk '{if($1>1){print $0}}' | wc -l`; Original = `wc -l $peakCalls`; echo -e "$cancerType\t$recalled\t$original"; done
```
## test on paper data
**Test file:** `ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg`
```bash
./peakRecall.py ./ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg
```
**Check peaks number, and Plot signal from BigWig file and peaks recalled to compare**

Region: chr1: 777499-1233399

`-c 2 -l 501`: 52519 


`-c 2 -l 150`: 210571

`-c 2 -l 300`: 124102

`-c 2 -l 400`: 86186


`-c 3 -l 400`: 64905 
# Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbNjM3MjYxNDY3LDcwMDMzNjUzMyw1NTA5MT
Q3NjMsMTk2Nzc4ODk0MiwtNDc0Nzg3ODQ4LDE2ODY2NDU2NDUs
LTIwOTc5Mjc5NzYsLTMwOTgyNDY0MSwtOTU0ODg2ODM2LDIwNT
I5NTkzNDcsLTUyNjE0ODYwNCwxMzI3NjM1MjQ2LC0xNzI4Mjcx
NDc4LC0xMjQ4NjkxODM3LDMxNzEwMjQ0OCwtNzA3NDkzNTI0LD
MxNzEwMjQ0OCwxODA5OTYyMTQyLC0xODY0Mzk1MjI1LDEzNTM3
OTI4MjNdfQ==
-->