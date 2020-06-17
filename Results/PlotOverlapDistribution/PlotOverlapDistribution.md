recombination hotspots

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. 

bedtools intersect -u -a testis.peaks -b PRDM9_bound_peaks |wc -l

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbNTAwMzc2MjQ0LC0yMDEzNDYyNzE4LC0yMT
M5NzYyODQ3LDczMDk5ODExNl19
-->