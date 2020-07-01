# Whether recurrently mutated regions are associated with PRDM9 expression in tumors
We want to know wether recurrently mutated regions where have mutations in all samples are associated with  PRDM9 expression. If there is a association, genes in this regions may affect PRDM9 expression.
## input
PRDM9 expression level
Reccuently mutated regions: First we select regions where at least 2 SNVs were located with 100bp from each other across all tumor samples. Then we concentrate on a subset of regions that have at least one mutation existing in 5% samples. 
## process
linear regression: maybe for each region, use the number of mutations in it to quantify.
## output
obtain a p-value for each region. We found 49% regions are significantly related to PRDM9 expression. 
# PRDM9 binding motif analysis
# Odds rations calculations

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEzNDY1MzkxMiwtNzIzMDg5ODAyLDE5MT
Y5Njc4MTMsLTU0MDkwNjc1MiwtMjE0Mzc2OTg5LC0xMTMxMjM4
NTI1LDIxMjE4NzEwMjMsODk3MDE5NTU2LC0xNDQxMzc4MTAzXX
0=
-->