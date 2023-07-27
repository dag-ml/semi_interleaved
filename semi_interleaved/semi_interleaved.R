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

# setwd("C:/source/repos/semi_interleaved")

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

plot(ko_4k$unload, ko_4wk$expose, main = "Scatter plot Example..")

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

#note: try regression tree for simplifying data / creating why's/separation
# q: why are Markov blankets good for this project?
# q: baseline to compare against?
# note: it seems that cextend is getting the directions of arcs pretty much backwards. 
#   q:  could this be because they're using different conditional independence tests
#       than our algorithms?
# q: How can we get some scatter plots
# to try doing a decision tree
#!!python!! <sklearn> <- <pandas> dataframe <- pass dataframe into a function
# 
# 
