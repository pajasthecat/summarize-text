library(plumber)

r <- plumb("/app/src/controller.R")

r$run(host='0.0.0.0', port=strtoi(8000))