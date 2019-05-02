install.packages("stopwords")
install.packages("dplyr")

library(dplyr)
library(stopwords)

get_text_as_lines <- function(){
  raw_text <- scan("./example/test.txt", sep = "\n", what = "char")
  
  raw_text_lines <- strsplit(raw_text, "\\.")
  
  raw_text_lines_list <- lapply(raw_text_lines, function(x) strsplit(x, "\\W"))[[1]]
  
  return (raw_text_lines_list)
}

remove_stop_words <- function(text_as_lines){
  raw_text_removed_stopwords <- list()
  
  for(line in text_as_lines){
    line_without_spaces <-line[line != ""]
    words <- line_without_spaces %in% stopwords()
    indexes <- which(words == TRUE)
    for(i in indexes){
      line_without_spaces <- line_without_spaces[-i]
    }
    raw_text_removed_stopwords <- c(raw_text_removed_stopwords, list(line_without_spaces))
  }
  return(raw_text_removed_stopwords)
}

get_word_frequency <- function(text){
  list_of_all_words <- unlist(text)
  
  frequency_of_words <- as.data.frame(table(list_of_all_words))
  
  sorted <- frequency_of_words[order(frequency_of_words$Freq, decreasing = TRUE),]
  return(sorted)
}

get_weighted_frequency <- function(text_table){
  temp <- c()
  for(freq in text_table$Freq){
    i <- freq/text_table$Freq[1]
    temp <- c(temp, i)
  }
  
  text_table$weighted_freq <- temp
  
  return(text_table)
}

raw_text_lines_list <- get_text_as_lines()

raw_text_removed_stopwords <- remove_stop_words(raw_text_lines_list)

word_frequency <- get_word_frequency(raw_text_removed_stopwords)

word_frequency_weighted <-get_weighted_frequency(word_frequency)  


