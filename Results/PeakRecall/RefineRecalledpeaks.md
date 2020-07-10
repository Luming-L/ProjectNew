# Input
Recalled peaks in each technical replicate (796, the output of PeakRecall.py)
Cancer type-specific peak calls (23)
# Process
## download cancer type-specific PeakCalls
```bash
wget https://api.gdc.cancer.gov/data/71ccfc55-b428-4a04-bb5a-227f7f3bf91c
unzip 71ccfc55-b428-4a04-bb5a-227f7f3bf91c
mkdir TCGA-ATAC_Cancer_Type-specific_PeakCalls
mv *.txt TCGA-ATAC_Cancer_Type-specific_PeakCalls
```
## prepare the input of bedtools
sort files
```bash
# prepare the input of bedtools
echo "sort start: $(date)"
# sort and cut files of Cancer Type-specific PeakCalls
cd /exports/eddie/scratch/s1949868/TCGA-ATAC_Cancer_Type-specific_PeakCalls # Cancer_Type_PeakCalls_path in peakOverlap.py
for file in $(ls); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3,$4;}}' > /exports/eddie/scratch/s1949868/RefineRecalledPeaks/${file}.sorted; done
cd /exports/eddie/scratch/s1949868/RecallPeak # peaks_path in peakOverlap.py
for file in $(ls ./*insertions.peaks.bed); do sort -k1,1 -k2,2n $file | awk '{FS=OFS="\t"; if($1~/^chr/){print $1,$2,$3}}' > /exports/eddie/scratch/s1949868/RefineRecalledPeaks/${file}.sorted; done
echo "sort done: $(date)"
```
## Refine peaks by overlapping with cancer type-specific peak sets
```bash
qsub ~/peakRefine_batch.sh
```
1. for each technical replicate (796), the minimum overlap between cancer type peaks and sample recalled peaks should be more than 60% of cancer type peaks. (set by `-f 0.6`) Then output these cancer type peaks.
2. refined peaks in two replicates from the same sample will be merged. only report peaks obeserved in two replicates (set by `-c`)
3. finally get a list of peaks for each of 410 biological samples

**options**
`-f`： Minimum overlap required as **a fraction of A**. 

`-c`: For each entry in A, report the number of hits in B while restricting to -f.

`-wa`: Write the original entry in A for each overlap.

`-u`: Write original A entry once if any overlaps found in B. In other words, just report the fact at least one overlap was found in B. 
```python
if bioSample_dict[sample] == 1: # 1 technical replicate for a ID
	os.system("bedtools intersect -a " + path + "/" + sample.split("_")[0].replace('x', '') + "*txt.sorted -b " + path + "/" + sample + "*bed.sorted -f 0.5 -u > " + path + "/" + sample+"_peakCalls.bed")
elif bioSample_dict[sample] == 2: # 2 technical replicates for a ID
	os.system("bedtools intersect -a " + path + "/" + sample.split("_")[0].replace('x', '') + "*txt.sorted -b " + path + "/" + sample + "*bed.sorted -f 0.5 -c -wa" + " | awk '{FS=OFS=" + r'"\t"' + ";if($5>0){print $1,$2,$3,$4}}'" + " > " + path + "/" + sample+"_peakCalls.bed")
```
## Rename PeakCalls of 410 samples
```r
# read mapping table
table <- readr::read_tsv("https://api.gdc.cancer.gov/data/7a3d7067-09d6-4acf-82c8-a1a81febf72c")

# get all the path of files
files <- list.files(path ="/exports/eddie/scratch/s1949868/RefineRecalledPeaks/allPeakCalls_CaseID/", pattern = "peakCalls.bed", all.files = FALSE, full.names = TRUE, recursive =TRUE, ignore.case = FALSE, include.dirs =TRUE, no.. = TRUE)
head(files)

# rename files to (cancerType + TCGA Case_ID)
plyr::a_ply(files,1, function(file) {

file.uuid <- stringr::str_extract(file,
"[:alnum:]{8}_[:alnum:]{4}_[:alnum:]{4}_[:alnum:]{4}_[:alnum:]{12}") # get stanfordUUID
print(file.uuid)

idx <- grep(file.uuid,gsub("-","_",table$stanfordUUID)) # use stanfordUUID to find the index

barcode <- unique(table[idx,]$Case_ID) # get Case_ID and use it as the barcode, and give technical replicates the same barcode
barcode <- stringr::str_extract(barcode, "[:alnum:]{4}-[:alnum:]{2}-[:alnum:]{4}-[:alnum:]{3}")

cancerType <- strsplit(strsplit(file,split='//')[[1]][2], split='_')[[1]][1]
cancerType_barcode <- paste0(c(cancerType, barcode), collapse='_')
print(cancerType_barcode)

filename <- stringr::str_extract(file,"[:alnum:]{4}_[:alnum:]{8}_[:alnum:]{4}_[:alnum:]{4}_[:alnum:]{4}_[:alnum:]{12}_[:alnum:]{4}_[:alnum:]{3}") # get the file name
print (filename)

to <- gsub(filename,cancerType_barcode,file) # change uuid in file names to new barcode
print(to)
file.rename(file, to) # rename files
})
```
# Output
404 _peakCalls.bed
keep one sample for each donor (404 donors)
Samples from the same donor are just different in portion.

# Reference
[TCGA_Barcode/](https://docs.gdc.cancer.gov/Encyclopedia/pages/TCGA_Barcode/)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTQ4MjY1ODk0OSwxMTEzMDgzNzM4LC02ND
k4NDkwNzAsLTE4MTA2NzU3MzMsNDkwMjkyOTI2LDE1NDc5OTYx
ODcsLTQzOTg2NDEzMywtMjEzNzM0MzkyMywtNTI5NzYzNDE4LD
E4NjI4NDUzMTksMTQ2NjQyNTAzNCwtMTI5NDIwNzY5NiwxODQ4
NjUzMTAwLC0xMzg3Mzc2ODk4XX0=
-->