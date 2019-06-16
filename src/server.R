library(plumber)

r <- plumb("src/controller.R")

port <- Sys.getenv("PORT") 

if(port == ""){
  port <- "8001"
}

r$run(host='0.0.0.0', port=strtoi(port))