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
```bash
wc -l *PRDM9_bound_peaks.bed* | sort -k1,1nr | head
wc -l *PRDM9_bound_peaks.bed* | sort -k1,1nr | tail
```





<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk3OTU2NDExMiwxNjM5MTIxNjY1LC00NT
M3Mzk1OTEsMjk1OTAwOTQyLDIwNDcxMDk3NDBdfQ==
-->