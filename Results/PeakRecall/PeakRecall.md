# Input file
The input files for peak recalling are ATAC-seq signal tracks that have been normalized by the number of reads in peaks. The format of signal tracks files provided by author are BigWig and we convert them to BedGraph as input.

**Method of generating ATAC-seq signal tracks in the paper:**
 1. bin genome into 100-bp intervals
 2. convert the Tn5 offset-corrected insertion sites into a coverage
 3. calculate the sum of per position coverage in each bin as the number of Tn5 insertions within each bin
 4. normalize the total number of reads by a scale factor that converted all samples to a constant 30 million reads within peaks
 5. normalize samples by their quality and read depth

**Usage:**

In the BedGraph file, the score is the signal in each 100-bp bin. We can take the average signal of all bins as genome background and calculate the statistical significance for signal in each bin.
|chr|start|end|score|
|--|--|--|--|
|chr1|0|9999|0.000000|
|chr1|9999|10099|9.525880|
|chr1|10099|10199|14.288800|
# Rationale
> `callpeak` used by author: For each sample, peak calling was performed on the Tn5-corrected single-base insertions using the MACS2 callpeak command with parameters “--shift -75 --extsize 150 --nomodel --call-summits --nolambda --keep-dup all -p 0.01”. The peak summits were then extended by 250 bp on either side to a final width of 501 bp.

> read length: 75 bp paired-end.

In MACS2, the main function `callpeak` can be decomposed into a pipeline containing MACS2 subcommands. The pipeline follows these steps: 
1. Filter duplicates
2. Decide the fragment length d
3. Extend ChIP sample to get ChIP coverage track
4. Build local bias track from control
5. Scale the ChIP and control to the same sequencing depth
6. Compare ChIP and local lambda to get the scores in pvalue or qvalue
7. Call peaks on score track using a cutoff

**For our input files, we follow step 4, 6 and 7.**
## Step 4: Build local bias track from control
`callpeak` by default computes the local noise by taking the maximum noise from surrounding 1kb, 10kb, the size of fragment length _d_ (the predicted length of the DNA fragment that you are interested), and the whole genome background. For d, 1kb and 10kb background, the control read will be extended to both sides by d/2, 500 and 5000 bp, respectively, to reproduce noise from a region surrounding the read. The coverage at each position after normalization will be the corresponding local noise. As to the noise from genome background, it is calculated as _the_number_of_control_reads*fragment_length/genome_size_. At each position, the maximum in these four values will be the local noise, which is regarded as the lambda and can be compared with ChIP signals using the local Poisson test. When a control sample is not available, lambda is calculated from the ChIP-seq sample, excluding d and 1kb.

**In our case**, `callpeak` used by author turned on `--nolambda` option, which means MACS used the background lambda as local lambda, and we just have normalized ATAC-seq signal tracks in BedGraph and thus cannot extend reads. Therefore, the genome-wide average signal will be used as noise. We can calculate it as:
(_sum_of_signals_in_all_bins/genome_zise)*bin_size_
We will generate a another BedGraph file to store the lambda.

**another thing:** The score in BedGraph for peak calling is signal in each 100-bp bin, so the local lambda should be the average signal on 100-bp level. Then we can test signal against the local lambda with Poisson distribution and get the p-value of each 100-bp bin. Although the default behavior in MACS2 is testing at each basepair, our each position in a 100-bp bin will generate the same p-value and can be merged again. Therefore, this process still can be thought of as testing at each 100-bp bin.
## Step 6: Compare ChIP/ATAC signal and local lambda to get the scores in pvalue or qvalue
The ChIP-seq/ATAC-seq signal at each genomic location stored in BedGraph will be tested against the local lambda with Poisson distribution. The score in the output file is -log10(p-value) or -log10(q-value) (depending on `-m ppois` or `-m qpois`) for each location.
|chr|start|end|score|
|--|--|--|--|
|chr7|0|9999|0.10360|
|chr7|9999|10099|7.01453|
|chr7|10099|10199|2.28348|

