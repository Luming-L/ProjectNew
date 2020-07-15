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

for file in $(ls /exports/eddie/scratch/s1949868/CompareCounts/*_CompareCounts_WithAndWithoutPRDM9.txt); do

	echo $file

	cancerType=`echo ${file#*CompareCounts/}`; 
	cancerType=`echo ${cancerType%_CompareCounts_WithAndWithoutPRDM9*}`;
	echo $cancerType
	
	total=`grep `
	padj=`awk '{FS=OFS="\t";if($7 < 0.05){print $0}}' $file | wc -l`;
	log2FC=`awk '{FS=OFS="\t";if($6 > 1 || $6 < -1){print $0}}' $file | wc -l`
	Both=`awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1 || $6 < -1)){print $0}}' $file | wc -l`
	echo -e "$cancerType\t$padj\t$log2FC\t$Both" >> CompareCounts.txt
done
```
# Output
5 types of cancer don't have enough observations to perform t-test 

```bash
awk '{FS=OFS="\t";if(($7 < 0.05)&&($6 > 1 || $6 < -1)){print $0}}' THCA_CompareCounts_WithAndWithoutPRDM9.txt | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > THCA.txt
```
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTE4ODM4NzczLDEwNjIyMTMwMzIsMTUwOT
U4MTQ0LDI5MTA3NzI3MCwzOTUzMDI0NDIsMTMwMzg4MTAwOCwt
NTA3NjM1NjE0LDE1MTIzOTkzLDI3MzY4MzI1OCw0NzQwNzMzOT
UsLTExMjQxOTQ2MzhdfQ==
-->