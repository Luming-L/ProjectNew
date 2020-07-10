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
for file in $(ls /exports/eddie/scratch/s1949868/MotifFind_fimo/*_peakCalls_fimo_out/fimo.gff); do
	fileName=`echo ${file#*MotifFind_fimo/}`; 
	fileName=`echo ${fileName%_out*}`;
	mv $file /exports/eddie/scratch/s1949868/MotifFind_fimo/allFimoGFF_CaseID/${fileName}.gff
done
```
## Output
a list of PRDM9 motif occurrences for each of 23 cancer types




```bash

qsub qsub ~/fimo_batch.sh
wc -l ./*_fimo_out/fimo.gff | sort -k1,1nr
```

  2845652 total
  
	184385 ./BRCA_peakCalls_fimo_out/fimo.gff
	175572 ./BLCA_peakCalls_fimo_out/fimo.gff
	163170 ./PRAD_peakCalls_fimo_out/fimo.gff
	142972 ./KIRP_peakCalls_fimo_out/fimo.gff
	137216 ./ESCA_peakCalls_fimo_out/fimo.gff

...

	106200 ./SKCM_peakCalls_fimo_out/fimo.gff
	106092 ./ACC_peakCalls_fimo_out/fimo.gff
	98454 ./CHOL_peakCalls_fimo_out/fimo.gff
	96894 ./MESO_peakCalls_fimo_out/fimo.gff
	84528 ./CESC_peakCalls_fimo_out/fimo.gff


# get number of PRDM9 binding sites in peaks
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


script `findPRDM9BoundPeaks.sh`
```bash
bedtools intersect -a /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls/bed/"${fileName}.bed" -b $file -u -F 1.0 > "${fileName}_PRDM9_bound_peaks.bed"
```
## 23 cancerType
```bash
wc -l *PRDM9_bound_peaks.bed* | sort -k1,1nr | head
wc -l *PRDM9_bound_peaks.bed* | sort -k1,1nr | tail
```


## 410 samples
```bash
wc -l *_PRDM9_bound_peaks.bed* | sort -k1,1nr | head
wc -l *_PRDM9_bound_peaks.bed* | sort -k1,1nr | tail
```
 12716927 total
 
	42034 KIRP_DB49B30A_EECF_4F76_8E0B_3B0F612996F4_X006_S10_PRDM9_bound_peaks.bed
	41876 BRCA_0142AAAC_FFE8_43B7_AB99_02F7A1740567_X022_S06_PRDM9_bound_peaks.bed
	41366 BRCA_1253F1AD_60FD_4536_97A8_E84B756E5E52_X004_S05_PRDM9_bound_peaks.bed
	40729 BRCA_FB1C995E_6C78_414A_B74C_8C77CD924348_X015_S09_PRDM9_bound_peaks.bed
	40709 KIRP_0C6C66CE_7D41_4176_8438_F275CDFE7759_X006_S07_PRDM9_bound_peaks.bed
	40009 BRCA_359C8EB0_48BC_47D5_AD78_38B0AE6C5FB8_X018_S05_PRDM9_bound_peaks.bed
	39791 BRCA_CC102C17_C1CA_427A_8C7D_D3E79748A0CD_X004_S04_PRDM9_bound_peaks.bed
	39345 BRCA_08499A64_3FD8_4E62_AF08_3C66AF93CAE7_X003_S05_PRDM9_bound_peaks.bed
	39026 BRCA_DD69EDE9_142D_46E2_AA06_58D07D3230FB_X016_S08_PRDM9_bound_peaks.bed
...

    19943 HNSC_D6F95774_441D_47F6_93CE_999D7BE81E44_X040_S11_PRDM9_bound_peaks.bed
    19527 BRCA_78F79CE9_210D_47BF_B6AB_AA5327778FBE_X010_S03_PRDM9_bound_peaks.bed
    19387 MESO_E63A7EB2_8F27_499E_B9BF_92A8400388D6_X039_S01_PRDM9_bound_peaks.bed
    18551 BRCA_E2534288_EFAE_4EF6_98A0_0A931BC20FF1_X017_S07_PRDM9_bound_peaks.bed
    18023 HNSC_B4C01112_D529_49C5_A458_0E09DA1C071E_X041_S05_PRDM9_bound_peaks.bed
    17535 UCEC_392EE08A_B49B_4257_BCBC_B3038B7174A8_X041_S11_PRDM9_bound_peaks.bed
    16802 LUSC_3453F6D2_352F_41E1_8307_382F1A2249CF_X030_S10_PRDM9_bound_peaks.bed
    14538 STAD_CEF81A6C_B09A_4698_BC93_DC029B9CA17A_X028_S06_PRDM9_bound_peaks.bed
    14357 SKCM_4EDE1486_22DD_4DB9_8CB1_B4A058E459D1_X035_S10_PRDM9_bound_peaks.bed
    13500 LUSC_3AD1EA06_AA53_4C53_B436_4417FA2B8A0E_X031_S10_PRDM9_bound_peaks.bed


# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[bedtools getfasta](https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html)

[fimo](http://meme-suite.org/doc/fimo.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbNzMyMTM1MTMyLC0xNTQyNjU0MzQ1LDgwNj
I2MjM3MywyOTQyMjMyNTUsMTQxOTU2NTg1MywtNzM4NzQ2MDkw
LDE2NTU0MTExMzQsMjYxNTQyNTk2LDM3NDQwMTYwLDE0NDQwNj
cyNzQsNjA4ODA3NjMyLDEwNzk0MTg5MzYsMTcyMDk4MDkzOCw2
MzE4OTUzODgsLTEyMDE3MTAxOTAsLTE4MDMxNzAyOTQsLTk1MD
kxOTM2MCw4MzEyNjYzMDYsLTQwNzk2MDk0MSwxNzMyMTg1MDE5
XX0=
-->