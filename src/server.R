library(plumber)

r <- plumb("/src/controller.R")

r$run(port=8000)