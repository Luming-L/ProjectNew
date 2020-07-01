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
df["ENSG00000164256.8",c()]
# get number of PRDM9-bound peaks


wc -l ./PRDM9BoundPeaks_404_Case_ID/TCGA-D3-A8GP-06A*
28629 ./PRDM9BoundPeaks_404_Case_ID/TCGA-D3-A8GP-06A_PRDM9_bound_peaks.bed
[s1949868@node1h20(eddie) s1949868]$ wc -l ./PRDM9BoundPeaks_404_Case_ID/TCGA-GD-A3OQ-01A*
29370 ./PRDM9BoundPeaks_404_Case_ID/TCGA-GD-A3OQ-01A_PRDM9_bound_peaks.bed
[s1949868@node1h20(eddie) s1949868]$ wc -l ./PRDM9BoundPeaks_404_Case_ID/TCGA-C8-A12U-01A*
32724 ./PRDM9BoundPeaks_404_Case_ID/TCGA-C8-A12U-01A_PRDM9_bound_peaks.bed
[s1949868@node1h20(eddie) s1949868]$ wc -l ./PRDM9BoundPeaks_404_Case_ID/TCGA-C8-A8HR-01A*
33863 ./PRDM9BoundPeaks_404_Case_ID/TCGA-C8-A8HR-01A_PRDM9_bound_peaks.bed
[s1949868@node1h20(eddie) s1949868]$ ll SNPsAndSmallINDELs
total 1511424

<!--stackedit_data:
eyJoaXN0b3J5IjpbMjA2OTU1MDc3Myw5MjIxMjc1MDksLTQzNz
M2MDkwOCwtODc0MjgyOTc0LDUxNTAxODM1NSwtNzgzMzY5MzU1
LC0yMzkxMjkxNzJdfQ==
-->