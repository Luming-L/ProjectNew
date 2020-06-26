Question: In each of 404 samples, do PRDM9-bound ATAC-seq peaks contain more somatic mutations than expected by chance?
# Brief Problem Description:
The binding of PRDM9 will introduce genetic variants in meiotic recombination. PRDM9 normally just has expression in testis, but it is also found to express in cancer cells. However, how does PRDM9 work in cancer cells? Is there a statistically significant association between PRDM9 binding regions and somatic mutations in cancer cells?
# Datasets: two region sets
## Set A: PRDM9-bound peaks in 404 samples
410 before renaming and 404 after
### rename files
**before renaming**

*<cancerType#>_<stanfordUUID#>_<batch#>_<sample#>_<libraryID#>_<bioRep#>_<techRep#><pool#>*

For example - TGCT_1577A485_E047_42CF_8703_42A69E1AED1A_X038_S09_L090_B1_T2_PMRG

- <cancerType#> - TGCT (**note - some cancer types like "LGG" have an extra "x" appended ie "LGGx" to maintain equal 4 character length of this string)

- <stanfordUUID#> - 1577A485-E047-42CF-8703-42A69E1AED1A - This corresponds to a unique 36-character ID given to each tissue fragment. This is not the same as the 36-character TCGA sample_id/case_id. Hyphens were replaced by underscores.

- <batch#> - X038 == batch 038 - samples were, almost universally, processed in batches of 12. This number denotes in which batch the tissue was processed.

- <sample#> - S09 == sample 09 - within a batch, samples were processed consistently in the same order throughout processing. In this case, S09 means that this particular sample was processed 9th within the batch.

- <libraryID#> - L090 == library 090 - this number does not have inherent meaning and was used to track samples throughout processing.

- <bioRep#> - B1 == bioRep #1 (everything is B1, as we defined a bio rep as an individual piece of tissue)

- <techRep#> - T2 == techRep #2 - Tumor tissue was homogenized prior to ATAC-seq into a nuclei suspension. Each technical replicate represents an individual ATAC-seq reaction performed in a separate tube on different nuclei isolated from the same sample.

- <pool#> - PMRG == Pool "merged" - This represents the pool in which this particular technical replicate was sequenced. If this is "PMRG" that means that multiple sequencing runs were performed on this technical replicate and then merged to acheive sufficient depth.

**after renaming**

Case_ID: TCGA-XE-AANI-01A

## SetB: somatic mutation (SNPs and small INDELs)
### download and check files
```bash
wget https://gdc.xenahubs.net/download/GDC-PANCAN.muse_snv.tsv.gz
gzip -d GDC-PANCAN.muse_snv.tsv.gz 
wc -l GDC-PANCAN.muse_snv.tsv # 2684789
awk '{if($4 == $5){print $0}}' GDC-PANCAN.muse_snv.tsv | wc -l # 2684788
awk '{if($4 != $5){print $0}}' GDC-PANCAN.muse_snv.tsv | wc -l # 1

wget https://gdc.xenahubs.net/download/GDC-PANCAN.mutect2_snv.tsv.gz
gzip -d GDC-PANCAN.mutect2_snv.tsv.gz
wc -l GDC-PANCAN.mutect2_snv.tsv # 3175930
awk '{if($4 == $5){print $0}}' GDC-PANCAN.mutect2_snv.tsv | wc -l # 3068128
awk '{if($4 != $5){print $0}}' GDC-PANCAN.mutect2_snv.tsv | wc -l # 107802

wget https://gdc.xenahubs.net/download/GDC-PANCAN.somaticsniper_snv.tsv.gz
gzip -d GDC-PANCAN.somaticsniper_snv.tsv.gz
wc -l GDC-PANCAN.somaticsniper_snv.tsv # 2202278
awk '{if($4 == $5){print $0}}' GDC-PANCAN.somaticsniper_snv.tsv | wc -l # 2202277
awk '{if($4 != $5){print $0}}' GDC-PANCAN.somaticsniper_snv.tsv | wc -l # 1

wget https://gdc.xenahubs.net/download/GDC-PANCAN.varscan2_snv.tsv.gz
gzip -d GDC-PANCAN.varscan2_snv.tsv.gz
wc -l GDC-PANCAN.varscan2_snv.tsv # 2854562 
awk '{if($4 == $5){print $0}}' GDC-PANCAN.varscan2_snv.tsv | wc -l # 2776104
awk '{if($4 != $5){print $0}}' GDC-PANCAN.varscan2_snv.tsv | wc -l # 78458
```
### choose the most appropriate dataset 
> There is currently no scientific consensus on the best variant calling pipeline so the investigator is responsible for choosing the pipeline(s) most appropriate for the data. 

