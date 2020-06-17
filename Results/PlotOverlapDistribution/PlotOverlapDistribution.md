recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, so we should use `-u` here.

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks | wc -l 

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbNDc1NTM2ODIzLC0xNDk5MTA3NjYzLC0xMT
U4MjQ2MDk1LC0xMDg3NTU0OTcxLC0xNTk3MzY3NzM0LDEzMTEw
OTQyODEsLTIwMTM0NjI3MTgsLTIxMzk3NjI4NDcsNzMwOTk4MT
E2XX0=
-->