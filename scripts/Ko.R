#NOTE: Ko4 is all of the animals that were 

# setwd("D:/source/repos/semi_interleaved")

## Ko
# Define a vector 'nastring' with values that should be interpreted as NA in the data.
nastring <- c("           *","epiphysis broken")  # things we want R to read as NA

# Read raw files
ko1 <- read.csv("data/ko_data/LSDS-40_Bone_Biomechanical_LDSD-40_biomechanical_KoTRANSFORMED.csv",  header=T, stringsAsFactors=F) 
ko2 <- read.csv("data/ko_data/LSDS-40_histomorphometry_LSDS-40_histomorphometry_KoTRANSFORMED.csv", header=T, stringsAsFactors=F,na.strings=nastring)
ko3 <- read.csv("data/ko_data/LSDS-40_microCT_LSDS-40_microCT_KoTRANSFORMED.csv",                   header=T, stringsAsFactors=F,na.strings=nastring)
ko4 <- read.csv("data/ko_data/LSDS-41_peripheral_quantitative_computed_tomography_pQCT_LSDS-41_pQCT_KoTRANSFORMED.csv", header=T, stringsAsFactors=F)

# Subest to needed columns/rows
ko1 <- ko1[,c(1,3:4,8:10)]
ko2 <- ko2[!(is.na(ko2$Source.Name)),c(1,7:11)]
ko3 <- ko3[,c(1,10,13:17)]
ko4 <- ko4[,c(1,4:7)]


# Subset and rename columns in each dataset (ko1, ko2, ko3, ko4) to keep only relevant information.
# The 'c' function is used to concatenate the column numbers.
# New names are assigned to selected columns using the 'names' 
names(ko1) <- c("ID","PWB","duration","stiffness","load.max","load.fail")
names(ko2) <- c("ID","OBSBS","OCSBS",'MSBS',"MAR","BFRBS")
names(ko3) <- c("ID","BVTV","trab.num","trab.thick","trab.sep","BMD","cort.thick")
names(ko4) <- c("ID","BMD0","BMD1","BMD2","BMD4")

# create indicators of source file
# Create indicator variables for each dataset (ko1, ko2, ko3, ko4) to track their source.
# New columns (k1, k2, k3, k4) are added to indicate which dataset the data came from.
ko1$k1 <- 1
ko2$k2 <- 1
ko3$k3 <- 1
ko4$k4 <- 1

# Merge files based on the 'ID' column, keeping all rows from each dataset (outer join).
ko12   <- merge(ko1,ko2,by="ID",all.x=T,all.y=T)
ko123  <- merge(ko12,ko3,by="ID",all=T)
ko1234 <- merge(ko123,ko4,by="ID",all=T)

# Fill in missing indicators with 0
ko1234$k1[is.na(ko12$k1)] <-0
ko1234$k2[is.na(ko12$k2)] <-0
ko1234$k3[is.na(ko12$k3)] <-0
ko1234$k4[is.na(ko12$k4)] <-0

# Keep only needed rows
ko <- ko1234[!(is.na(ko1234$stiffness)),]# Keep only the rows in 'ko1234' where 'stiffness' is not missing (NA).

# Create new variables 'unload' and 'dur' based on conditions for 'PWB' and 'duration' columns, respectively.
# These new variables are numeric representations of the conditions specified.
ko$unload <- 0*(ko$PWB=='PWB100')+30*(ko$PWB=="PWB70")+60*(ko$PWB=="PWB40")+80*(ko$PWB =="PWB20")
ko$dur <- 7*(ko$duration=='1wk')+14*(ko$duration=='2wk')+28*(ko$duration=='4wk')

ko <- ko[,c('BVTV','BMD','trab.sep','trab.num','MSBS','OCSBS','BFRBS','load.max','load.fail','unload','dur')]

ko$BVTV <- as.numeric(as.character(ko$BVTV))
ko$BMD <- as.numeric(as.character(ko$BMD))
ko$trab.sep <- as.numeric(as.character(ko$trab.sep))
ko$trab.num <- as.numeric(as.character(ko$trab.num))

# Create composite variables
# 'nfactors = 1' specifies that only one principal component is needed.
mass <- pca(r=ko[,c("BVTV","BMD")], nfactors = 1, scores = T)
trab <- pca(r=ko[,c("trab.sep","trab.num")], nfactors = 1, scores = T)
form   <- pca(r=ko[,c("MSBS","BFRBS")], nfactors = 1, scores = T)
stren <- pca(r=ko[,c("load.max","load.fail")], nfactors = 1, scores = T)
# The PCA scores are stored as new columns in 'ko'.
ko$mass <- as.vector(mass$scores[,1])
ko$trab <- as.vector(trab$scores[,1])
ko$stren <- as.vector(stren$scores[,1])

# Calculate 'expose' using the 'unload' and 'dur' columns and standardize it.
# The standardized value indicates how far each 'unload' value is from the mean, 
# in terms of standard deviations.
ko$expose <- ((ko$unload*ko$dur)-mean(ko$unload*ko$dur))/(sd(ko$unload*ko$dur))
ko$resorp <- scale(ko$OCSBS) # Standardize the 'OCSBS' column ('resorp') using the 'scale' function.
ko$form   <- as.vector(form$scores)


ko <- ko[,c("unload","dur","expose","mass","trab","stren","resorp","form")]
# ko <- ko[,c("unload","dur","mass","trab","stren","resorp","form")]


rm(list=c("mass","trab","form","stren"))


