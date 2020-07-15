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
echo -e "cancerType\ttotalPRDM9BoundPeaks\tP05LFC0\tP05LFC1" > CompareCounts2.txt

for file in $(ls /exports/eddie/scratch/s1949868/CompareCounts/*_CompareCounts_WithAndWithoutPRDM9.txt); do

	echo $file

	cancerType=`echo ${file#*CompareCounts/}`; 
	cancerType=`echo ${cancerType%_CompareCounts_WithAndWithoutPRDM9*}`;
	echo $cancerType
	
	totalPRDM9BoundPeaks=`grep "chr" $file | wc -l`
	P05LFC0=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 0)){print $0}}' $file | wc -l`
	P05LFC1=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1)){print $0}}' $file | wc -l`

	echo -e "$cancerType\t$totalPRDM9BoundPeaks\t$P05LFC0\t$P05LFC1" >> CompareCounts2.txt
done
```
# Output
5 types of cancer don't have enough observations to perform t-test 

```bash
awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1 || $6 < -1)){print $0}}' THCA_CompareCounts_WithAndWithoutPRDM9.txt | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > THCA.txt
```
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwOTgyOTc2MzAsLTQxNDg0MDA4NywtMT
U2NTg4MDY1MiwtMTc3NTg0NTU5OSwxMDYyMjEzMDMyLDE1MDk1
ODE0NCwyOTEwNzcyNzAsMzk1MzAyNDQyLDEzMDM4ODEwMDgsLT
UwNzYzNTYxNCwxNTEyMzk5MywyNzM2ODMyNTgsNDc0MDczMzk1
LC0xMTI0MTk0NjM4XX0=
-->