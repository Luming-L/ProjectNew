# MotifFind for 404 samples
## Input
Peak calls in each sample (404, the output of peakRefine.py)
## Process
### Find PRDM9 motif occurrences
```bash
qsub ~/fimo_batch.sh
```
#### extracts sequences in FASTA by `bedtools  getfasta`
`-fo`: Specify an output file name.
```bash
bedtools getfasta -fi /home/s1949868/Tools/hg38.fa -bed $file -fo "${fileName}.fasta"
```
#### find PRDM9 motif occurrences by `fimo`
`--parse-genomic-coord`: When this option is specified, each FASTA sequence header is checked for UCSC style genomic coordinates (e.g., `chr1:156887119-156887619`). The sequence ID in the FASTA header should have the form: >sequence name:starting position-ending position. If genomic coordinates are found they is used as the coordinates in the output. 

`--thresh num`: The threshold is a p-value of 1e-4.

`--oc dir`: Create a folder called dir but if it already exists allow overwriting the contents.

`--max-stored-scores`: Set the maximum number of scores that will be stored. The maximum number of stored matches is 100,000. The number of scores in `ACC_peakCalls_fimo_out` exceeds 100,000, so `--max-stored-scores` is set to **10,000,000**.
```bash
fimo  --verbosity 4 --parse-genomic-coord --max-stored-scores 10000000 --oc "${fileName}_fimo_out" /home/s1949868/PRDM9.pwm.meme "${fileName}.fasta"
```
### Rename files
```bash
for file in $(ls /exports/eddie/scratch/s1949868/MotifFind_fimo/*_peakCalls_fimo_out/fimo.gff); do
	fileName=`echo ${file#*MotifFind_fimo/}`; 
	fileName=`echo ${fileName%_out*}`;
	mv $file /exports/eddie/scratch/s1949868/MotifFind_fimo/allFimoGFF_CaseID/${fileName}.gff
done
```
### get number of PRDM9 binding sites in peaks
```bash
echo -e "ID\tnumPRDM9MotifInPeaks" > numPRDM9MotifInPeaks.txt
# count PRDM9 binding sites in peaks for each sample
for file in $(ls /exports/eddie/scratch/s1949868/MotifFind_fimo/allFimoGFF_CaseID/*_fimo.gff); do
	echo $file

	ID=`echo ${file#*allFimoGFF_CaseID/}`; 
	ID=`echo ${ID%_peakCalls_fimo*}`;
	echo $ID

	numPRDM9MotifInPeaks=`grep -v "#" $file | wc -l`; 

	echo -e "$ID\t$numPRDM9MotifInPeaks" >> numPRDM9MotifInPeaks.txt
done
```
## Output
404 `_peakCalls_fimo.gff`
a list of PRDM9 motif occurrences in ATAC-seq peaks for each of 404 samples.
# MotifFind for 23 cancerTypes
## Input
Cancer type-specific peak calls (23)
## Process
### transform `.txt` to `.bed`
```bash
for file in $(ls /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls/*_peakCalls.txt); do
> fileName=`basename -s ".txt" $file`
> awk '{OFS=FS="\t";if($1~/^chr/){print $1,$2,$3,$4}}' $file > "${fileName}.bed";
> done
```
### Find PRDM9 motif occurrences
```bash
qsub ~/fimo_batch.sh
```
### Rename files
```bash
for file in $(ls /exports/eddie/scratch/s1949868/MotifFind_fimo_23/*_peakCalls_fimo_out/fimo.gff); do
	fileName=`echo ${file#*MotifFind_fimo_23/}`; 
	fileName=`echo ${fileName%_out*}`;
	mv $file /exports/eddie/scratch/s1949868/MotifFind_fimo_23/allFimoGFF_CaseID_23/${fileName}.gff
done
```
## Output
a list of PRDM9 motif occurrences for each of 23 cancer types












# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[bedtools getfasta](https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html)

[fimo](http://meme-suite.org/doc/fimo.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTY2MjcwODcwLDE0MDk3MjUwNiwxNDYwND
Y1MTg5LC0xNTQyNjU0MzQ1LDgwNjI2MjM3MywyOTQyMjMyNTUs
MTQxOTU2NTg1MywtNzM4NzQ2MDkwLDE2NTU0MTExMzQsMjYxNT
QyNTk2LDM3NDQwMTYwLDE0NDQwNjcyNzQsNjA4ODA3NjMyLDEw
Nzk0MTg5MzYsMTcyMDk4MDkzOCw2MzE4OTUzODgsLTEyMDE3MT
AxOTAsLTE4MDMxNzAyOTQsLTk1MDkxOTM2MCw4MzEyNjYzMDZd
fQ==
-->