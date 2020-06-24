
**Evaluate the association between PRDM9 binding regions and mutational regions in cancer:** Permutation tests through regioneR package will be performed to assess the overlap between the PRDM9 binding regions and mutations (SNPs, indels and structural variant breakpoints) (Gel _et al._, 2016). In each of the 404 samples, the PRDM9 binding regions will be tested with SNPs plus indels and structural variant breakpoints, respectively. The permutation test includes two steps: randomize the regions and evaluate the association. The randomization function circularRandomizeRegions will be selected for circular permutation and the evaluation function numOverlaps will assess the number of overlaps by p-value. There is a backup plan for structural variants: if the structural variants are low in number, we will use merged pan-cancer PRDM9 binding regions and merged pan-cancer structural variants to do permutation test.

mutations (SNPs, indels and structural variant breakpoints)



# input files
somatic mutation (SNPs and small INDELs)
RegioneR package
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTM2NjU1NDk3OSwtMjEwODAwNDkwMCwxOD
QwNjk0MjM5LDExNzgwNDg4NTQsNzMwOTk4MTE2XX0=
-->