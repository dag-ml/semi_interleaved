# Prevents warnings due to already installed packages from
# outputting.
suppressWarnings({
    suppressPackageStartupMessages(library(bnlearn))
    suppressPackageStartupMessages(library(dplyr))
    suppressPackageStartupMessages(library(devtools))
    suppressPackageStartupMessages(library(graph))
    })

#-----------------------------------------------------------------
#   Functions:
#-----------------------------------------------------------------

get_csv <- function(){
    filepath <- file.choose()
    if (!grepl("\\.csv$", filepath, ignore.case = TRUE)) {
        message("ERROR: Please select a .csv file.")
        return(get_csv())
    }
    return(filepath)
}

#-----------------------------------------------------------------
#   Main:
#-----------------------------------------------------------------
path_osd_310 <- get_csv()
data_osd_310 <- read.csv(path_osd_310, header = FALSE) # now in Data Frame
# Headerless csv, just column names

# remove first 3 columns and first row (Variable Names, use -c(0:1)) 
# and preserve only numerical data
sub_data_osd_310 <- data_osd_310[, -c(0:3)]
sub_data_osd_310[] <- lapply(sub_data_osd_310, as.factor)

si_structure <- si.hiton.pc(sub_data_osd_310, undirected = FALSE)
si_structure_g <- as.graphNEL(si_structure)
plot(si_structure)
