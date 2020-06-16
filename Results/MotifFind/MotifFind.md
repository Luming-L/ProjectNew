
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
sort
bedtools intersect -wa -a -b -f 1.0 -c -sorted
`-f`： Minimum overlap required as **a fraction of A**. `-f 1.0` means 100% of the query record is overlapped by a database record.
`-c`: For each entry in A, report the number of hits in B while restricting to -f.
`-wa`: Write the original entry in A for each overlap.
`-sorted`: For very large B files, invoke a “sweeping” algorithm that requires position-sorted (e.g.,  sort  -k1,1  -k2,2n  for BED files) input. When using -sorted, memory usage remains low even for very large files.
bedtools intersect -a -b -f 1.0 -c -wa -sorted
ls ACC*


# Motif finding
## extract fasta
## fimo

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyNTE5NDQ4MDMsMzQ5MDgzMDQ0XX0=
-->