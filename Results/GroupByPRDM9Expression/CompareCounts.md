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
echo -e "cancerType\ttotalPRDM9BoundPeaks\tP05\tP05LFC0\tP05LFC1" > CompareCounts_t7.txt

for file in $(ls /exports/eddie/scratch/s1949868/CompareCounts/PRDM9_Threshold7/*_CompareCounts_WithAndWithoutPRDM9.txt); do

	echo $file

	cancerType=`echo ${file#*PRDM9_Threshold7/}`; 
	cancerType=`echo ${cancerType%_CompareCounts_WithAndWithoutPRDM9*}`;
	echo $cancerType
	
	totalPRDM9BoundPeaks=`grep "chr" $file | wc -l`
	P05=`awk '{FS=OFS="\t";if($7 < 0.05){print $0}}' $file | wc -l`
	P05LFC0=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 0)){print $0}}' $file | wc -l`
	P05LFC1=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1)){print $0}}' $file | wc -l`

	echo -e "$cancerType\t$totalPRDM9BoundPeaks\t$P05\t$P05LFC0\t$P05LFC1" >> CompareCounts_t7.txt
done
```
0
5
6
7
8
9
10
# Output
5 types of cancer don't have enough observations to perform t-test 

```bash
awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1 || $6 < -1)){print $0}}' THCA_CompareCounts_WithAndWithoutPRDM9.txt | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > THCA.txt
```
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTExNzE4NDQ5MDksMjEzMTY0NDU5MywxMT
QwMTY2Nzk5LC0xNTM2MDYyNTIyLC0xNzEwOTc4OTI3LDE3ODkx
NjA0MTIsMTM1NTA3MTUwOCwtMjA5ODI5NzYzMCwtNDE0ODQwMD
g3LC0xNTY1ODgwNjUyLC0xNzc1ODQ1NTk5LDEwNjIyMTMwMzIs
MTUwOTU4MTQ0LDI5MTA3NzI3MCwzOTUzMDI0NDIsMTMwMzg4MT
AwOCwtNTA3NjM1NjE0LDE1MTIzOTkzLDI3MzY4MzI1OCw0NzQw
NzMzOTVdfQ==
-->