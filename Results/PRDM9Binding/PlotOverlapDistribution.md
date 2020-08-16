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
## 23 cancer types
![enter image description here](https://raw.githubusercontent.com/Luming-L/ProjectNew/master/Results/PlotOverlapDistribution/hotspotsOverlap_23.png)
## 410 samples
![enter image description here](https://raw.githubusercontent.com/Luming-L/ProjectNew/master/Results/PlotOverlapDistribution/hotspotsOverlap_410.png)

# Reference
[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

[Recombination initiation maps of individual human genomes](https://science.sciencemag.org/content/346/6211/1256442)
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTk3NjExNDc5NV19
-->