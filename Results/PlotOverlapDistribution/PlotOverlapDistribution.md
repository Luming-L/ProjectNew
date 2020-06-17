recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots.

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks |wc -l

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwODc1NTQ5NzEsLTE1OTczNjc3MzQsMT
MxMTA5NDI4MSwtMjAxMzQ2MjcxOCwtMjEzOTc2Mjg0Nyw3MzA5
OTgxMTZdfQ==
-->