
# Input
Recalled peaks in each technical replicate (796, the output of PeakRecall.py)
Cancer type-specific peak calls (23)
# Process
## download cancer type-specific PeakCalls
```bash
wget https://api.gdc.cancer.gov/data/71ccfc55-b428-4a04-bb5a-227f7f3bf91c
unzip 71ccfc55-b428-4a04-bb5a-227f7f3bf91c
mkdir TCGA-ATAC_Cancer_Type-specific_PeakCalls
mv *.txt TCGA-ATAC_Cancer_Type-specific_PeakCalls
```
## prepare the input of bedtools
sort files
```bash
# sort and cut files of Cancer Type-specific PeakCalls
cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls # Cancer_Type_PeakCalls_path in peakOverlap.py
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/PeakRefine/${file}.sorted; done
# cut files of recalled peaks in each technical replicate
cd /exports/eddie/scratch/s1949868/PeakRecall_796_c3l400 # peaks_path in peakOverlap.py
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3}}' > /exports/eddie/scratch/s1949868/PeakCall_410_c3l400/${file}.sorted; done
```
# Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyOTQyMDc2OTYsMTg0ODY1MzEwMCwtMT
M4NzM3Njg5OF19
-->