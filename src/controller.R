library(plumber)
library(caTools)
library(magrittr)

source('clean_text.R')
source('/app/src/summarize.R')
source('/app/src/scrape_content.R')

#* Summmarize text
#* @param base64Content
#* @post /api/v1/texts/summarize
SummmarizeText <- function(base64Content){
  # Endpoint for summarizing text
  
  byte.vector <- base64enc::base64decode(base64Content)
  
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

#* Scrape text from url
#* @param uri to text
#* @get /api/v1/texts/scrape/<url>
ScrapeFromURL <- function(uri){
  result <- ScrapeText(uri)  %>%
    caTools::base64encode()

  return(result)
}
