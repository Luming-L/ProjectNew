recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences may overlap with the same DSPhotspots.

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks |wc -l

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTAxNzQ4ODc0LC0xNTk3MzY3NzM0LDEzMT
EwOTQyODEsLTIwMTM0NjI3MTgsLTIxMzk3NjI4NDcsNzMwOTk4
MTE2XX0=
-->