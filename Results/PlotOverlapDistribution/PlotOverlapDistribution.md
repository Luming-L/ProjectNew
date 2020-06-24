# 
Visualize the overlap between PRDM9 bound peaks in cancer cells and DSB hotspots in testes

A histogram will be plotted to visualize the distribution of overlap fraction between regions in each cancer sample and testes. The x axis of this histogram is 0 to 100% overlap, and the y axis is number of samples. 
Per cancer level analysis
For a specific type of cancer, whether the PRDM9 binding regions in peaks are overlapped with those in the breakpoints of testis. How much they overlap?


# count DSB hotspots that overlap any PRDM9 bound peaks
# calculate overlap fraction
# plot the distribution of overlap
overlapping DSB hotspots counts/total DSB hotspots number

## 410 samples
`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. 



```bash
echo -e "sampleName\toverlapNumber\ttotalHotspots" > hotspotsOverlap.txt
# find the DSB hotspots that overlap any PRDM9 bound peaks by `bedtools intersect`
bedtools intersect -a /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt -b $file -u > "${fileName}_PRDM9BoundPeaks_overlap_hotspots.bed"

# count hotspots that overlap PRDM9 motif
overlapNumber=`wc -l "${fileName}_PRDM9BoundPeaks_overlap_hotspots.bed" | awk '{print $1}'`

# total hotspots number
totalHotspots=`wc -l /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt | awk '{print $1}'`

# output the sample name and counts
echo -e "${fileName}\t${overlapNumber}\t${totalHotspots}" >> hotspotsOverlap.txt
```
## 23 cancer types

# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[Recombination initiation maps of individual human genomes](https://science.sciencemag.org/content/346/6211/1256442)
<!--stackedit_data:
eyJoaXN0b3J5IjpbOTM2OTI0NzAzLDE0MDQ4Mjc2NSwtMTQ4NT
E0MDkwNSwtMTEyOTEyNTI5MywtMTQzMTgzNTY3Niw1NTU3MjU5
OTEsMzI2ODMwNDMwLDg1MzI3ODQzMSwtMTg3MTUyMzMxNywtMj
AwODMxOTkxLDE3NDQ3MDE3MTAsMTE1OTQzODI0MywyMTI4ODY0
NjEsNzU4MzQ0MTU0LC0zNzE1NTkyMjUsLTkyODQ3NzEsNDc1NT
M2ODIzLC0xNDk5MTA3NjYzLC0xMTU4MjQ2MDk1LC0xMDg3NTU0
OTcxXX0=
-->