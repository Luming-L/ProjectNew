recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. PRDM9 motif occurrences may overlap each other.

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks |wc -l

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE1OTczNjc3MzQsMTMxMTA5NDI4MSwtMj
AxMzQ2MjcxOCwtMjEzOTc2Mjg0Nyw3MzA5OTgxMTZdfQ==
-->