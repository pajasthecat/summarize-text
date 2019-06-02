library(plumber)
library(caTools)
library(magrittr)

source('clean_text.R')
source('summarize.R')
source('scrape_content.R')

#* Summmarize text§
#* @param base64.decoded.text
#* @post /api/v1/texts/summarize
SummmarizeText <- function(base64.decoded.text){
  # Endpoint for summarizing text
  
  byte.vector <- base64enc::base64decode(base64.decoded.text)
  
  text <- rawToChar(byte.vector)
  
  clean.text <- CleanText(text)
  
  doc.df  <- data.frame(
    raw = unlist(strsplit(unlist(text), "[.]")), 
    clean = unlist(strsplit(unlist(clean.text), "[.]")))
  
  word.vector <- VectorizeAndRemoveChar(clean.text) 
  
  word.frequency.df <- CalculateWordFrequency(word.vector)
  
  word.frequency.df$weighted.freq <- CalculateWeightedWordFrequency(word.frequency.df$Freq)
  
  doc.df$points <- CalculateLinesSum(word.frequency.df, doc.df$clean)

  doc.df <- doc.df[order(doc.df$points, decreasing = TRUE), ]
  
  doc.df <- head(doc.df, 5)
  
  summation.ordered <- doc.df[order(rownames(doc.df)), ]
  
  result <- as.character(summation.ordered$raw)[1:5]
  
  result <- paste(result, collapse = ".")
  
  return(result)
}

#* Get text from url
#* @param url
#* @get /api/v1/texts/scrape
ScrapeFromURL <- function(url){
  result <- ScrapeText(url)  %>%
    caTools::base64encode()

  return(result)
}