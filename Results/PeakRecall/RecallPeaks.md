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

```
## check files
```bash
for file in $(ls ./ACCx_*); do bedtools intersect -a ACC_peakCalls.txt.sorted -b $file -u-f 0.2 | wc -l; done
for file in $(ls ./ACCx_*); do bedtools intersect -a ACC_peakCalls.txt.sorted -b $file -f 0.3 -u | >> ACC_peakRecall.txt; done
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
eyJoaXN0b3J5IjpbLTcyNTkwNDYzLC0xNzI4MjcxNDc4LC0xMj
Q4NjkxODM3LDMxNzEwMjQ0OCwtNzA3NDkzNTI0LDMxNzEwMjQ0
OCwxODA5OTYyMTQyLC0xODY0Mzk1MjI1LDEzNTM3OTI4MjMsMT
A3NTI1MjYxLC0xODQ5NjIyMDExLC0xODk5MTg5NDc2LC05ODQ5
NjgxNDJdfQ==
-->