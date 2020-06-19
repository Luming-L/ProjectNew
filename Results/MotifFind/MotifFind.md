
This step will output a list of PRDM9 motif occurrences for each of 410 biological samples.
# Step1 Refine recalled peaks 
Refine recalled peaks to get a list of peaks for each biological sample
## input files
**Cancer type-specific peak calls (23)**

Each text file represents all merged peak calls from each cancer type. 

**Recalled peaks in each technical replicate (796)**

The output of PeakRecall.py, see PeakRecall.md
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

15145132 total
	69538 KIRP_0C6C66CE_7D41_4176_8438_F275CDFE7759_X006_S07_peakCalls.bed
	64929 KIRP_DB49B30A_EECF_4F76_8E0B_3B0F612996F4_X006_S10_peakCalls.bed
	62570 BRCA_08499A64_3FD8_4E62_AF08_3C66AF93CAE7_X003_S05_peakCalls.bed
	61178 COAD_ED8C6999_09C5_4B1C_916B_0E479EB39F6D_X009_S08_peakCalls.bed
	59584 KIRP_BEB0AB9C_2DFA_49E1_BD4B_5A65BED95B83_X012_S12_peakCalls.bed
	56785 BRCA_6108FBB3_DFCE_4A67_A16D_0547827F058C_X008_S04_peakCalls.bed
	54419 KIRP_52DFFDB2_62DB_4DD7_91BB_B9C34FC1E08C_X016_S07_peakCalls.bed
	54321 BRCA_01112370_4F6F_4A20_9BE0_7975C3465268_X017_S04_peakCalls.bed
	54048 LIHC_9CFCE167_AE10_47E5_8E18_947E06323052_X026_S02_peakCalls.bed
```bash
wc -l * | sort -k1,1nr | tail
```
    14938 BRCA_78F79CE9_210D_47BF_B6AB_AA5327778FBE_X010_S03_peakCalls.bed
    14534 ESCA_2CF8A6D4_F43E_41A6_AD3B_22E699550CD2_X008_S08_peakCalls.bed
    13901 ESCA_663192A1_DAE9_463A_A3E4_C4E7EDBD5734_X006_S02_peakCalls.bed
    13005 CESC_DADFADB7_86D6_4074_B19E_BB81F4D22A17_X004_S08_peakCalls.bed
    12628 BRCA_E2534288_EFAE_4EF6_98A0_0A931BC20FF1_X017_S07_peakCalls.bed
    11948 STAD_CEF81A6C_B09A_4698_BC93_DC029B9CA17A_X028_S06_peakCalls.bed
    11904 LUSC_3453F6D2_352F_41E1_8307_382F1A2249CF_X030_S10_peakCalls.bed
    11641 HNSC_B4C01112_D529_49C5_A458_0E09DA1C071E_X041_S05_peakCalls.bed
    10499 SKCM_4EDE1486_22DD_4DB9_8CB1_B4A058E459D1_X035_S10_peakCalls.bed
     9067 LUSC_3AD1EA06_AA53_4C53_B436_4417FA2B8A0E_X031_S10_peakCalls.bed

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
# Results
**a list of PRDM9 motif occurrences for each of 410 biological samples**
```bash
wc -l ./*_fimo_out/fimo.gff | sort -k1,1nr
```
28118875 total

     96436 ./BRCA_1253F1AD_60FD_4536_97A8_E84B756E5E52_X004_S05_peakCalls_fimo_out/fimo.gff
     94974 ./KIRP_BEB0AB9C_2DFA_49E1_BD4B_5A65BED95B83_X012_S12_peakCalls_fimo_out/fimo.gff
     94858 ./KIRP_DB49B30A_EECF_4F76_8E0B_3B0F612996F4_X006_S10_peakCalls_fimo_out/fimo.gff
     94813 ./KIRP_0C6C66CE_7D41_4176_8438_F275CDFE7759_X006_S07_peakCalls_fimo_out/fimo.gff
     93777 ./COAD_ED8C6999_09C5_4B1C_916B_0E479EB39F6D_X009_S08_peakCalls_fimo_out/fimo.gff
     
...

	 30308 ./HNSC_B4C01112_D529_49C5_A458_0E09DA1C071E_X041_S05_peakCalls_fimo_out/fimo.gff
     30082 ./LUSC_3453F6D2_352F_41E1_8307_382F1A2249CF_X030_S10_peakCalls_fimo_out/fimo.gff
     28731 ./STAD_CEF81A6C_B09A_4698_BC93_DC029B9CA17A_X028_S06_peakCalls_fimo_out/fimo.gff
     26153 ./SKCM_4EDE1486_22DD_4DB9_8CB1_B4A058E459D1_X035_S10_peakCalls_fimo_out/fimo.gff
     24424 ./LUSC_3AD1EA06_AA53_4C53_B436_4417FA2B8A0E_X031_S10_peakCalls_fimo_out/fimo.gff

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
# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[bedtools getfasta](https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html)

[fimo](http://meme-suite.org/doc/fimo.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbNjM4ODUxMzIwLC0xMDExMjQyODI2LC0yNj
M1NDU2NzQsMTA5MzY5NjY3MSwyMDg0MjYxODQxLC00MDE3NDQy
MzMsMjAwODUwNDU0NywxMzU2MDYxODksMTc1MjYwNjgsLTkxNj
UwMzc2MSw0NTY3NjY5MTgsMTE1MjU0MDE5LC01MzY4MjQyMSwt
MTA2ODA5MTY5OSwtMTYwNDIzNTkzLC0xMDYzOTAzNzExLC05MT
A2MDM4NDksLTE0MTQyMTM3MTEsMTIwNjkyOTM5MywxMTg4MTQ3
NjIzXX0=
-->