In each of 404 samples, do somatic mutations overlap with PRDM9-bound ATAC-seq peaks more than expected?
test if A overlaps with B more than expected

We can see a visual representation of the results of the test. In grey the number of overlaps of the randomized regions with B, clustering around the black bar that represents the mean and in green the number of overlaps of the original region set A, which is much larger than expected. The red line denotes the significance limit.

evaluates the number of overlaps between two sets of regions.

**Evaluate the association between PRDM9 binding regions and mutational regions in cancer:** Permutation tests through regioneR package will be performed to assess the overlap between the PRDM9 binding regions and mutations (SNPs, indels and structural variant breakpoints) (Gel _et al._, 2016). In each of the 404 samples, the PRDM9 binding regions will be tested with SNPs plus indels and structural variant breakpoints, respectively. The permutation test includes two steps: randomize the regions and evaluate the association. The randomization function circularRandomizeRegions will be selected for circular permutation and the evaluation function numOverlaps will assess the number of overlaps by p-value. There is a backup plan for structural variants: if the structural variants are low in number, we will use merged pan-cancer PRDM9 binding regions and merged pan-cancer structural variants to do permutation test.

mutations (SNPs, indels and structural variant breakpoints)



# input files
## somatic mutation (SNPs and small INDELs)
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
## PRDM9-bound peaks in 404 samples
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
# evaluates the number of overlaps between two sets of regions.
# Reference
[https://bioconductor.org/packages/3.11/bioc/vignettes/regioneR/inst/doc/regioneR.html](https://bioconductor.org/packages/3.11/bioc/vignettes/regioneR/inst/doc/regioneR.html)
[https://bernatgel.github.io/karyoploter_tutorial/Tutorial/PlotRegions/PlotRegions.html](https://bernatgel.github.io/karyoploter_tutorial/Tutorial/PlotRegions/PlotRegions.html)

<!--stackedit_data:
eyJoaXN0b3J5IjpbMjAxNTY4NDg4N119
-->