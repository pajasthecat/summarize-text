source('src/clean_text.R')

library(magrittr)

CalculateWordFrequency <- function(word_vector){
  # Calculate word frequency in vector of word. 
  
  frequency_of_words <- data.frame(table(word_vector))
  
  names(frequency_of_words)[1] <- "Words"
  
  frequency_of_words_sorted <- frequency_of_words[order(frequency_of_words$Freq, decreasing = TRUE), ]
  
  return(frequency_of_words_sorted)
}

CalculateWeightedWordFrequency <- function(word.frequency.df){
  # Calculate weighted frequency of word.
  
  frequency.vector <- word.frequency.df$Freq
  
  weighted.frequency.vector <- frequency.vector/frequency.vector[1]
  
  word.frequency.df$weighted.freq <- weighted.frequency.vector
  
  return(word.frequency.df)
}

GetWordFrequency <- function(clean.text){
  word.frequency.df <- VectorizeAndRemoveChar(clean.text) %>%
    CalculateWordFrequency() %>%
    CalculateWeightedWordFrequency()
  
  return(word.frequency.df)
}

CalculateLineSum <- function(line.vector, word.df){
  # Calculates sum of weighted frequency per line.
  
  points <- word.df$weighted.freq[match(
    VectorizeAndRemoveChar(line.vector), 
    as.character(word.df$Words))]  %>% 
    sum()
  
  return(points)
}

CalculateLinesSum <- function(word.df, lines.factor){
  # Calculates sum of all lines in text.
  
  sum.of.lines <- sapply(as.character(lines.factor), 
              CalculateLineSum, word.df = word.df)
  
  return(sum.of.lines)
}

GetSummary <- function(word.frequency.df, clean.text, text){
  #Calculate ponits for each line and return result.
  
  doc.df  <- data.frame(
    raw = unlist(strsplit(unlist(text), "[.]")), 
    clean = unlist(strsplit(unlist(clean.text), "[.]")))
  
  doc.df$points <- CalculateLinesSum(word.frequency.df, doc.df$clean)
  
  doc.df <- doc.df[order(doc.df$points, decreasing = TRUE), ]
  
  doc.df <- head(doc.df, 5)
  
  summation.ordered <- doc.df[order(rownames(doc.df)), ]
  
  result <- as.character(summation.ordered$raw)[1:5]
  
  result <- paste(result, collapse = ".")
  
  return(result)
}
