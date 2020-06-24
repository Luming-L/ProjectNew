
**Evaluate the association between PRDM9 binding regions and mutational regions in cancer:** Permutation tests through regioneR package will be performed to assess the overlap between the PRDM9 binding regions and mutations (SNPs, indels and structural variant breakpoints) (Gel _et al._, 2016). In each of the 404 samples, the PRDM9 binding regions will be tested with SNPs plus indels and structural variant breakpoints, respectively. The permutation test includes two steps: randomize the regions and evaluate the association. The randomization function circularRandomizeRegions will be selected for circular permutation and the evaluation function numOverlaps will assess the number of overlaps by p-value. There is a backup plan for structural variants: if the structural variants are low in number, we will use merged pan-cancer PRDM9 binding regions and merged pan-cancer structural variants to do permutation test.

mutations (SNPs, indels and structural variant breakpoints)



# input files
somatic mutation (SNPs and small INDELs)
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
# rename files
RegioneR package
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTU0OTc1MDI1OSwtNDIwNjI1NjY1LDIwND
Q0NzEyNjIsLTg0MzQzNDQ1LDEyODAyMDQ2MzksMTM5MjI4Mjc3
Niw3NDEzMTk0NTIsMTM2NjU1NDk3OSwtMjEwODAwNDkwMCwxOD
QwNjk0MjM5LDExNzgwNDg4NTQsNzMwOTk4MTE2XX0=
-->