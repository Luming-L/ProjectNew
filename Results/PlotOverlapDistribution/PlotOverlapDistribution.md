# 
Visualize the overlap between PRDM9 bound peaks in cancer cells and DSB hotspots in testes: This step starts from the PRDM9 binding regions in 404 tumour samples and in testes. A histogram will be plotted to visualize the distribution of overlap fraction between regions in each cancer sample and testes. The x axis of this histogram is 0 to 100% overlap, and the y axis is number of samples. 
Per cancer level analysis
For a specific type of cancer, whether the PRDM9 binding regions in peaks are overlapped with those in the breakpoints of testis. How much they overlap?


# count DSB hotspots that overlap any PRDM9 bound peaks

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
Bedtools closest

how they generated the file

colocalization DSB hotspots with chromosome rearrangement breakpoints

Fig. 1. Genome-wide distribution of DSB hotspots in human individuals.

Fig. 2. PRDM9-defined hotspots are found in the human PARs.

Fig. 3. Comparison of LD-based recombinationmaps and DSB hotspots.

Fig. 4. Variation in hotspot strength between the AA1 and AA2 individuals.

Fig. 5. Signatures of increased genetic diversity at DSB hotspots.

Fig. 6. DSB frequency is correlated with the crossover rate.
# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[Recombination initiation maps of individual human genomes](https://science.sciencemag.org/content/346/6211/1256442)
<!--stackedit_data:
eyJoaXN0b3J5IjpbODkyNTE4Njc3LC0xNDg1MTQwOTA1LC0xMT
I5MTI1MjkzLC0xNDMxODM1Njc2LDU1NTcyNTk5MSwzMjY4MzA0
MzAsODUzMjc4NDMxLC0xODcxNTIzMzE3LC0yMDA4MzE5OTEsMT
c0NDcwMTcxMCwxMTU5NDM4MjQzLDIxMjg4NjQ2MSw3NTgzNDQx
NTQsLTM3MTU1OTIyNSwtOTI4NDc3MSw0NzU1MzY4MjMsLTE0OT
kxMDc2NjMsLTExNTgyNDYwOTUsLTEwODc1NTQ5NzEsLTE1OTcz
Njc3MzRdfQ==
-->