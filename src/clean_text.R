library(tm)
library(stringi)

CleanText <- function(raw.text){
  # Function to clean text before summarizing.
  
  temp <- tolower(raw.text)
  temp <- stri_replace_all_regex(temp, "[^a-zA-Z.\\s]", " ")
  temp <- stri_replace_all_fixed(temp, "\t", " ")
  temp <- stri_replace_all_fixed(temp, "\n", " ")
  temp <- stri_replace_all_fixed(temp, "\r", " ")
  temp <- stri_replace_all_regex(temp, "[\\s]+", " ")
  
  return(temp)
}

VectorizeAndRemoveChar <- function(cleaned.doc){
  
  word.vector <- strsplit(unlist(cleaned.doc), " ")[[1]]
  
  no.whitespace = word.vector[word.vector != ""]
  
  no.whitespace.no.dot <- gsub("[.]", "", no.whitespace)
  
  return(no.whitespace.no.dot)
}