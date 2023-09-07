# run this to install required packages for this project.
# source("scripts/Packages.R")

# Prevents warnings due to already installed packages from
# outputting.
suppressWarnings({
    suppressPackageStartupMessages(library(bnlearn))
    suppressPackageStartupMessages(library(dplyr))
    suppressPackageStartupMessages(library(devtools))
    suppressPackageStartupMessages(library(graph))
    suppressPackageStartupMessages(library(psych))
    suppressPackageStartupMessages(library(lavaan))
    suppressPackageStartupMessages(library(Rgraphviz))
    suppressPackageStartupMessages(library(igraph))
    suppressPackageStartupMessages(library(tidyr))
    
    
    })

setwd("D:/source/repos/semi_interleaved")

# get Alwood data
source("scripts/Alwood.R")

# get Turner Histomorphometry data
source("scripts/Turner_histo.R")

# get Turner GLDS data
source("scripts/Turner_GLDS.R")

# get Ko data (only use DF named "ko")
source("scripts/Ko.R")

#-----------------------------------------------------------------
#   Getting data into the algorithm
#-----------------------------------------------------------------

# plot Alwood
alwood_structure <- si.hiton.pc(alwood, debug = TRUE, undirected = FALSE)
alwood_structure # output info to the console
graphviz.plot(alwood_structure, main = "Alwood")
# cextend is used to extend the structure of a graph by adding directed edges 
# based on conditional independence tests
ext_alwood <- cextend(alwood_structure, strict = TRUE, debug = TRUE)
graphviz.plot(ext_alwood, main = "Alwood")

# plot Turner Histomorphometry
turner_structure <- si.hiton.pc(turner, undirected = FALSE)
turner_structure
graphviz.plot(turner_structure, main = "Turner Histo")

# plot Turner GLDS
glds_structure <- si.hiton.pc(glds, debug = TRUE, undirected = FALSE)
glds_structure
graphviz.plot(glds_structure, main = "Turner GLDS")
ext_glds <- cextend(glds_structure, strict = TRUE, debug = TRUE)
graphviz.plot(ext_glds, main = "GLDS cextend")

glds_s <- glds[, -c(3,5)]
glds_structure <- si.hiton.pc(glds_s, debug = TRUE, undirected = FALSE)
graphviz.plot(glds_structure, main = "GLDS Epiph")

glds_t <- glds[, -c(4,6)]
glds_structure <- si.hiton.pc(glds_t, debug = TRUE, undirected = FALSE)
graphviz.plot(glds_structure, main = "GLDS Mass")

# plot Ko
ko_structure <- si.hiton.pc(ko, undirected = FALSE, debug = TRUE)
ko_structure
# ext_ko <- cextend(ko_structure, strict = TRUE, debug = TRUE)
graphviz.plot(ko_structure, main = "Ko")

#___________________________________________________________
# Trying Ko with only 4wk max durations and higher unload

#Ko 4wk
ko_4wk <- subset(ko, dur == 28)
ko_4wk_structure <- si.hiton.pc(ko_4wk, undirected = FALSE, debug = TRUE)
ko_4wk_structure
graphviz.plot(ko_4wk_structure, main = "Ko but with 4wk durations only (all unload values preserved)")
# cextend Ko 4wk
ext_ko <- cextend(ko_4wk_structure, strict = TRUE, debug = TRUE)
graphviz.plot(ext_ko, main = "Ko 4wk (cextended)")

#Ko 60%
ko_60 <- subset(ko, unload == 60)
ko_60_structure <- si.hiton.pc(ko_60, undirected = FALSE, debug = TRUE)
ko_60_structure
graphviz.plot(ko_60_structure, main = "Ko with all durations, 60% unload")

#Ko 80%
ko_80 <- subset(ko, unload == 80)
ko_80_structure <- si.hiton.pc(ko_80, undirected = FALSE, debug = TRUE)
ko_80_structure
graphviz.plot(ko_80_structure, main = "Ko with all durations, 80% unload")

