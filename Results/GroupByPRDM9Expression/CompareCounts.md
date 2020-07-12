Reference
[volcano plot](https://huntsmancancerinstitute.github.io/hciR/volcano.html)
[volcano plot example](https://www.biostars.org/p/268514/)

# PanCancer PeakSet
# CancerType-specific PeakSet
# Input
CancerType-specific PRDM9 bound peaks
CancerType-specific Count Matrices - log2normCounts
# Process
```bash
qsub ~/CompareCounts_batch.sh
```
```bash
echo -e "cancerType\tp.adj<0.05\tabs(log2FoldChange)>1\tBoth" > CompareCounts.txt
echo -e "ID\tnumPRDM9BoundPeaks" > numPRDM9BoundPeaks.txt
# count PRDM9-bound peaks for each sample
for file in $( ls /exports/eddie/scratch/s1949868/CompareCounts/*_CompareCounts_WithAndWithoutPRDM9.txt | wc -l
); do
	echo $file

	ID=`echo ${file#*SelectPRDM9BoundPeaks_404/}`; 
	ID=`echo ${ID%_PRDM9_bound_peaks*}`;
	echo $ID

	numPRDM9BoundPeaks=`wc -l $file | awk '{print $1}'`; 

	echo -e "$ID\t$numPRDM9BoundPeaks" >> numPRDM9BoundPeaks.txt
done
```
# Output
5 types of cancer don't have enough observations to perform t-test 
<!--stackedit_data:
eyJoaXN0b3J5IjpbMzk1MzAyNDQyLDEzMDM4ODEwMDgsLTUwNz
YzNTYxNCwxNTEyMzk5MywyNzM2ODMyNTgsNDc0MDczMzk1LC0x
MTI0MTk0NjM4XX0=
-->