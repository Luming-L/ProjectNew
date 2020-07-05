count PRDM9 motif binding sites found in both ATAC-seq peaks

## download hotspots
```bash
wget https://science.sciencemag.org/highwire/filestream/596360/field_highwire_adjunct_files/0/1256442_DatafileS1.txt
# extract A_hotspots_union, i.e.Hotspots found in at least one of the AA1, AA2, AB1 and AB2 individuals
grep -v ^# humanDSBhotspots.txt | awk '$17 ==1 {print}' | wc -l # 40598
grep -v ^# humanDSBhotspots.txt | awk '{FS=OFS="\t";if($17==1){print $1,$2,$3};}' > humanDSBhotspots_AA_AB.txt
wc -l humanDSBhotspots_AA_AB.txt # 40598 humanDSBhotspots_AA_AB.txt
```
[Pratto et al. 2014](https://science.sciencemag.org/content/suppl/2014/11/12/346.6211.1256442.DC1?_ga=2.236340424.892408700.1591381155-1358157743.1587248675)

## liftOver
convert coordinates from one assembly to another.
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

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTgzNzMyMzY1LC05NTk5NzU5NzddfQ==
-->