#Ko 0%
ko_0 <- subset(ko, unload == 0)
ko_0_structure <- si.hiton.pc(ko_0, undirected = FALSE, debug = TRUE)
ko_0_structure
graphviz.plot(ko_0_structure, main = "Ko with all durations, 0% unload")

#Ko 60%, 4wk
ko_60_4wk <- subset(ko_4wk, unload == 60)
ko_604wk_struct <- si.hiton.pc(ko_60_4wk, undirected = FALSE, debug = TRUE)
ko_604wk_struct
graphviz.plot(ko_604wk_struct, main = "Ko with 4wk durations, 60% unload")

#Ko 60% & 80%, all
ko_60_80 <- rbind(ko_60, ko_80)
ko_6080_struct <- si.hiton.pc(ko_60_80, undirected = FALSE, debug = TRUE)
ko_6080_struct

graphviz.plot(ko_6080_struct, main = "Ko with all durations, 60% AND 80% unload")

cextend_graph(ko_6080_struct, "Ko with 4wk, 60 & 80:")


# Ko, correlation Matrix (all data)
ko_graph <- as.igraph(ko_structure)
ko_adj <- get.adjacency(ko_graph, attr = "weight", sparse = FALSE)
graph <- graph_from_adjacency_matrix(ko_adj, mode = 'directed', weighted = TRUE)
edge_list <- as_data_frame(graph, what = "edges")
variables <- sort(unique(c(edge_list$from, edge_list$to)))
cor_matrix <- matrix(0, nrow = length(variables), ncol = length(variables))
rownames(cor_matrix) <- colnames(cor_matrix) <- variables
for(i in 1:nrow(edge_list)){
  cor_matrix[edge_list$from[i], edge_list$to[i]] <- edge_list$weight[i]
  cor_matrix[edge_list$to[i], edge_list$from[i]] <- edge_list$weight[i]
}
corrplot(cor_matrix, method = "circle", type = "lower")


correlation <- cor(ko, method = "pearson")
corrplot(correlation)
ko_cor <- cor(ko_adj)
debug(cor(ko))


#--------------------------------------------
#             Rad Data
#--------------------------------------------
rad <- read.csv("data/radiation_data/GLDS-366_GWAS_processed_associations.csv", header=T, stringsAsFactors=T)

#Take out all rows of just NA
rad <- subset(rad, select = -c(Bgd_X.ray_8, FociPerGy_X.ray_8))
rad <- drop_na(rad)
# rad <- na.omit(rad)
rad <- transform(rad, position.b38. = as.numeric(position.b38.))
# rad$position.b38. <- as.numeric(rad$position.b38.)
rad <- select(rad, -c(33:ncol(rad))) # ridding ourselves of duplicate cols
rad <- rad[complete.cases(rad), ] # getting rid of anything with NA data
write.csv(rad, "data/radiation_data/GLDS-366_saved.csv", row.names = FALSE)

#------------- further sifting through the data ------------
rad <- read.csv("data/radiation_data/GLDS-366_saved.csv", header=T, stringsAsFactors=T)

# Remove duplicate rows from dataframe
rad <- rad[!duplicated(rad), ]
rad$chromosome <- as.factor(rad$chromosome)

# Create columns labelled '1' - '22'. 1-19 corresponding to chromosomes 1-19, 
# M = 20, X = 21, Y = 22
for(i in 1:22) {
  rad[, as.character(i)] <- 0
}

# If the mouse has the chromosome, set that chromosome to 1 
for(i in 1:22) {
  rad[rad$chromosome == i, rad$as.character(i)] <- 1
}
rad <- select(rad, -c(33:54)) # ridding ourselves of extra cols created by above loop for some reason













#note: try regression tree for simplifying data / creating why's/separation
# q: why are Markov blankets good for this project?
# q: baseline to compare against?
# q: could there be any other resources such as creating decision trees to 
#    determine at least somewhat of a baseline
# note: it seems that cextend is getting the directions of arcs pretty much backwards. 
#   q:  could this be because they're using different conditional independence tests
#       than our algorithms?
# q: How can we get some scatter plots
# to try doing a decision tree
#!!python!! <sklearn> <- <pandas> dataframe <- pass dataframe into a function
# 
