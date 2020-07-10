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
# prepare the input of bedtools
echo "sort start: $(date)"
# sort and cut files of Cancer Type-specific PeakCalls
cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls # Cancer_Type_PeakCalls_path in peakOverlap.py
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/RefineRecalledPeaks/${file}.sorted; done
cd /exports/eddie/scratch/s1949868/RecallPeak # peaks_path in peakOverlap.py
for file in $(ls ./*insertions.peaks.bed); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3}}' > /exports/eddie/scratch/s1949868/RefineRecalledPeaks/${file}.sorted; done
echo "sort done: $(date)"
```
## Refine peaks by overlapping with cancer type-specific peak sets
```bash
qsub ~/peakRefine_batch.sh
```
1. for each technical replicate (796), the minimum overlap between cancer type peaks and sample recalled peaks should be more than 60% of cancer type peaks. (set by `-f 0.6`) Then output these cancer type peaks.
2. refined peaks in two replicates from the same sample will be merged. only report peaks obeserved in two replicates (set by `-c`)
3. finally get a list of peaks for each of 410 biological samples

**options**
`-f`： Minimum overlap required as **a fraction of A**. 

`-c`: For each entry in A, report the number of hits in B while restricting to -f.

`-wa`: Write the original entry in A for each overlap.

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. 
```python
if bioSample_dict[sample] == 1: # 1 technical replicate for a ID
	os.system("bedtools intersect -a " + path + "/" + sample.split("_")[0].replace('x', '') + "*txt.sorted -b " + path + "/" + sample + "*bed.sorted -f 0.5 -u > " + path + "/" + sample+"_peakCalls.bed")
elif bioSample_dict[sample] == 2: # 2 technical replicates for a ID
	os.system("bedtools intersect -a " + path + "/" + sample.split("_")[0].replace('x', '') + "*txt.sorted -b " + path + "/" + sample + "*bed.sorted -f 0.5 -c -wa" + " | awk '{FS=OFS=" + r'"\t"' + ";if($5>0){print $1,$2,$3,$4}}'" + " > " + path + "/" + sample+"_peakCalls.bed")
```
## Rename PeakCalls of 410 samples
```bash
mkdir allPeakCalls
mv ./*_peakCalls.bed allPeakCalls

 1017  cd allPeakCalls/
 1018  ll
 1019  ll | wc -l

```bash
for file in $(ls /exports/eddie/scratch/s1949868/MotifFind_fimo/*_peakCalls_fimo_out/fimo.gff); do
	fileName=`echo ${file#*MotifFind_fimo/}`; 
	fileName=`echo ${fileName%_out*}`;
	mv $file /exports/eddie/scratch/s1949868/MotifFind_fimo/allFimoGFF/${fileName}.gff
done
```
# Output
ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_peakCalls.bed
410 samples from 404 donors
Some samples are just different in portion.
[TCGA_Barcode/](https://docs.gdc.cancer.gov/Encyclopedia/pages/TCGA_Barcode/)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTg4MjAxMzMyNyw0OTAyOTI5MjYsMTU0Nz
k5NjE4NywtNDM5ODY0MTMzLC0yMTM3MzQzOTIzLC01Mjk3NjM0
MTgsMTg2Mjg0NTMxOSwxNDY2NDI1MDM0LC0xMjk0MjA3Njk2LD
E4NDg2NTMxMDAsLTEzODczNzY4OThdfQ==
-->