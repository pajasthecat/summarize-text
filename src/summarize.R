if (!require(stringi)) install.packages('stringi')
if (!require(tm)) install.packages('tm')
if (!require(dplyr)) install.packages('dplyr')
if (!require(readr)) install.packages("readr")

library(readr)
library(tm)
library(dplyr)
library(stringi)

start_time <- Sys.time()

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

exchange_words_with_weighted_frequency <- function(word_df, lines_factor){
  temp_vector <- c()
  for(line in lines_factor){
    temp = 0
    for(word in word_df$Words){
      if(grepl(word, line)){
        temp <- temp + word_df$weighted_freq[word_df$Words == word]
        print(word)
      }
    }
    temp_vector <- c(temp_vector, temp)
  }
  
  return(temp_vector)
}



path <- "./example/benchmark.txt"

raw_text <- read_file(path)

  
##raw_text <- scan(path, sep = "\n", what = "char")

doc <- VCorpus(VectorSource(raw_text))

doc2 <- tm_map(doc, function(x) stri_replace_all_fixed(x, "\t", " "))
doc2 <- tm_map(doc2, function(x) stri_replace_all_fixed(x, "\r", " "))
doc2 <- tm_map(doc2, function(x) stri_replace_all_fixed(x, "\n", " "))

doc3 <- tm_map(doc2, PlainTextDocument)

doc4 <- tm_map(doc3, stripWhitespace)

doc5 <- tm_map(doc4, removeWords, stopwords("english"))

doc6 <- tm_map(doc5, tolower) 

doc_df  <- data.frame(
  raw = unlist(strsplit(unlist(raw_text), "[.]")), 
  clean = unlist(strsplit(unlist(doc6$content), "[.]")))

word_vector <- strsplit(unlist(doc6$content), "\\W")[[1]]

word_no_whitespace_vector = word_vector[word_vector != ""]

word_frequency_df <- get_word_frequency(word_no_whitespace_vector)

word_frequency_df$weighted_freq <- get_weighted_frequency(word_frequency_df$Freq)

doc_df$points <- exchange_words_with_weighted_frequency(word_frequency_df, doc_df$clean)

doc_df <- doc_df[order(doc_df$points, decreasing = TRUE),]

summation <-as.character(doc_df$raw)[1:10]


print(summation)

end_time <- Sys.time()

time <- end_time - start_time
print(time)







get_weighted_freq_data_frame <- function(word_clean, line, word_df){
  if(grepl(word_clean, line)){
    return(word_df$weighted_freq[word_df$Words == word_clean])
  }
}

get_sum_of_line <- function(line, word_df){
  sum_line <- sapply(word_df$Words, get_weighted_freq_data_frame (x, line, word_df))
  return(sum_line)
}

exchange_words_with_weighted_frequency_two <- function(word_df, lines_factor){
  temp_vector <- c()
  
  temp_vector <- c(temp_vector, sapply(lines_factor, get_sum_of_line(x, word_df)))
  
  return(temp_vector)
}



##Benchmark

start_time <- Sys.time()

doc_df$points <- exchange_words_with_weighted_frequency(word_frequency_df, doc_df$clean)

end_time <- Sys.time()

time <- end_time - start_time
print(time)

## new 

start_time <- Sys.time()

doc_df_two$points <- exchange_words_with_weighted_frequency_two(word_frequency_df, doc_df_two$clean)

end_time <- Sys.time()

time <- end_time - start_time
print(time)