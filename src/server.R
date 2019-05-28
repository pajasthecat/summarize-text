if (!require(plumber)) install.packages("plumber")

library(plumber)
r <- plumb("benchmark.R")
r$run(port=8000)