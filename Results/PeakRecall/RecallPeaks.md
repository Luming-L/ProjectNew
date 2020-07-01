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
mv oak/stanford/groups/howchang/users/mcorces/temp/bigwigs/* ./
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
eyJoaXN0b3J5IjpbMTgwOTk2MjE0MiwtMTg2NDM5NTIyNSwxMz
UzNzkyODIzLDEwNzUyNTI2MSwtMTg0OTYyMjAxMSwtMTg5OTE4
OTQ3NiwtOTg0OTY4MTQyXX0=
-->