**In our case**, `callpeak` used by author set `-p 0.01`, so we set `-m ppois` in `bdgcmp` and `-c 2` in `bdgpeakcall`.

**macs2 bdgcmp command:**
```bash
macs2 bdgcmp -t ./ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg -c ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.lambda.bg -m ppois -o ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.pvalue.bg
```
## Step 7: Call peaks on score track using a cutoff
It is the final task of peak calling. We need to set three arguments in this step:
`-c CUTOFF, --cutoff`
`-l MINLEN, --min-length`
`-g MAXGAP, --max-gap`
Positions with scores higher than certain cutoff (set by `-c`) will be kept. If two nearby regions are both above cutoff but the region in-between is lower, and if the region in-between is small enough (set by `-g`), we will merge the two nearby regions together into a bigger one. `-g` is set as the read length since the read length represents the resolution of the dataset. Finally, only peaks larger than a minimum length (set by `-l`) will be reported. `-l` is set as the fragment size _d_ by default. 

**In our case**, we set 
`-c 2`: The scores in the output from _bdgcmp_ are in -log10 form and we want to select positions with p-value lower than 0.01 (-log10(0.01) = 2).
`-g 75`: The read length is 75 bp.
`-l 501`: The author extended peak summits by 250 bp on either side to a final width of 501 bp.

The **score** in the output bed file is `int(-10*log10pvalue) at peak summit`

**macs2 bdgpeakcall command:**
```bash
macs2 bdgpeakcall -i ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.pvalue.bg -c 2 -l 501 -g 75 -o ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.peaks001.bed
```
# Test
## test on paper data
**Test file:** `ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg`

Write **a script** `peakRecall.py` to recall peaks including these three steps above.
```bash
./peakRecall.py ./ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.bg
```
**number of peaks** we get: 52519
```bash
 wc -l ACCx_025FE5F8_885E_433D_9018_7AE322A92285_X034_S09_L133_B1_T1_PMRG.insertions.peaks001.bed # 52519
```
**Plot genome-wide signal from BigWig file and peaks recalled to compare**

Region: chr1
![enter image description here](https://github.com/Luming-L/Project/blob/master/Result/PeakRecall/peakRecall_chr1.png?raw=true)
Region: chr1: 777499-1233399
![enter image description here](https://github.com/Luming-L/Project/blob/master/Result/PeakRecall/peakRecall_chr1_777499_1233399.png?raw=true)
## test on MACS2 testing file
```bash
# use main function `callpeak` to call peak
macs2 callpeak -t ../CTCF_ChIP_200K.bed.gz -c ../CTCF_Control_200K.bed.gz -f BED -g hs -n test -B
wc -l ../test_callpeak/test_peaks.narrowPeak #13294
# use the script ./peakRecall_test_CTCF.py
./peakRecall_test_CTCF.py CTCF_ChIP_200K_filterdup.pileup.bdg
wc -l CTCF_ChIP_200K_filterdup.pileup.peaks.bed #16813 
# check the number of overlapping peaks
bedtools intersect -wa -wb -a ../test_callpeak/test_peaks.narrowPeak -b ./CTCF_ChIP_200K_filterdup.pileup.peaks.bed -sorted -filenames -f 1.0 | wc -l # 13294
bedtools intersect -wa -wb -a ./CTCF_ChIP_200K_filterdup.pileup.peaks.bed -b ../test_callpeak/test_peaks.narrowPeak -sorted -filenames -f 1.0 | wc -l # 12284
```
# Reference
[Advanced:-Call-peaks-using-MACS2-subcommands](https://github.com/macs3-project/MACS/wiki/Advanced:-Call-peaks-using-MACS2-subcommands)

[MACS#macs-model-based-analysis-for-chip-seq](https://github.com/macs3-project/MACS#macs-model-based-analysis-for-chip-seq)

[Identifying ChIP-seq enrichment using MACS](https://www.nature.com/articles/nprot.2012.101)

[issues/379: The 5th column score = 10 * score in the summit from bedGraph.](https://github.com/macs3-project/MACS/issues/379)

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE3MjIyMTY0MzNdfQ==
-->