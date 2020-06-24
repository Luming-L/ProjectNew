
**Evaluate the association between PRDM9 binding regions and mutational regions in cancer:** Permutation tests through regioneR package will be performed to assess the overlap between the PRDM9 binding regions and mutations (SNPs, indels and structural variant breakpoints) (Gel _et al._, 2016). In each of the 404 samples, the PRDM9 binding regions will be tested with SNPs plus indels and structural variant breakpoints, respectively. The permutation test includes two steps: randomize the regions and evaluate the association. The randomization function circularRandomizeRegions will be selected for circular permutation and the evaluation function numOverlaps will assess the number of overlaps by p-value. There is a backup plan for structural variants: if the structural variants are low in number, we will use merged pan-cancer PRDM9 binding regions and merged pan-cancer structural variants to do permutation test.

mutations (SNPs, indels and structural variant breakpoints)



# input files
**somatic mutation (SNPs and small INDELs)**
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
**PRDM9-bound peaks in 410 samples**
rename files
before renaming
<cancerType>_<stanfordUUID>_<batch>_<sample#>_<libraryID>_<bioRep>_<techRep>_<pool#>
For example - TGCT_1577A485_E047_42CF_8703_42A69E1AED1A_X038_S09_L090_B1_T2_PMRG
<cancerType> - TGCT (**note - some cancer types like "LGG" have an extra "x" appended ie "LGGx" to maintain equal 4 character length of this string)
<stanfordUUID> - 1577A485-E047-42CF-8703-42A69E1AED1A - This corresponds to a unique 36-character ID given to each tissue fragment. This is not the same as the 36-character TCGA sample_id/case_id. Hyphens were replaced by underscores.

# rename files
RegioneR package
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTQ3NDI0NDgzNiwxNTQ5NzUwMjU5LC00Mj
A2MjU2NjUsMjA0NDQ3MTI2MiwtODQzNDM0NDUsMTI4MDIwNDYz
OSwxMzkyMjgyNzc2LDc0MTMxOTQ1MiwxMzY2NTU0OTc5LC0yMT
A4MDA0OTAwLDE4NDA2OTQyMzksMTE3ODA0ODg1NCw3MzA5OTgx
MTZdfQ==
-->