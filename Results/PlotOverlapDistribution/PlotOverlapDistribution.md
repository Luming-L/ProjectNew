recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, so we should use `-u` here.

`-F`: Minimum overlap required as a fraction of B. Default is 1E-9 (i.e., 1bp).

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks | wc -l 

[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

> Written with [StackEdit](https://stackedit.io/). 
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwNzMxMDY4NywtOTI4NDc3MSw0NzU1Mz
Y4MjMsLTE0OTkxMDc2NjMsLTExNTgyNDYwOTUsLTEwODc1NTQ5
NzEsLTE1OTczNjc3MzQsMTMxMTA5NDI4MSwtMjAxMzQ2MjcxOC
wtMjEzOTc2Mjg0Nyw3MzA5OTgxMTZdfQ==
-->