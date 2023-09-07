# Run this script for any packages that need to be installed for this project. 

install.packages("bnlearn")
install.packages("dplyr")
#install.packages("dv cevtools") # not available in 4.3
install.packages("devtools") # probably use this instead on 4.3
#install_github("jtextor/dagitty/r") # can't find / use function
if (!requireNamespace("BiocManager", quietly = TRUE))
 install.packages("BiocManager")
BiocManager::install("graph", version = "3.17")
install.packages("igraph")
install.packages("tidyr")

