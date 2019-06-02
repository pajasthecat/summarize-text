library(rvest)
library(magrittr)

ScrapeText <- function(url){
  result <-  GetTextFromSource(url) %>%
    RemoveParaText() %>%
    ToString()
  
  return(result)
}

GetTextFromSource <- function(url){
  result <-  read_html(url) %>% 
    html_nodes("p") %>%
    html_text()
  
  return(result)
}

RemoveParaText <- function(text.vector){
  result <- text.vector[grep("[.]", text.vector)]
  
  return(result)
}

ToString <- function(text.vector){
  return(paste(text.vector, collapse = " "))
}