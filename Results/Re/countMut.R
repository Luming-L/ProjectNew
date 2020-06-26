library(stringr)

# read the "TCGA_identifier_mapping.txt (5 columns, the delimiter is "\t")"
table <- readr::read_tsv("https://api.gdc.cancer.gov/data/7a3d7067-09d6-4acf-82c8-a1a81febf72c")

# load snv files in RDS format
mutect2_snv <- readRDS(file = "/exports/eddie/scratch/s1949868/SNPsAndSmallINDELs/mutect2_snv.rds")

# get the sample ID
file=commandArgs(T)
ID <- stringr::str_extract(file,"[:alnum:]{4}-[:alnum:]{2}-[:alnum:]{4}-[:alnum:]{3}")

# get the cancerType
idx <- grep(ID,stringr::str_extract(table$Case_ID,"[:alnum:]{4}-[:alnum:]{2}-[:alnum:]{4}-[:alnum:]{3}"))
cancerType <- unique(substr(table[idx,]$bam_prefix,1,4))

# get the number of somatic mutations for a sample
num <- nrow(mutect2_snv[mutect2_snv$Sample_ID==ID,])

# write the results
write.table(data.frame(ID,cancerType,num),
	file="/exports/eddie/scratch/s1949868/SNPsAndSmallINDELs/MutNumber.txt",
	sep = "\t",
	append=TRUE,row.names = FALSE,col.names = FALSE,
	quote =FALSE
	)