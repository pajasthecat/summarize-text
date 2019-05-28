if (!require(stringi)) install.packages('stringi')
if (!require(tm)) install.packages('tm')
if (!require(dplyr)) install.packages('dplyr')
if (!require(readr)) install.packages("readr")
if (!require(plumber)) install.packages("plumber")

library(readr)
library(tm)
library(dplyr)
library(stringi)
library(plumber)

get_clean_text <- function(raw_text){
  doc <- VCorpus(VectorSource(raw_text))
  
  doc2 <- tm_map(doc, function(x) stri_replace_all_fixed(x, "\t", ""))
  doc21 <- tm_map(doc2, function(x) stri_replace_all_fixed(x, "\r", ""))
  doc22 <- tm_map(doc21, function(x) stri_replace_all_fixed(x, "\n", ""))
  doc23 <- tm_map(doc22, function(x) stri_replace_all_fixed(x, ",", ""))
  
  doc3 <- tm_map(doc23, PlainTextDocument)
  
  doc4 <- tm_map(doc3, stripWhitespace)
  
  doc5 <- tm_map(doc4, removeWords, stopwords("english"))
  
  doc6 <- tm_map(doc5, tolower) 
  
  return(doc6$content)
}

vectorize_and_remove_char <- function(cleaned_doc){
  
  word_vector <- strsplit(unlist(cleaned_doc), " ")[[1]]
  
  no_whitespace = word_vector[word_vector != ""]
  
  no_whitespace_no_dot <- gsub("[.]", "", no_whitespace)
  
  return(no_whitespace_no_dot)
}

get_word_frequency <- function(word_vector){
  
  frequency_of_words <- data.frame(table(word_vector))
  names(frequency_of_words)[1] <- "Words"
  sorted <- frequency_of_words[order(frequency_of_words$Freq, decreasing = TRUE),]
  return(sorted)
}

get_weighted_frequency <- function(frequency_vector){
  weighted_frequency_vector <- c()
  for(freq in frequency_vector){
    i <- freq/frequency_vector[1]
    weighted_frequency_vector <- c(weighted_frequency_vector, i)
  }
  
  return(weighted_frequency_vector)
}


get_sum_of_line <- function(line, word_df){
  words_vector <- as.character(word_df$Words)
  #line_vector <-strsplit(line, " ")[[1]]
  line_vector <- vectorize_and_remove_char(line)
  points <- word_df$weighted_freq[match(line_vector, words_vector)]
  sum_points <- sum(points)
  return(sum_points)
}

exchange_words_with_weighted_frequency <- function(word_df, lines_factor){
  temp_vector <- c()
  i <- sapply(as.character(lines_factor), get_sum_of_line, word_df = word_df)
  temp_vector <- c(temp_vector, i)
  
  return(temp_vector)
}

#* Sum text
#* @param raw_text text to summarize
#* @post /api/vi/texts/summarize

get_summation_of_text <- function(raw_text){
  clean_text <- get_clean_text(raw_text)
  
  doc_df  <- data.frame(
    raw = unlist(strsplit(unlist(raw_text), "[.]")), 
    clean = unlist(strsplit(unlist(clean_text), "[.]")))
  
  word_vector <- vectorize_and_remove_char(clean_text) 
  
  word_frequency_df <- get_word_frequency(word_vector)
  
  word_frequency_df$weighted_freq <- get_weighted_frequency(word_frequency_df$Freq)
  
  doc_df$points <- exchange_words_with_weighted_frequency(word_frequency_df, doc_df$clean)
  
  doc_df <- doc_df[order(doc_df$points, decreasing = TRUE),]
  
  summation_ordered <- doc_df[order(rownames(doc_df)),]
  
  result <- as.character(summation_ordered$raw)[1:5]
  
  result <- paste(result, collapse = ".")
  
  return(result)
}


start_time <- Sys.time()

path <- "./example/pg730.txt"

raw_text <- read_file(path)

#raw_text <- scan(path, sep = "\n", what = "char")

result <- get_summation_of_text(raw_text)

print(result)

end_time <- Sys.time()

time <- end_time - start_time
print(time)


