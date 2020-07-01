# Association between PRDM9 expression and recurrently mutated regions
Somatic mutations may affect PRDM9 expression. The mutations in which gene may affect the expression of PRDM9. We need regions where SNVs cluster across all samples, because they are comparable.
## input
PRDM9 expression level
Reccuently mutated regions: First we select regions where at least 2 SNVs were located with 100bp from each other across all tumor samples. Then we concentrate on regions that have at least one mutation in 5% samples.
## process
linear regression: for each region we study, the mutation on it is associated with PRDM9 expression.
## output
a p-value for each region tested. We found 49% 
# PRDM9 binding motif analysis
# Odds rations calculations

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyMzY0OTIxMzgsLTU0MDkwNjc1MiwtMj
E0Mzc2OTg5LC0xMTMxMjM4NTI1LDIxMjE4NzEwMjMsODk3MDE5
NTU2LC0xNDQxMzc4MTAzXX0=
-->