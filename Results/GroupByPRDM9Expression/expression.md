# get IDs of 404 samples
```bash
for file in $(ls /exports/eddie/scratch/s1949868/PRDM9BoundPeaks_404_Case_ID/*); do
fileName=`echo ${file#*Case_ID/}`;
fileName=`echo ${fileName%_PRDM9_bound_peaks*}`;
echo -e $fileName >> /exports/eddie/scratch/s1949868/geneExpression/404Samples_CaseID.txt
done
```
# get PRDM9 expression value 
```bash
head -1 GDC-PANCAN.htseq_fpkm-uq.tsv > PRDM9_htseq_fpkm-uq.tsv
awk '{FS=OFS="\t";if($1~/ENSG00000164256/){print $0}}' GDC-PANCAN.htseq_fpkm-uq.tsv >> PRDM9_htseq_fpkm-uq.tsv
```
Rscript extractExpression.Rmd
[PRDM9](https://www.ensembl.org/Homo_sapiens/Gene/Summary?g=ENSG00000164256;r=5:23443586-23528093)


















































# get number of PRDM9-bound peaks
```bash
echo -e "ID\texpression\tnumPeaks" > PRDM9ExpressionAndPeaks.txt

for ID in $(cut -f 1 /exports/eddie/scratch/s1949868/geneExpression/PRDM9Expression_375samples.txt); do 
	numPeaks=`wc -l /exports/eddie/scratch/s1949868/PRDM9BoundPeaks_404_Case_ID/${ID}_PRDM9_bound_peaks.bed | awk '{print $1}'`; 
	expression=`awk '{FS=OFS="\t";if($1=="'$ID'"){print $2}}' /exports/eddie/scratch/s1949868/geneExpression/PRDM9Expression_375samples.txt`; 
	echo -e "$ID\t$expression\t$numPeaks" >> PRDM9ExpressionAndPeaks.txt
done
```


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTExODM0MTAyNTldfQ==
-->