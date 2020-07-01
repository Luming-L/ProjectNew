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
## call peaks
### build local bias track from control
### compare ATAC signal and local lambda to get the scores in pvalue or qvalue
macs2 bdgcmp command:
```bash
macs2 bdgcmp -t .bg -c .lambda.bg -m ppois -o .pvalue.bg
```
### call peaks on score track using a cutoff
macs2 bdgpeakcall command:
```bash

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
eyJoaXN0b3J5IjpbMzE3MTAyNDQ4LDE4MDk5NjIxNDIsLTE4Nj
QzOTUyMjUsMTM1Mzc5MjgyMywxMDc1MjUyNjEsLTE4NDk2MjIw
MTEsLTE4OTkxODk0NzYsLTk4NDk2ODE0Ml19
-->