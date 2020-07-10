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

	numPRDM9BoundPeaks=`wc -l $file`; 

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






<!--stackedit_data:
eyJoaXN0b3J5IjpbLTUzOTI1NTg0MSwtMTk1Nzc2MTUxOSwtMT
Q0NjMwODk5MSwtOTc5NTY0MTEyLDE2MzkxMjE2NjUsLTQ1Mzcz
OTU5MSwyOTU5MDA5NDIsMjA0NzEwOTc0MF19
-->