# 
Visualize the overlap between PRDM9 bound peaks in cancer cells and DSB hotspots in testes


For a specific type of cancer, whether the PRDM9 binding regions in peaks are overlapped with those in the breakpoints of testis. How much they overlap?


# count DSB hotspots that overlap any PRDM9 bound peaks
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
# calculate overlap fraction
overlap fraction = overlapping DSB hotspots counts/total DSB hotspots number*100
```r
overlapPercentage_c=hotspotsOverlap_23c$overlapNumber/hotspotsOverlap_23c$totalHotspots*100
```
# plot the distribution of overlap fraction
x axis: overlap fraction (0 - 100%)
y axis: number of samples. 
## 410 samples
## 23 cancer types

# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[Recombination initiation maps of individual human genomes](https://science.sciencemag.org/content/346/6211/1256442)
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjA2NjExNjM4LDIxMjQzMDE3NCw2NjY2Nz
A1NCwtMTk5MDExNDk0OSwxNzQ4NTIzNDU4LDkzNjkyNDcwMywx
NDA0ODI3NjUsLTE0ODUxNDA5MDUsLTExMjkxMjUyOTMsLTE0Mz
E4MzU2NzYsNTU1NzI1OTkxLDMyNjgzMDQzMCw4NTMyNzg0MzEs
LTE4NzE1MjMzMTcsLTIwMDgzMTk5MSwxNzQ0NzAxNzEwLDExNT
k0MzgyNDMsMjEyODg2NDYxLDc1ODM0NDE1NCwtMzcxNTU5MjI1
XX0=
-->