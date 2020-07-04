```bash
wget https://science.sciencemag.org/highwire/filestream/596360/field_highwire_adjunct_files/0/1256442_DatafileS1.txt
# extract A_hotspots_union, i.e.Hotspots found in at least one of the AA1, AA2, AB1 and AB2 individuals
grep -v ^# humanDSBhotspots.txt | awk '$17 ==1 {print}' | wc -l # 40598
grep -v ^# humanDSBhotspots.txt | awk '{FS=OFS="\t";if($17==1){print $1,$2,$3};}' > humanDSBhotspots_AA_AB.txt
wc -l humanDSBhotspots_AA_AB.txt # 40598 humanDSBhotspots_AA_AB.txt

```

[Pratto et al. 2014](https://science.sciencemag.org/content/suppl/2014/11/12/346.6211.1256442.DC1?_ga=2.236340424.892408700.1591381155-1358157743.1587248675)

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTYzMTIwMTg4Nl19
-->