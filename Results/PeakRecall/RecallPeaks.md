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
```bash
for file in $(ls ./ACCx_*); do bedtools intersect -a ACC_peakCalls.txt.sorted -b $file -f 0.5 -u >> ACC_peakRecall.txt; done
cut -f 4 ACC_peakRecall.txt | sort | uniq -c | awk '{if($1>1){print $0}}' | wc -l
```
```bash
for $peakCalls (ls ./*.txt.sorted) do
cancerType=`echo ${peakCalls#*/RefineRecalledPeaks}`
cancerType=`echo ${cancerType%_peakCalls*}`

echo $fileName
for file in $(ls ./ACCx_*); do bedtools intersect -a $peakCalls -b $file -f 0.5 -u >> ACC_peakRecall.txt; done
cut -f 4 ACC_peakRecall.txt | sort | uniq -c | awk '{if($1>1){print $0}}' | wc -l
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
eyJoaXN0b3J5IjpbNjkzOTM4NDc3LC0yMDk3OTI3OTc2LC0zMD
k4MjQ2NDEsLTk1NDg4NjgzNiwyMDUyOTU5MzQ3LC01MjYxNDg2
MDQsMTMyNzYzNTI0NiwtMTcyODI3MTQ3OCwtMTI0ODY5MTgzNy
wzMTcxMDI0NDgsLTcwNzQ5MzUyNCwzMTcxMDI0NDgsMTgwOTk2
MjE0MiwtMTg2NDM5NTIyNSwxMzUzNzkyODIzLDEwNzUyNTI2MS
wtMTg0OTYyMjAxMSwtMTg5OTE4OTQ3NiwtOTg0OTY4MTQyXX0=

-->