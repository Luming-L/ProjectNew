
This step will output a list of PRDM9 motif occurrences for each of 410 biological samples.
# 1.Refine recalled peaks 
Refine recalled peaks to get a list of peaks for each biological sample
## input files
**Cancer type-specific peak calls (23)**

Each text file represents all merged peak calls from each cancer type. 

**Recalled peaks in each technical replicate (796)**

The output of PeakRecall.py, see PeakRecall.md
## steps
**Two scripts `peakOverlap.py` and `peakOverlap_batch.sh` (run `peakOverlap.py` on eddie) contain these steps.**
### download cancer type-specific PeakCalls
```bash
wget https://api.gdc.cancer.gov/data/71ccfc55-b428-4a04-bb5a-227f7f3bf91c
unzip 71ccfc55-b428-4a04-bb5a-227f7f3bf91c
mkdir TCGA-ATAC_Cancer_Type-specific_PeakCalls
mv *.txt TCGA-ATAC_Cancer_Type-specific_PeakCalls
```
### prepare the input of bedtools
sort files
```bash
# sort and cut files of Cancer Type-specific PeakCalls
cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/Sample_PeakCalls/${file}.sorted; done
# cut files of recalled peaks in each technical replicate
cd /exports/eddie/scratch/s1949868/PeakRecall_peaks001
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3}}' > /exports/eddie/scratch/s1949868/Sample_PeakCalls/${file}.sorted; done
```
### refine recalled peaks by using `bedtools intersect`
1. for each technical replicate (796), output cancer type-specific peaks that can be 100% overlapped by recalled peaks (set by `-f 1.0`)
2. refined peaks in two replicates from the same sample will be merged. only report peaks obeserved in two replicates (set by `-c`)
3. finally get a list of peaks for each of 410 biological samples

**options**
`-f`： Minimum overlap required as **a fraction of A**. `-f 1.0` means 100% of the query record is overlapped by a database record.

`-c`: For each entry in A, report the number of hits in B while restricting to -f.

`-wa`: Write the original entry in A for each overlap.

**command for a sample with 1 technical replicate**
```bash
bedtools intersect -a /home/s1949868/test_Overlap/Sample_PeakCalls_w/HNSC*txt.sorted -b /home/s1949868/test_Overlap/Sample_PeakCalls_w/HNSC_D6F95774_441D_47F6_93CE_999D7BE81E44_X040_S11*bed.sorted -f 1.0 -wa > /home/s1949868/test_Overlap/Sample_PeakCalls_w/HNSC_D6F95774_441D_47F6_93CE_999D7BE81E44_X040_S11_peakCalls.bed
```
**command for a sample with 2 technical replicates**
```bash
bedtools intersect -a /home/s1949868/test_Overlap/Sample_PeakCalls_w/LIHC*txt.sorted -b /home/s1949868/test_Overlap/Sample_PeakCalls_w/LIHC_31861258_F778_40B3_A2A4_E4E8F00794B2_X037_S08*bed.sorted -f 1.0 -c -wa | awk '{FS=OFS="\t";if($5>1){print $1,$2,$3,$4}}' > /home/s1949868/test_Overlap/Sample_PeakCalls_w/LIHC_31861258_F778_40B3_A2A4_E4E8F00794B2_X037_S08_peakCalls.bed
```
# 2.Find PRDM9 motif occurrences
## extracts sequences in FASTA by `bedtools  getfasta`
**version**: BEDTools/2.27.1

**options**

`-fo`: Specify an output file name.

**command**
```bash
bedtools getfasta -fi /home/s1949868/Tools/hg38.fa -bed $file -fo "${fileName}.fasta"
```
## find PRDM9 motif occurrences by `fimo`
**version**: meme/4.11.1

**options**

`--parse-genomic-coord`: When this option is specified, each FASTA sequence header is checked for UCSC style genomic coordinates (e.g., `chr1:156887119-156887619`). The sequence ID in the FASTA header should have the form: >sequence name:starting position-ending position. If genomic coordinates are found they is used as the coordinates in the output. 

`--thresh num`: The threshold is a p-value of 1e-4.

`--oc dir`: Create a folder called dir but if it already exists allow overwriting the contents.

`--max-stored-scores`: Set the maximum number of scores that will be stored. The maximum number of stored matches is 100,000.

**note**
```bash
wc -l ./*_fimo_out/fimo.gff
```
106092 ./ACC_peakCalls_fimo_out/fimo.gff 
70538 ./ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_peakCalls_fimo_out/fimo.gff
176630 total

The number of scores in `ACC_peakCalls_fimo_out` exceeds 100,000, so `--max-stored-scores` is set to **10,000,000**.

**command**
```bash
fimo  --verbosity 4 --parse-genomic-coord --max-stored-scores 10000000 --oc "${fileName}_fimo_out" /home/s1949868/PRDM9.pwm.meme "${fileName}.fasta"
```
# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[bedtools getfasta](https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html)

[fimo](http://meme-suite.org/doc/fimo.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE2MDQyMzU5MywtMTA2MzkwMzcxMSwtOT
EwNjAzODQ5LC0xNDE0MjEzNzExLDEyMDY5MjkzOTMsMTE4ODE0
NzYyMywxMTg4NjA5NzE5LDYxODA1OTM5MCwtOTA5NDMxMTQsMT
c2NTg5NDMwNSwtNDE1MDQxMCwtMTYzNjIzNTcwMCwtMTgzNzY3
NzEyOCwtNzI2ODIwMjAyLDk5MzE5MDk2MSwzNDkwODMwNDRdfQ
==
-->