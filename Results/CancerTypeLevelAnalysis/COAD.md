COAD Colon Adenocarcinoma
Number of Tissue Samples Passed QC: 41 (in 410 samples)
```bash
cut -f 4 COAD* > COAD_Peaks_list.txt
sort COAD_Peaks_list.txt | uniq -c | awk '{if($1>1){print $0}}' | wc -l
```
# PRDM9 expression
## ID of COAD samples
# PRDM9 binding
# somatic mutations
# structural variants


<!--stackedit_data:
eyJoaXN0b3J5IjpbMTM5NDMxNzgxMSw1NzI3MTgzNDIsLTE0OD
cxNTUxMDMsLTEwNTUyODk4Ml19
-->