**check the overlap between different datasets**
```bash
for file in $(ls ./*_snv.tsv); do sort -k3,3 -k4,4n $file | awk '{FS=OFS="\t"}}' > ./${file}.sorted; done
bedtools intersect -a GDC-PANCAN.muse_snv.tsv.sorted -b GDC-PANCAN.mutect2_snv.tsv.sorted -v | wc -l # 157126
bedtools intersect -a GDC-PANCAN.muse_snv.tsv.sorted -b GDC-PANCAN.somaticsniper_snv.tsv.sorted -v | wc -l # 453661
bedtools intersect -a GDC-PANCAN.muse_snv.tsv.sorted -b GDC-PANCAN.varscan2_snv.tsv.sorted -v | wc -l # 191575

bedtools intersect -a GDC-PANCAN.somaticsniper_snv.tsv.sorted -b GDC-PANCAN.muse_snv.tsv.sorted -v | wc -l # 72598
bedtools intersect -a GDC-PANCAN.somaticsniper_snv.tsv.sorted -b GDC-PANCAN.mutect2_snv.tsv.sorted -v | wc -l # 116359
bedtools intersect -a GDC-PANCAN.somaticsniper_snv.tsv.sorted -b GDC-PANCAN.varscan2_snv.tsv.sorted -v | wc -l # 28011

bedtools intersect -a GDC-PANCAN.varscan2_snv.tsv.sorted -b GDC-PANCAN.muse_snv.tsv.sorted -v | wc -l # 316740
bedtools intersect -a GDC-PANCAN.varscan2_snv.tsv.sorted -b GDC-PANCAN.mutect2_snv.tsv.sorted -v | wc -l # 173890
bedtools intersect -a GDC-PANCAN.varscan2_snv.tsv.sorted -b GDC-PANCAN.somaticsniper_snv.tsv.sorted -v | wc -l # 528596
```
`GDC-PANCAN.mutect2_snv.tsv` has most mutations and relatively larger overlap with other datasets.

**check pipeline**

We have somatic mutations called by 4 separate pipelines: MuSE, MuTect2, SomaticSniper and VarScan2.

> The `MuTect2` pipeline employs a "Panel of Normals" to identify additional germline mutations. This panel is generated using TCGA blood normal genomes from thousands of individuals that were curated and confidently assessed to be cancer-free. This method allows for a higher level of confidence to be assigned to somatic variants that were called by the `MuTect2` pipeline.

**Therefore, we choose the dataset generated by `MuTect2` pipeline.**
### save snv files as RDS format
```r
# mutect2_snv
mutect2_snv <- read.delim("/exports/eddie/scratch/s1949868/SNPsAndSmallINDELs/GDC-PANCAN.mutect2_snv.tsv",header = TRUE,sep = "\t")
mutect2_snv$Sample_ID=as.character(mutect2_snv$Sample_ID)
mutect2_snv$chrom=as.character(mutect2_snv$chrom)
saveRDS(object = mutect2_snv, file = "mutect2_snv.rds")
```
### choose samples with more mutations
```r
# count somatic mutations of a sample
num <- nrow(mutect2_snv[mutect2_snv$Sample_ID==ID,])
```
```bash
# sort samples by mutation number
grep -v "sampleID" MutNumber.txt | sort -k3,3nr > MutNumber.txt.sorted
head MutNumber.txt.sorted
```
	TCGA-AP-A051-01A        UCEC    12041
	TCGA-AA-A010-01A        COAD    10239
	TCGA-D9-A6EC-06A        SKCM    5641
	TCGA-D3-A8GM-06A        SKCM    5137
	TCGA-F7-A624-01A        HNSC    4050
	TCGA-NH-A5IV-01A        COAD    3753
	TCGA-AD-6889-01A        COAD    2685
	TCGA-AA-A01R-01A        COAD    2522
	TCGA-BR-A4QL-01A        STAD    2390
	TCGA-AA-A022-01A        COAD    2276
