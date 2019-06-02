library(tm)
library(stringi)
library(magrittr)

CleanText <- function(raw.text){
  # Function to clean text before summarizing.
  
  temp <- tolower(raw.text)  %>%
    stri_replace_all_regex("[^a-zA-Z.\\s]", " ") %>% 
      stri_replace_all_fixed("\t", " ") %>% 
        stri_replace_all_fixed("\n", " ") %>% 
          stri_replace_all_fixed( "\r", " ") %>% 
            stri_replace_all_regex("[\\s]+", " ") %>%
              VectorSource() %>%
                VCorpus() %>%
                  tm_map(removeWords, stopwords("english"))
  
  return(temp[[1]]$content)
}

VectorizeAndRemoveChar <- function(cleaned.doc){
  
  word.vector <- strsplit(unlist(cleaned.doc), " ")[[1]]
  
  no.whitespace = word.vector[word.vector != ""]
  
  no.whitespace.no.dot <- gsub("[.]", "", no.whitespace)
  
  return(no.whitespace.no.dot)
}