
# Make PeakSet for each sample
## input files
**Cancer type-specific peak calls (23)**
Each text file represents all merged peak calls from each cancer type. 
**Recalled peaks in each technical replicate (796)**
```bash
# download cancer type-specific PeakCalls
wget https://api.gdc.cancer.gov/data/71ccfc55-b428-4a04-bb5a-227f7f3bf91c
unzip 71ccfc55-b428-4a04-bb5a-227f7f3bf91c
mkdir TCGA-ATAC_Cancer_Type-specific_PeakCalls
mv *.txt TCGA-ATAC_Cancer_Type-specific_PeakCalls
```
```bash
bedtools intersect -a /home/s1949868/test_Overlap/Sample_PeakCalls_w/ACC*txt.sorted -b /home/s1949868/test_Overlap/Sample_PeakCalls_w/ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09*bed.sorted -f 1.0 -c -wa | awk '{FS=OFS="\t";if($5>1){print $1,$2,$3,$4}}' > /home/s1949868/test_Overlap/Sample_PeakCalls_w/ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_peakCalls.bed
```
```bash

```
`-f`： Minimum overlap required as **a fraction of A**. `-f 1.0` means 100% of the query record is overlapped by a database record.
`-c`: For each entry in A, report the number of hits in B while restricting to -f.
`-wa`: Write the original entry in A for each overlap.
`-sorted`: For very large B files, invoke a “sweeping” algorithm that requires position-sorted (e.g.,  sort  -k1,1  -k2,2n  for BED files) input. When using -sorted, memory usage remains low even for very large files.
bedtools intersect -a -b -f 1.0 -c -wa -sorted
ls ACC*


# Motif finding
## extract fasta
## fimo

# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[bedtools getfasta](https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwNzczNDg5MCw5OTMxOTA5NjEsMzQ5MD
gzMDQ0XX0=
-->