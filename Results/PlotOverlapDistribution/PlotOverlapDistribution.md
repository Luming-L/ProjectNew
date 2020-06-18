recombination hotspots
# 
`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, so we should use `-u` here.

`-F`: Minimum overlap required as a fraction of B. Default is 1E-9 (i.e., 1bp).

bedtools intersect -a testis.peaks -b PRDM9_bound_peaks  -u -F 1.0 | wc -l 
# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

<!--stackedit_data:
eyJoaXN0b3J5IjpbNzU4MzQ0MTU0LC0zNzE1NTkyMjUsLTkyOD
Q3NzEsNDc1NTM2ODIzLC0xNDk5MTA3NjYzLC0xMTU4MjQ2MDk1
LC0xMDg3NTU0OTcxLC0xNTk3MzY3NzM0LDEzMTEwOTQyODEsLT
IwMTM0NjI3MTgsLTIxMzk3NjI4NDcsNzMwOTk4MTE2XX0=
-->