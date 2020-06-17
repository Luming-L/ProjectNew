recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, so we should use `-u` here.

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks | wc -l 

> Written with [StackEdit](https://stackedit.io/). 
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTkyODQ3NzEsNDc1NTM2ODIzLC0xNDk5MT
A3NjYzLC0xMTU4MjQ2MDk1LC0xMDg3NTU0OTcxLC0xNTk3MzY3
NzM0LDEzMTEwOTQyODEsLTIwMTM0NjI3MTgsLTIxMzk3NjI4ND
csNzMwOTk4MTE2XX0=
-->