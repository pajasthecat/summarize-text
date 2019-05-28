start_time <- Sys.time()

get_text_as_lines <- function(){
  raw_text <- scan("./example/test.txt", sep = "\n", what = "char")
  
  raw_text_lines <- strsplit(raw_text, "\\.")
  
  raw_text_lines_list <- lapply(raw_text_lines, function(x) strsplit(x, "\\W"))
  
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




exchange_words_with_weighted_frequency <- function(table_with_freq, lines_list){
  temp_vector <- c()
  for(line in lines_list){
    temp = 0
    for(word in table_with_freq$list_of_all_words){
      if(is.na(match(word,line)[1])){
        temp <- temp + table_with_freq$weighted_freq[table_with_freq$list_of_all_words == word]
      }
    }
    temp_vector <- c(temp_vector, temp)
  }
  
  return(temp_vector)
}

exchange_words_with_weighted_frequency_TWO <- function(table_with_freq, lines_list){
  temp_vector <- c()
  lapply(lines_list, function(x){
    temp = 0
    sapply(table_with_freq$list_of_all_words, function(word){
      if(is.na(match(word,x)[1])){
        temp <- temp + table_with_freq$weighted_freq[table_with_freq$list_of_all_words == word]
      }
      temp_vector <- c(temp_vector, temp)
    })})
  return(temp_vector)
}

raw_text_lines_list <- get_text_as_lines()

raw_text_removed_stopwords <- remove_stop_words(raw_text_lines_list)

word_frequency <- get_word_frequency(raw_text_removed_stopwords)

word_frequency_weighted <-get_weighted_frequency(word_frequency)  

frequency_scores <- exchange_words_with_weighted_frequency_TWO(word_frequency_weighted, raw_text_removed_stopwords)

frequency_scores_with_sentence <-data.frame(
  unlist(lapply(raw_text_removed_stopwords, function(x) paste(x, collapse =" "))), 
  frequency_scores)


frequency_scores_with_sentence_sorted <- frequency_scores_with_sentence[order(
  frequency_scores_with_sentence$frequency_scores, 
  decreasing = TRUE),]

print(frequency_scores_with_sentence_sorted$unlist.lapply.raw_text_removed_stopwords..function.x..paste.x..[1])
print(frequency_scores_with_sentence_sorted$unlist.lapply.raw_text_removed_stopwords..function.x..paste.x..[2])
print(frequency_scores_with_sentence_sorted$unlist.lapply.raw_text_removed_stopwords..function.x..paste.x..[3])

end_time <- Sys.time()

time <- end_time - start_time
print(time)