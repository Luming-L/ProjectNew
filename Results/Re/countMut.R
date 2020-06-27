library(stringr)
library(regioneR)

# read the "TCGA_identifier_mapping.txt (5 columns, the delimiter is "\t")"
table <- readr::read_tsv("/exports/eddie/scratch/s1949868/TCGA_identifier_mapping")

# load snv files in RDS format
mutect2_snv <- readRDS(file = "/exports/eddie/scratch/s1949868/SNPsAndSmallINDELs/mutect2_snv.rds")

# get the sample ID
file=commandArgs(T)
ID <- stringr::str_extract(file,"[:alnum:]{4}-[:alnum:]{2}-[:alnum:]{4}-[:alnum:]{3}")

# get the cancerType
idx <- grep(ID,stringr::str_extract(table$Case_ID,"[:alnum:]{4}-[:alnum:]{2}-[:alnum:]{4}-[:alnum:]{3}"))
cancerType <- unique(substr(table[idx,]$bam_prefix,1,4))

# get the number of somatic mutations for a sample
numMut <- nrow(mutect2_snv[mutect2_snv$Sample_ID==ID,])

# get the number of overlaps between peaks and mutations for a sample
mutations <- toGRanges(mutect2_snv[mutect2_snv$Sample_ID==ID,c(3,4,5)])
peaks <- toGRanges(paste0("/exports/eddie/scratch/s1949868/PRDM9BoundPeaks_410_Case_ID/",ID,"_PRDM9_bound_peaks.bed"))
numOverlaps <- numOverlaps(A=peaks, B=mutations, count.once=TRUE)

# write the results
write.table(data.frame(ID,cancerType,numMut,numOverlaps),
	file="/exports/eddie/scratch/s1949868/SNPsAndSmallINDELs/MutNumber.txt",
	sep = "\t",
	append=TRUE,row.names = FALSE,col.names = FALSE,
	quote =FALSE
	)