# Whether recurrently mutated regions are associated with PRDM9 expression in tumors
We want to know wether recurrently mutated regions where have mutations in all samples may affect PRDM9 expression.
Somatic mutations may affect PRDM9 expression. The mutations in which gene may affect the expression of PRDM9. We need regions where SNVs cluster across all samples, because they are comparable.
## input
PRDM9 expression level
Reccuently mutated regions: First we select regions where at least 2 SNVs were located with 100bp from each other across all tumor samples. Then we concentrate on regions that have at least one mutation in 5% samples.
## process
linear regression: for each region we study, the mutation on it is associated with PRDM9 expression.
## output
a p-value for each region tested. We found 49% regions are significantly related to PRDM9 expression
# PRDM9 binding motif analysis
# Odds rations calculations

<!--stackedit_data:
eyJoaXN0b3J5IjpbMzA4MTAwMjM4LC01NDA5MDY3NTIsLTIxND
M3Njk4OSwtMTEzMTIzODUyNSwyMTIxODcxMDIzLDg5NzAxOTU1
NiwtMTQ0MTM3ODEwM119
-->