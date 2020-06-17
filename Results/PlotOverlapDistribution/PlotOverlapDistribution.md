recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, 

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks |wc -l

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbNDYxOTI0Mjc1LC0xMDg3NTU0OTcxLC0xNT
k3MzY3NzM0LDEzMTEwOTQyODEsLTIwMTM0NjI3MTgsLTIxMzk3
NjI4NDcsNzMwOTk4MTE2XX0=
-->