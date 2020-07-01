# Input
**BigWig files**
ATAC-seq signal tracks that have been normalized by the number of reads in peaks. 

**Method of generating ATAC-seq signal tracks in the paper:**
 1. bin genome into 100-bp intervals
 2. convert the Tn5 offset-corrected insertion sites into a coverage
 3. calculate the sum of per position coverage in each bin as the number of Tn5 insertions within each bin
 4. normalize the total number of reads by a scale factor that converted all samples to a constant 30 million reads within peaks
 5. normalize samples by their quality and read depth

**Format:**

In the BedGraph file, the score is the signal in each 100-bp bin. We can take the average signal of all bins as genome background and calculate the statistical significance for signal in each bin.
|chr|start|end|score|
|--|--|--|--|
|chr1|0|9999|0.000000|
|chr1|9999|10099|9.525880|
|chr1|10099|10199|14.288800|
# Process
## convert BigWig to BedGraph
## 
# Output
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTAyMjAwNTg4NCwtOTg0OTY4MTQyXX0=
-->