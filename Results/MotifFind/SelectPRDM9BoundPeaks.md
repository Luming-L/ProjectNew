# Select PRDM9-bound peaks for 404 samples
## Input
PRDM9 motif occurrences in each sample (404, the output of fimo_batch.sh)
Peak calls in each sample (404, the output of peakRefine.py)
## Process
```bash
qsub ~/selectPRDM9BoundPeaks.sh
```
### select by `bedtools intersect`
```bash
bedtools intersect -a /exports/eddie/scratch/s1949868/RefineRecalledPeaks/allPeakCalls_CaseID/"${fileName}_peakCalls.bed" -b $file -F 1.0 -u > "${fileName}_PRDM9_bound_peaks.bed"
```
### get number of PRDM9-bound peaks
```bash
echo -e "ID\tnumPRDM9BoundPeaks" > numPRDM9BoundPeaks.txt
# count PRDM9-bound peaks for each sample
for file in $(ls /exports/eddie/scratch/s1949868/SelectPRDM9BoundPeaks_404/*_PRDM9_bound_peaks.bed); do
	echo $file

	ID=`echo ${file#*SelectPRDM9BoundPeaks_404/}`; 
	ID=`echo ${ID%_PRDM9_bound_peaks*}`;
	echo $ID

	numPRDM9BoundPeaks=`wc -l $file | awk '{print $1}'`; 

	echo -e "$ID\t$numPRDM9BoundPeaks" >> numPRDM9BoundPeaks.txt
done
```
## Output
404 `_PRDM9_bound_peaks.bed` files
a set of PRDM9-bound peaks for each sample
# Select PRDM9-bound peaks for 23 cancerTypes
## Input
PRDM9 motif occurrences in each cancer type (23, the output of fimo_batch.sh)
Cancer type-specific peak calls (23)
## Process
```bash
qsub ~/selectPRDM9BoundPeaks.sh
```
## Output
23 `_PRDM9_bound_peaks.bed` files
a set of PRDM9-bound peaks for each cancerType
# Select PRDM9-bound peaks for PanCancer PeakSet
## Input
PRDM9 motif occurrences in PanCancer PeakSet
## Process
```bash
bedtools intersect -a TCGA-ATAC_PanCancer_PeakSet.bed -b TCGA-ATAC_PanCancer_PeakSet_fimo.gff -F 1.0 -u > TCGA-ATAC_PanCancer_PRDM9_bound_peaks.bed
```
## Output
a set of PRDM9-bound peaks 



<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0NzE2NDM1NzUsNzUxOTkzMjI5LDk3Nz
IwNTQ0NSw3NDU4NjIzMTIsLTE5NTc3NjE1MTksLTE0NDYzMDg5
OTEsLTk3OTU2NDExMiwxNjM5MTIxNjY1LC00NTM3Mzk1OTEsMj
k1OTAwOTQyLDIwNDcxMDk3NDBdfQ==
-->