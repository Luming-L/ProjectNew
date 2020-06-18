
# 
`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, so we should use `-u` here.

`-F`: Minimum overlap required as a fraction of B. Default is 1E-9 (i.e., 1bp).
echo -e "sampleName\toverlapNumber\ttotalHotspots" > hotspotsOverlap.txt
```bash
# find the DSB hotspots that any PRDM9 motif falls into by `bedtools intersect`
bedtools intersect -a /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt -b $file -u -F 1.0 > "${fileName}.hotspots.bed"
```
The regions of PRDM motif that has been observed in cancer open chromatin regions overlap with how many hotspots
```bash
# count hotspots that overlap PRDM9 motif
overlapNumber=`wc -l "${fileName}.hotspots.bed" | awk '{print $1}'`
# total hotspots number
totalHotspots=`wc -l /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt | awk '{print $1}'`
# output the sample name and counts
echo -e "${fileName}\t${overlapNumber}\t${totalHotspots}" >> hotspotsOverlap.txt
```
# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTY4MDAxOTI4MCwyMTI4ODY0NjEsNzU4Mz
Q0MTU0LC0zNzE1NTkyMjUsLTkyODQ3NzEsNDc1NTM2ODIzLC0x
NDk5MTA3NjYzLC0xMTU4MjQ2MDk1LC0xMDg3NTU0OTcxLC0xNT
k3MzY3NzM0LDEzMTEwOTQyODEsLTIwMTM0NjI3MTgsLTIxMzk3
NjI4NDcsNzMwOTk4MTE2XX0=
-->