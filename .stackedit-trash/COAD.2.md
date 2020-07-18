COAD Colon Adenocarcinoma
Number of Tissue Samples Passed QC: 41 (in 410 samples)
Number of Donors Passed QC: 38 (in 404 dornors)
```bash
cut -f 4 COAD* > COAD_Peaks_list.txt
sort COAD_Peaks_list.txt | uniq -c | awk '{if($1>1){print $0}}' | wc -l # 112436
wc -l COAD_peakCalls.txt # 122972
```
sample mapping
```bash
awk '{FS=OFS="\t";if($1~/^COAD/){print $1, substr($5,1,16)}}' ../TCGA_identifier_mapping > COAD_ID.txt
cut -f 2 COAD_ID.txt | sort | uniq | wc -l # 38
```
# PRDM9 expression
## ID of COAD samples
# PRDM9 binding
# somatic mutations
# structural variants


<!--stackedit_data:
eyJoaXN0b3J5IjpbMjczMjU0MjgxXX0=
-->