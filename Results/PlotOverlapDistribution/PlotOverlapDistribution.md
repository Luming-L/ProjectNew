# 
Visualize the overlap between PRDM9 bound peaks in cancer cells and DSB hotspots in testes

A histogram will be plotted to visualize the distribution of overlap fraction between regions in each cancer sample and testes. The x axis of this histogram is 0 to 100% overlap, and the y axis is number of samples. 
Per cancer level analysis
For a specific type of cancer, whether the PRDM9 binding regions in peaks are overlapped with those in the breakpoints of testis. How much they overlap?


# count DSB hotspots that overlap any PRDM9 bound peaks
# calculate overlap fraction
overlap fraction = overlapping DSB hotspots counts/total DSB hotspots number*100
# plot the distribution of overlap fraction
Tx axis of this histogram is 0 to 100% overlap, and the y axis is number of samples. 

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
eyJoaXN0b3J5IjpbMTIwODg5MDE4MywtMTk5MDExNDk0OSwxNz
Q4NTIzNDU4LDkzNjkyNDcwMywxNDA0ODI3NjUsLTE0ODUxNDA5
MDUsLTExMjkxMjUyOTMsLTE0MzE4MzU2NzYsNTU1NzI1OTkxLD
MyNjgzMDQzMCw4NTMyNzg0MzEsLTE4NzE1MjMzMTcsLTIwMDgz
MTk5MSwxNzQ0NzAxNzEwLDExNTk0MzgyNDMsMjEyODg2NDYxLD
c1ODM0NDE1NCwtMzcxNTU5MjI1LC05Mjg0NzcxLDQ3NTUzNjgy
M119
-->