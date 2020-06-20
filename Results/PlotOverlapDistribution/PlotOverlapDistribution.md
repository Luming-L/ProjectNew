
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

DSB hotspots with 

# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[Recombination initiation maps of individual human genomes](https://science.sciencemag.org/content/346/6211/1256442)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTExMjg2NjIyNTUsLTIwMDgzMTk5MSwxNz
Q0NzAxNzEwLDExNTk0MzgyNDMsMjEyODg2NDYxLDc1ODM0NDE1
NCwtMzcxNTU5MjI1LC05Mjg0NzcxLDQ3NTUzNjgyMywtMTQ5OT
EwNzY2MywtMTE1ODI0NjA5NSwtMTA4NzU1NDk3MSwtMTU5NzM2
NzczNCwxMzExMDk0MjgxLC0yMDEzNDYyNzE4LC0yMTM5NzYyOD
Q3LDczMDk5ODExNl19
-->