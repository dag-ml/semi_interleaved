    # Run this script for any packages that need to be installed for this project. 
    
    install.packages("bnlearn")
    install.packages("dplyr")
    install.packages("dv cevtools") # unless you have it already
    install_github("jtextor/dagitty/r")
    if (!requireNamespace("BiocManager", quietly = TRUE))
     install.packages("BiocManager")
    BiocManager::install("graph", version = "3.17")