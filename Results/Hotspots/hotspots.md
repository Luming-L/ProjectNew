count PRDM9 binding sites found in both DSB hotspots (testis) and ATAC-seq peaks for each sample
# Input
humanDSBhotspots_AA_AB.txt
PRDM9 motif occurrences in ATAC-seq peaks for each sample (404)
(e.g. ACCx_TCGA-OR-A5J2-01A_peakCalls_fimo.gff)
## download humanDSBhotspots file
```bash
wget https://science.sciencemag.org/highwire/filestream/596360/field_highwire_adjunct_files/0/1256442_DatafileS1.txt
# extract A_hotspots_union, i.e.Hotspots found in at least one of the AA1, AA2, AB1 and AB2 individuals
grep -v ^# humanDSBhotspots.txt | awk '$17 ==1 {print}' | wc -l # 40598
grep -v ^# humanDSBhotspots.txt | awk '{FS=OFS="\t";if($17==1){print $1,$2,$3};}' > humanDSBhotspots_AA_AB.txt
wc -l humanDSBhotspots_AA_AB.txt # 40598 humanDSBhotspots_AA_AB.txt
```
[Pratto et al. 2014](https://science.sciencemag.org/content/suppl/2014/11/12/346.6211.1256442.DC1?_ga=2.236340424.892408700.1591381155-1358157743.1587248675)
## liftOver: convert coordinates
convert coordinates in `humanDSBhotspots_AA_AB.txt` from one assembly to another.
```bash
# download liftOver
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/c
# make it executable
chmod 700 liftOver
# download map.chain file that has the old genome as the target and the new genome as the query. This file is required as input to the liftOver utility.
wget http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg19ToHg38.over.chain.gz
gzip -d hg19ToHg38.over.chain.gz
# convert coordinates
~/Tools/liftOver humanDSBhotspots_AA_AB.txt ~/Tools/hg19ToHg38.over.chain humanDSBhotspots_AA_AB.hg38.txt unMapped
```
# Process
```bash
 qsub ~/countMotifInHotspotsAndPeaks.sh
```
## 
```bash
bedtools intersect -a $file -b /home/s1949868/humanDSBhotspots/humanDSBhotspots_AA_AB.hg38.txt -f 1.0 -u > "${fileName}_MotifInHotspotsAndPeaks.gff"
numMotifInHotspotsAndPeaks=`wc -l "${fileName}_MotifInHotspotsAndPeaks.gff" | awk '{print $1}'`
```
# Output
# Reference
[https://elifesciences.org/articles/28383](https://elifesciences.org/articles/28383)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEzMjc1NDAwMzUsMTQ3NzcyOTI2NCwtMj
QyMDUzMzM1LC05NTk5NzU5NzddfQ==
-->