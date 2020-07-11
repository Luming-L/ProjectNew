## download files
```bash
# Cancer_Type-specific_Count_Matrices_log2norm_counts
wget https://api.gdc.cancer.gov/data/38b8f311-f3a4-4746-9829-b8e3edb9c157
```
> Constructing a counts matrix and normalization:
To obtain the number of independent Tn5 insertions in each peak, first the BAM files were corrected for the Tn5 offset (“+” stranded +4 bp, “-” stranded -5 bp) (16) into a Genomic Ranges object in R using Rsamtools “scanbam”. To get the number of Tn5 insertions per peak, each corrected insertion site (end of a fragment) was counted using “countOverlaps”. This was done for all individual technical replicates and a 562,709 x 796 counts matrix was compiled. From this, a RangedSummarizedExperiment was constructed including peaks as GenomicRanges, a counts matrix, and metadata detailing information for each sample. The counts matrix was then normalized by using edgeR’s “cpm(matrix , log = TRUE, prior.count = 5)” followed by a quantile normalization using preprocessCore’s “normalize.quantiles” in R.

> Each file contains 5 metadata columns and then one column for each technical replicate of that cancer type. Each row represents a unique fixed-width peak. 
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwMzI4MTM5OF19
-->