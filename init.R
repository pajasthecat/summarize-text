## Install R packages
packages <- c('stringi', 'tm', 'dplyr', "readr", "plumber", "base64enc", "magrittr", "caTools")

install_if_missing <- function(p) {
  if (!p %in% rownames(installed.packages())) {
    install.packages(p)
  }
}

invisible(sapply(packages, install_if_missing))

library(plumber)

r <- plumb("src/controller.R")

r$run(port=8000)