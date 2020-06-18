
# 
`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, so we should use `-u` here.

`-F`: Minimum overlap required as a fraction of B. Default is 1E-9 (i.e., 1bp).
echo -e "sampleName\toverlapNumber\ttotalHotspots" > hotspotsOverlap.txt
```bash
# find the DSB hotspots that any PRDM9 motif falls into by `bedtools intersect`
bedtools intersect -a /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt -b $file -u -F 1.0 > "${fileName}.hotspots.bed"
```

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
eyJoaXN0b3J5IjpbMjEyODg2NDYxLDc1ODM0NDE1NCwtMzcxNT
U5MjI1LC05Mjg0NzcxLDQ3NTUzNjgyMywtMTQ5OTEwNzY2Mywt
MTE1ODI0NjA5NSwtMTA4NzU1NDk3MSwtMTU5NzM2NzczNCwxMz
ExMDk0MjgxLC0yMDEzNDYyNzE4LC0yMTM5NzYyODQ3LDczMDk5
ODExNl19
-->