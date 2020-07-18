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
echo -e "cancerType\ttotalPRDM9BoundPeaks\tP05\tP05LFC0\tP05LFC1" > CompareCounts_t10.txt

for file in $(ls /exports/eddie/scratch/s1949868/CompareCounts/PRDM9_Threshold10/*_CompareCounts_WithAndWithoutPRDM9.txt); do

	echo $file

	cancerType=`echo ${file#*PRDM9_Threshold10/}`; 
	cancerType=`echo ${cancerType%_CompareCounts_WithAndWithoutPRDM9*}`;
	echo $cancerType
	
	totalPRDM9BoundPeaks=`grep "chr" $file | wc -l`
	P05=`awk '{FS=OFS="\t";if($7 < 0.05){print $0}}' $file | wc -l`
	P05LFC0=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 0)){print $0}}' $file | wc -l`
	P05LFC1=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1)){print $0}}' $file | wc -l`

	echo -e "$cancerType\t$totalPRDM9BoundPeaks\t$P05\t$P05LFC0\t$P05LFC1" >> CompareCounts_t10.txt
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
eyJoaXN0b3J5IjpbNzA0MjI4OTg5LDgxMTExMDY3OSwtMTgwMz
Y3MTE1LC0xMTcxODQ0OTA5LDIxMzE2NDQ1OTMsMTE0MDE2Njc5
OSwtMTUzNjA2MjUyMiwtMTcxMDk3ODkyNywxNzg5MTYwNDEyLD
EzNTUwNzE1MDgsLTIwOTgyOTc2MzAsLTQxNDg0MDA4NywtMTU2
NTg4MDY1MiwtMTc3NTg0NTU5OSwxMDYyMjEzMDMyLDE1MDk1OD
E0NCwyOTEwNzcyNzAsMzk1MzAyNDQyLDEzMDM4ODEwMDgsLTUw
NzYzNTYxNF19
-->