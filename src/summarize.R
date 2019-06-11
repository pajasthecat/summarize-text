source('/app/src/clean_text.R')

CalculateWordFrequency <- function(word_vector){
  # Calculate word frequency in vector of word. 
  
  frequency_of_words <- data.frame(table(word_vector))
  
  names(frequency_of_words)[1] <- "Words"
  
  sorted <- frequency_of_words[order(frequency_of_words$Freq, decreasing = TRUE), ]
  
  return(sorted)
}

CalculateWeightedWordFrequency <- function(frequency.vector){
  # Calculate weighted frequency of word.
  
  weighted.frequency.vector <- c()
  
  for(freq in frequency.vector){
    weighted.frequency <- freq/frequency.vector[1]
    weighted.frequency.vector <- c(weighted.frequency.vector, weighted.frequency)
  }
  
  return(weighted.frequency.vector)
}

CalculateLineSum <- function(line, word.df){
  # Calculates sum of weighted frequency per line.
  
  words.vector <- as.character(word.df$Words)
  
  line.vector <- VectorizeAndRemoveChar(line)
  
  points <- word.df$weighted.freq[match(line.vector, words.vector)]
  
  sum.points <- sum(points)
  
  return(sum.points)
}

CalculateLinesSum <- function(word.df, lines.factor){
  # Calculates sum of all lines in text.
  
  sum.of.lines <- sapply(as.character(lines.factor), 
              CalculateLineSum, word.df = word.df)
  
  return(sum.of.lines)
}
