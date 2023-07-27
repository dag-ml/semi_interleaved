
## GLDS
# Set the working directory to the specified location
# (Note: The path is specific to the user's system)
# setwd("D:/source/repos/semi_interleaved")

# Read data from a CSV file named "GLDS-351.csv" into the variable 'glds'
# The 'header' parameter is set to 'TRUE', indicating the first row contains column names.
# 'stringsAsFactors' is set to 'FALSE' to prevent converting character vectors to factors.
glds <- read.csv("data/turner_data/GLDS-351.csv", header=T, stringsAsFactors=F)
# If 'Treatment' is "Ground Control", set 'expose' to 0; otherwise, set it to 1.
glds$expose <- ifelse(glds$Teatment=="Ground Control",0,1)
glds<- glds[7:30,c(5:7,11,13,16:19,22:25)]  

# Make component variables (Principal Component Analysis)
# PCA is used to reduce number of variables while retaining information.
#     Captures the principal component or linear combination of these
#     variables that explains the most significant variance in the data.
# 'nfactors=1' specifies that only one principal component is needed.
# 'scores = T' indicates that the PCA scores will be returned.
mass      <- pca(r=glds[,c("DXA_BMC_mg","DXA_BMD_mg_per_mmsq")],nfactors=1,scores = T)
trab_meta <- pca(r=glds[,c("metaphysis_canc_Tb_Sp_micrometer","metaphysis_canc_Tb_N_1per_mm")],nfactors=1,scores = T)
trab_epiph <- pca(r=glds[,c("epiphysis_canc_Tb_Sp_micrometer","epiphysis_canc_Tb_N_1per_mm")],nfactors=1,scores = T)

# Store the PCA scores as new variables in 'glds'.
glds$mass <- as.vector(mass$scores)
glds$trab_meta <- as.vector(trab_meta$scores)
glds$trab_epiph <- as.vector(trab_epiph$scores)

# Standardize site-specific/single variable mass measures
names(glds)[5] <- "mass_meta"
# 'scale' function centers the data to have mean 0 and scales to have standard deviation 1.
glds$mass_meta <- scale(glds$mass_meta)

names(glds)[9] <- "mass_epiph"
glds$mass_epiph <- scale(glds$mass_epiph)

# Final dataset
glds <- glds[,c("expose","mass","mass_meta","mass_epiph","trab_meta","trab_epiph")]

# Remove unnecessary objects from the R environment.
rm(list=c("mass","trab_epiph","trab_meta"))