# Permutation test
The idea of the test is to randomly move PRDM9-bound peaks along the genome and count how many of them overlap with at least one mutation.

We can see a visual representation of the results of the test. In grey the number of overlaps of the randomized regions with B, clustering around the black bar that represents the mean and in green the number of overlaps of the original region set A, which is much larger than expected. The red line denotes the significance limit.

evaluation function (which type of association to be tested)
randomization function (how to randomize regions in a set)
test (performing the permutation tests and producing the statistical evaluation of the results.)

In addition, we can test if the association between the two region sets is highly dependant on their exact position. To do that, we can use the `localZScore` function.？
**Evaluate the association between PRDM9 binding regions and mutational regions in cancer:** Permutation tests through regioneR package will be performed to assess the overlap between the PRDM9 binding regions and mutations (SNPs, indels and structural variant breakpoints) (Gel _et al._, 2016). In each of the 404 samples, the PRDM9 binding regions will be tested with SNPs plus indels and structural variant breakpoints, respectively. The permutation test includes two steps: randomize the regions and evaluate the association. The randomization function circularRandomizeRegions will be selected for circular permutation and the evaluation function numOverlaps will assess the number of overlaps by p-value. There is a backup plan for structural variants: if the structural variants are low in number, we will use merged pan-cancer PRDM9 binding regions and merged pan-cancer structural variants to do permutation test.

mutations (SNPs, indels and structural variant breakpoints)





# Randomization strategy 
maintains the order and distance of the regions, while changing their position in the chromosome.



evaluating the original RS, creating a number of randomizations and evaluating them and nally computing the p-value and z-score.
`ntimes` to specify the number of randomizations, `verbose` to toggle the drawing of a progress bar, `force.parallel` to force or forbid the use of multiple cores to run the analysis…- and it also accepts any additional parameter required by the randomization function (usually a genome and a mask) or the evaluation function.
creates a new set of regions that is random with respect to our evaluation function but takes into account the specificities of our original region set.
For example, if our original RS comes from an NGS experiment, all of its regions would lie in mappable parts of the genome and wouldn’t make any sense to randomize a region into a centromere or any other non-mappable part of the genome. To help with that, many randomization functions provided by regioneR accept a mask, indicating where a random region cannot be placed.
`randomizeRegions`: given a RS, a genome and an optional mask, returns a new RS with the same number of regions and of the same width as the original ones but randomly placed along the non-masked parts of the genome.
Actually, just counting the number of times the evaluation of the random RS is higher (or lower) than our original evaluation, we can compute the probability of seeing our original evaluation by chance, and that value is exactly the p-value of the permutation test. In addition, we compute the z-score which is the distance between the evaluation of the original RS and the mean of the random evaluations divided by the standard deviation of the random evaluations. The z-score, although not directly comparable, can help in assessing “the strength” of the evaluation.
# Evaluation function
`numOverlaps` function: given two RS, returns the number of overlaps between two sets
in our case we can compute the number of PRDM9-bound ATAC-seq peaks overlapping somatic mutations.
# Reference
[https://bioconductor.org/packages/3.11/bioc/vignettes/regioneR/inst/doc/regioneR.html](https://bioconductor.org/packages/3.11/bioc/vignettes/regioneR/inst/doc/regioneR.html)
[https://bernatgel.github.io/karyoploter_tutorial/Tutorial/PlotRegions/PlotRegions.html](https://bernatgel.github.io/karyoploter_tutorial/Tutorial/PlotRegions/PlotRegions.html)

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTgyMDA2OTgzMywtNjk3MTA4MDk3LDEzND
E1ODE1NjAsLTE2MzMxMzI0NCwtMzY1MDgxMzczLDE0MzQxMTYz
MTgsLTEzOTMwMzIwMTMsLTc3NjE2MzcyLDEwOTUzNzMwNTUsND
c5NDA2NDE3LC0xOTE0MDA3NTA3LDQ0MDQwNTQ4NSwtMTUxNzA5
MDA0NywtNzE3MTMzNzQ2LDE2MTg4Mjc3OSwtNTE2MTMyMjY4LD
E2NTAwOTEsMTMwMTA2OTEzMywtMTg2OTY5NDUzNiw4NTAyNDQ4
OTddfQ==
-->