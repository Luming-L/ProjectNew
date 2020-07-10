This step will output a list of PRDM9 motif occurrences in ATAC-seq peaks for each of 410 biological samples.

# Input
Peak calls in each sample (404, the output of peakRefine.py)
# Process
## Find PRDM9 motif occurrences
```bash
fimo_batch.sh
```
### extracts sequences in FASTA by `bedtools  getfasta`

`-fo`: Specify an output file name.
```bash
bedtools getfasta -fi /home/s1949868/Tools/hg38.fa -bed $file -fo "${fileName}.fasta"
```
### find PRDM9 motif occurrences by `fimo`
`--parse-genomic-coord`: When this option is specified, each FASTA sequence header is checked for UCSC style genomic coordinates (e.g., `chr1:156887119-156887619`). The sequence ID in the FASTA header should have the form: >sequence name:starting position-ending position. If genomic coordinates are found they is used as the coordinates in the output. 

`--thresh num`: The threshold is a p-value of 1e-4.

`--oc dir`: Create a folder called dir but if it already exists allow overwriting the contents.

`--max-stored-scores`: Set the maximum number of scores that will be stored. The maximum number of stored matches is 100,000. The number of scores in `ACC_peakCalls_fimo_out` exceeds 100,000, so `--max-stored-scores` is set to **10,000,000**.
```bash
fimo  --verbosity 4 --parse-genomic-coord --max-stored-scores 10000000 --oc "${fileName}_fimo_out" /home/s1949868/PRDM9.pwm.meme "${fileName}.fasta"
```
# Output
## a list of PRDM9 motif occurrences for each of 410 samples
```bash
 wc -l * | sort -k1,1nr | head
 ```
 
	149893 BRCA_037238B0_8FB6_4ECC_9970_93E84F9286EF_X005_S09_peakCalls_fimo.gff
    149436 BRCA_FB055B59_7512_40E4_8547_39798A4C9B8C_X011_S09_peakCalls_fimo.gff
    147407 BRCA_1B6783CB_7D24_4D13_908A_19CCAD4CFF34_X002_S06_peakCalls_fimo.gff
    147388 BRCA_0142AAAC_FFE8_43B7_AB99_02F7A1740567_X022_S06_peakCalls_fimo.gff
    146856 BRCA_474D1E91_69F9_4779_B8CE_18F4946A0D9A_X021_S03_peakCalls_fimo.gff
    146531 BRCA_1D939DC3_EF0C_40BF_BC60_8C5D46345265_X021_S01_peakCalls_fimo.gff
    145779 BRCA_CA5AB738_9366_4908_B573_92C041E15471_X020_S05_peakCalls_fimo.gff
    145674 BRCA_EF17C882_9808_4676_9DFA_432D34290B33_X023_S15_peakCalls_fimo.gff
    145610 BRCA_74CCA3AC_8984_4207_AD8C_979E7596A5DC_X005_S02_peakCalls_fimo.gff
```bash
wc -l * | sort -k1,1nr | tail
```

     83750 UCEC_392EE08A_B49B_4257_BCBC_B3038B7174A8_X041_S11_peakCalls_fimo.gff
     83677 CESC_480D4965_DBC3_47D2_A352_E68A44F75232_X004_S10_peakCalls_fimo.gff
     82626 CESC_10041818_52A8_4856_ADEE_13E3FC97A737_X003_S09_peakCalls_fimo.gff
     81711 CESC_DADFADB7_86D6_4074_B19E_BB81F4D22A17_X004_S08_peakCalls_fimo.gff
     81547 LGGx_56FF7516_4BDD_4A58_8549_8AD0F007B970_X014_S09_peakCalls_fimo.gff
     78590 CESC_BA6FB645_26C4_436D_AF9D_653767310153_X004_S09_peakCalls_fimo.gff
     77260 MESO_E63A7EB2_8F27_499E_B9BF_92A8400388D6_X039_S01_peakCalls_fimo.gff
     70562 SKCM_79ECCC2A_6352_43BB_AF79_FABC426586EB_X040_S05_peakCalls_fimo.gff
     69548 STAD_CEF81A6C_B09A_4698_BC93_DC029B9CA17A_X028_S06_peakCalls_fimo.gff
     69083 SKCM_4EDE1486_22DD_4DB9_8CB1_B4A058E459D1_X035_S10_peakCalls_fimo.gff
**By the way, a list of PRDM9 motif occurrences for each of 23 cancer types**
```bash
for file in $(ls /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls/*_peakCalls.txt); do
> fileName=`basename -s ".txt" $file`
> awk '{OFS=FS="\t";if($1~/^chr/){print $1,$2,$3,$4}}' $file > "${fileName}.bed";
> done
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

```bash
for file in $(ls /exports/eddie/scratch/s1949868/MotifFind_fimo/*_peakCalls_fimo_out/fimo.gff); do
	fileName=`echo ${file#*MotifFind_fimo/}`; 
	fileName=`echo ${fileName%_out*}`;
	mv $file /exports/eddie/scratch/s1949868/MotifFind_fimo/allFimoGFF/${fileName}.gff
done
```
# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[bedtools getfasta](https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html)

[fimo](http://meme-suite.org/doc/fimo.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbODkyNzgyNjIsMTY1NTQxMTEzNCwyNjE1ND
I1OTYsMzc0NDAxNjAsMTQ0NDA2NzI3NCw2MDg4MDc2MzIsMTA3
OTQxODkzNiwxNzIwOTgwOTM4LDYzMTg5NTM4OCwtMTIwMTcxMD
E5MCwtMTgwMzE3MDI5NCwtOTUwOTE5MzYwLDgzMTI2NjMwNiwt
NDA3OTYwOTQxLDE3MzIxODUwMTksMTcwNjQyOTUyNSwzMTYwOD
IyMzksLTE2NDk4MDE3NjgsNzIxMDc2NDcwLC0xMzM5NDAyMTEw
XX0=
-->