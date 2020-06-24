# count DSB hotspots that overlap any PRDM9 bound peaks

# plot the distribution of overlap ()


## 410 samples
`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. Restricted by -f and -r. Different PRDM9 motif occurrences (13bp) may overlap with the same DSBhotspots, so we should use `-u` here.

`-F`: Minimum overlap required as a fraction of B. Default is 1E-9 (i.e., 1bp).
echo -e "sampleName\toverlapNumber\ttotalHotspots" > hotspotsOverlap.txt
```bash
# find the DSB hotspots that any PRDM9 motif falls into by `bedtools intersect`
bedtools intersect -a /exports/eddie/scratch/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt -b $file -u -F 1.0 > "${fileName}.hotspots.bed"
```
For a cancer sample, regions of PRDM motifs that have been observed in ATAC-seq peaks overlap with how many hotspots testis.
```bash
# count hotspots that overlap PRDM9 motif
overlapNumber=`wc -l "${fileName}.hotspots.bed" | awk '{print $1}'`
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
eyJoaXN0b3J5IjpbLTE3OTkyMDkzMDQsLTE0MzE4MzU2NzYsNT
U1NzI1OTkxLDMyNjgzMDQzMCw4NTMyNzg0MzEsLTE4NzE1MjMz
MTcsLTIwMDgzMTk5MSwxNzQ0NzAxNzEwLDExNTk0MzgyNDMsMj
EyODg2NDYxLDc1ODM0NDE1NCwtMzcxNTU5MjI1LC05Mjg0Nzcx
LDQ3NTUzNjgyMywtMTQ5OTEwNzY2MywtMTE1ODI0NjA5NSwtMT
A4NzU1NDk3MSwtMTU5NzM2NzczNCwxMzExMDk0MjgxLC0yMDEz
NDYyNzE4XX0=
-->