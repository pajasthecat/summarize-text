library(plumber)
library(caTools)
library(magrittr)

print(getwd())
source('src/summarize.R')
source('src/scrape_content.R')
source('src/clean_text.R')

#* Summmarize text
#* @param base64Content
#* @post /api/v1/texts/summarize
SummmarizeText <- function(base64Content){
  # Endpoint for summarizing text

  text <- base64enc::base64decode(base64Content) %>%
    rawToChar()
  
  clean.text <- CleanText(text)
  
  word.frequency.df <- GetWordFrequency(clean.text)
  
  result <- list(
    text = GetSummary(word.frequency.df, clean.text, text))
  
  return(result)
}

#* Scrape text from url
#* @param uri to text
#* @get /api/v1/texts/scrape
ScrapeFromURL <- function(uri, res){
  try(
    contentAsBytes <- ScrapeText(uri)  %>%
      caTools::base64encode()
  )

  if(!exists('contentAsBytes')){
    result <- list(
      error = "Unable to scrape page."
    )
    res$status <- 400
    } else {
      result <- list(
        contentAsBytes = contentAsBytes)
    }
  
    return(result)
}
