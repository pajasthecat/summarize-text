library(plumber)

r <- plumb("controller.R")

r$run(port=8000)