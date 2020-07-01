
This step will output a list of PRDM9 motif occurrences for each of 410 biological samples.
# Step1 Refine recalled peaks 
Refine recalled peaks to get a list of peaks for each biological sample
## input files
**Cancer type-specific peak calls (23)**

Each text file represents all merged peak calls from each cancer type. 

****


## substeps
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
cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls # Cancer_Type_PeakCalls_path in peakOverlap.py
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/PeakCall_410_c3l400/${file}.sorted; done
# cut files of recalled peaks in each technical replicate
cd /exports/eddie/scratch/s1949868/PeakRecall_796_c3l400 # peaks_path in peakOverlap.py
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3}}' > /exports/eddie/scratch/s1949868/PeakCall_410_c3l400/${file}.sorted; done
```
### refine recalled peaks by using `bedtools intersect`
1. for each technical replicate (796), the minimum overlap between cancer type peaks and sample recalled peaks should be more than 60% of cancer type peaks. (set by `-f 0.6`) Then output these cancer type peaks.
2. refined peaks in two replicates from the same sample will be merged. only report peaks obeserved in two replicates (set by `-c`)
3. finally get a list of peaks for each of 410 biological samples

**options**
`-f`： Minimum overlap required as **a fraction of A**. 

`-c`: For each entry in A, report the number of hits in B while restricting to -f.

`-wa`: Write the original entry in A for each overlap.

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. 

**command for a sample with 1 technical replicate**
```bash
bedtools intersect -a " + path + "/" + sample.split("_")[0].replace('x', '') + "*txt.sorted -b " + path + "/" + sample + "*bed.sorted -f 0.6 -u > " + path + "/" + sample+"_peakCalls.bed
```
**command for a sample with 2 technical replicates**
```bash
bedtools intersect -a " + path + "/" + sample.split("_")[0].replace('x', '') + "*txt.sorted -b " + path + "/" + sample + "*bed.sorted -f 0.6 -c -wa" + " | awk '{FS=OFS=" + r'"\t"' + ";if($5>1){print $1,$2,$3,$4}}'" + " > " + path + "/" + sample+"_peakCalls.bed
```
```bash
wc -l * | sort -k1,1nr | head
```
    86903 KIRP_DB49B30A_EECF_4F76_8E0B_3B0F612996F4_X006_S10_peakCalls.bed
    86362 KIRP_0C6C66CE_7D41_4176_8438_F275CDFE7759_X006_S07_peakCalls.bed
    81368 BRCA_08499A64_3FD8_4E62_AF08_3C66AF93CAE7_X003_S05_peakCalls.bed
    78382 BRCA_0142AAAC_FFE8_43B7_AB99_02F7A1740567_X022_S06_peakCalls.bed
    78115 KIRP_9E89F1FA_31C6_46C4_B203_29DBB9F1B184_X016_S06_peakCalls.bed
    76704 BRCA_6108FBB3_DFCE_4A67_A16D_0547827F058C_X008_S04_peakCalls.bed
    76348 KIRP_5E268D3E_9CC0_4D85_9742_765A53CB3D96_X015_S03_peakCalls.bed
    76050 BRCA_8D1E6006_85CB_484A_8B5C_30766D90137B_X012_S03_peakCalls.bed
    75700 COAD_ED8C6999_09C5_4B1C_916B_0E479EB39F6D_X009_S08_peakCalls.bed
```bash
wc -l * | sort -k1,1nr | tail
```
    30498 TGCT_1577A485_E047_42CF_8703_42A69E1AED1A_X038_S09_peakCalls.bed
    30041 COAD_74EF44ED_9B3A_4E21_9E86_6C753CF94F4F_X006_S03_peakCalls.bed
    28925 BRCA_78F79CE9_210D_47BF_B6AB_AA5327778FBE_X010_S03_peakCalls.bed
    27372 MESO_E63A7EB2_8F27_499E_B9BF_92A8400388D6_X039_S01_peakCalls.bed
    26776 BRCA_E2534288_EFAE_4EF6_98A0_0A931BC20FF1_X017_S07_peakCalls.bed
    26181 HNSC_B4C01112_D529_49C5_A458_0E09DA1C071E_X041_S05_peakCalls.bed
    24061 LUSC_3453F6D2_352F_41E1_8307_382F1A2249CF_X030_S10_peakCalls.bed
    21414 STAD_CEF81A6C_B09A_4698_BC93_DC029B9CA17A_X028_S06_peakCalls.bed
    20660 SKCM_4EDE1486_22DD_4DB9_8CB1_B4A058E459D1_X035_S10_peakCalls.bed
    18855 LUSC_3AD1EA06_AA53_4C53_B436_4417FA2B8A0E_X031_S10_peakCalls.bed
# Step2 Find PRDM9 motif occurrences
The script `fimo_batch.sh` includes these two steps.
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

The number of scores in `ACC_peakCalls_fimo_out` exceeds 100,000, so `--max-stored-scores` is set to **10,000,000**.

**command**
```bash
fimo  --verbosity 4 --parse-genomic-coord --max-stored-scores 10000000 --oc "${fileName}_fimo_out" /home/s1949868/PRDM9.pwm.meme "${fileName}.fasta"
```
# Results
**a list of PRDM9 motif occurrences for each of 410 biological samples**
```bash
wc -l ./*_fimo_out/fimo.gff | sort -k1,1nr
```
    113732 ./BRCA_1253F1AD_60FD_4536_97A8_E84B756E5E52_X004_S05_peakCalls_fimo_out/fimo.gff
    113584 ./BRCA_0142AAAC_FFE8_43B7_AB99_02F7A1740567_X022_S06_peakCalls_fimo_out/fimo.gff
    112052 ./KIRP_DB49B30A_EECF_4F76_8E0B_3B0F612996F4_X006_S10_peakCalls_fimo_out/fimo.gff
    109420 ./BRCA_359C8EB0_48BC_47D5_AD78_38B0AE6C5FB8_X018_S05_peakCalls_fimo_out/fimo.gff
    109105 ./BRCA_CC102C17_C1CA_427A_8C7D_D3E79748A0CD_X004_S04_peakCalls_fimo_out/fimo.gff
    108485 ./BRCA_FB1C995E_6C78_414A_B74C_8C77CD924348_X015_S09_peakCalls_fimo_out/fimo.gff
    107089 ./KIRP_FAD34DB3_49EA_4DDC_A565_145EC396087E_X013_S10_peakCalls_fimo_out/fimo.gff
    107013 ./KIRP_0C6C66CE_7D41_4176_8438_F275CDFE7759_X006_S07_peakCalls_fimo_out/fimo.gff
    106756 ./KIRP_72FE20F7_344B_4E28_B403_E85361A66552_X008_S10_peakCalls_fimo_out/fimo.gff
     
...

     60631 ./STAD_91C7155F_8187_4688_BEAB_C4179C786667_X029_S08_peakCalls_fimo_out/fimo.gff
     59926 ./BRCA_78F79CE9_210D_47BF_B6AB_AA5327778FBE_X010_S03_peakCalls_fimo_out/fimo.gff
     59873 ./HNSC_D6F95774_441D_47F6_93CE_999D7BE81E44_X040_S11_peakCalls_fimo_out/fimo.gff
     58371 ./BRCA_E2534288_EFAE_4EF6_98A0_0A931BC20FF1_X017_S07_peakCalls_fimo_out/fimo.gff
     55949 ./HNSC_B4C01112_D529_49C5_A458_0E09DA1C071E_X041_S05_peakCalls_fimo_out/fimo.gff
     52532 ./UCEC_392EE08A_B49B_4257_BCBC_B3038B7174A8_X041_S11_peakCalls_fimo_out/fimo.gff
     52347 ./LUSC_3453F6D2_352F_41E1_8307_382F1A2249CF_X030_S10_peakCalls_fimo_out/fimo.gff
     46446 ./STAD_CEF81A6C_B09A_4698_BC93_DC029B9CA17A_X028_S06_peakCalls_fimo_out/fimo.gff
     45681 ./SKCM_4EDE1486_22DD_4DB9_8CB1_B4A058E459D1_X035_S10_peakCalls_fimo_out/fimo.gff
     44084 ./LUSC_3AD1EA06_AA53_4C53_B436_4417FA2B8A0E_X031_S10_peakCalls_fimo_out/fimo.gff


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
# Step3 Select peaks containing PRDM9 motif occurrences
script `findPRDM9BoundPeaks.sh`
```bash
bedtools intersect -a /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls/bed/"${fileName}.bed" -b $file -u -F 1.0 > "${fileName}_PRDM9_bound_peaks.bed"
```
## 23 cancerType
```bash
wc -l *PRDM9_bound_peaks.bed* | sort -k1,1nr | head
wc -l *PRDM9_bound_peaks.bed* | sort -k1,1nr | tail
```
1080239 total

	82325 BRCA_peakCalls_PRDM9_bound_peaks.bed
	58338 KIRP_peakCalls_PRDM9_bound_peaks.bed
	57393 LUAD_peakCalls_PRDM9_bound_peaks.bed
	56079 ESCA_peakCalls_PRDM9_bound_peaks.bed
	53380 COAD_peakCalls_PRDM9_bound_peaks.bed
	53233 STAD_peakCalls_PRDM9_bound_peaks.bed
	50633 LUSC_peakCalls_PRDM9_bound_peaks.bed
	49255 LIHC_peakCalls_PRDM9_bound_peaks.bed
	48382 BLCA_peakCalls_PRDM9_bound_peaks.bed
...

	42171 TGCT_peakCalls_PRDM9_bound_peaks.bed
	41971 THCA_peakCalls_PRDM9_bound_peaks.bed
	41476 PCPG_peakCalls_PRDM9_bound_peaks.bed
	41062 SKCM_peakCalls_PRDM9_bound_peaks.bed
	40421 ACC_peakCalls_PRDM9_bound_peaks.bed
	39970 LGG_peakCalls_PRDM9_bound_peaks.bed
	38538 GBM_peakCalls_PRDM9_bound_peaks.bed
	36184 MESO_peakCalls_PRDM9_bound_peaks.bed
	35584 CHOL_peakCalls_PRDM9_bound_peaks.bed
	30652 CESC_peakCalls_PRDM9_bound_peaks.bed

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
eyJoaXN0b3J5IjpbMTcwMzIyMTU1MSwtMTY0OTgwMTc2OCw3Mj
EwNzY0NzAsLTEzMzk0MDIxMTAsMTE4NzgwNzI4NywtMTQyMTU4
MTE1Miw2NTU4MDk3MzIsNjM4ODUxMzIwLC0xMDExMjQyODI2LC
0yNjM1NDU2NzQsMTA5MzY5NjY3MSwyMDg0MjYxODQxLC00MDE3
NDQyMzMsMjAwODUwNDU0NywxMzU2MDYxODksMTc1MjYwNjgsLT
kxNjUwMzc2MSw0NTY3NjY5MTgsMTE1MjU0MDE5LC01MzY4MjQy
MV19
-->