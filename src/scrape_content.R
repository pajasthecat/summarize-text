library(rvest)
library(magrittr)

ScrapeText <- function(url){
  result <- GetTextFromSource(url) %>%
    RemoveParaText() %>%
    ToString()
  
  return(result)
}

GetTextFromSource <- function(url){
  ua <- 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36'
  
  result <-  read_html(httr::GET(url, httr::user_agent(ua))) %>% 
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