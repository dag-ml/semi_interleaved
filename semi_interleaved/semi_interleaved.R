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
#   Getting it into the algo
#-----------------------------------------------------------------
set_global_graph_attrs

# plot Alwood
si_structure <- si.hiton.pc(alwood, undirected = FALSE)
# alwood_bn <- bn.fit(data = si_structure, method = "bayes")
# modelS <- modelstring(si_structure)
# alwood_dag <- model2network(modelS)
si_structure # output info to the console
si_structure_g <- as.graphNEL(si_structure)
plot(si_structure_g)

# plot Turner Histomorphometry
si_structure <- si.hiton.pc(turner, undirected = FALSE)
si_structure
si_structure_g <- as.graphNEL(si_structure)
# plot(si_structure_g)

# plot Turner GLDS
si_structure <- si.hiton.pc(glds, undirected = FALSE)
si_structure
si_structure_g <- as.graphNEL(si_structure)
plot(si_structure_g)

# plot Ko
si_structure <- si.hiton.pc(ko, undirected = FALSE)
si_structure
si_structure_g <- as.graphNEL(si_structure)
# plot(si_structure_g)


