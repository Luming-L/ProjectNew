For SNPs and InDels, we should try and do it on a per-sample level. And yes, some clustering analysis could be useful to see if there are any "common" peaks that are not seen in testis or if PRDM9 binding is "all over the place", with little consistency between the samples.

So, as explained above, we will use the regioneR package to see if there is more overlap than expected by chance. The mutation data come from the same publication/website as the ATAC-Seq peaks (scroll down to see “somatic mutation (SNPs and small INDELs)”)
https://xenabrowser.net/datapages/?cohort=GDC%20Pan-Cancer%20(PANCAN)&removeHub=https%3A%2F%2Fxena.treehouse.gi.ucsc.edu%3A443
The mutations come as a text file, listing the position where they occur, the sample ID and a few other things, like this table here shows:
https://xenabrowser.net/datapages/?dataset=GDC-PANCAN.muse_snv.tsv&host=https%3A%2F%2Fgdc.xenahubs.net&removeHub=https%3A%2F%2Fxena.treehouse.gi.ucsc.edu%3A443
 
You can then just extract columns 4,5&6 to make this into a bed file. This bed file will then be used as input into the regioneR package and compared to another bed file, which contains the PRDM9 binding sites. In theory, this can be done pan-cancer or for each individual separately. 
<!--stackedit_data:
eyJoaXN0b3J5IjpbNjQ1MDEzMTgwLDQyNjg5ODM2Ml19
-->