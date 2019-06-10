library(plumber)

r <- plumb("/src/controller.R")

r$run(host='0.0.0.0', port=strtoi(8000))