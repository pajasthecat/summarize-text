source('../src/clean_text.R')
source('utility_tests.R')

#Test CalculateWeightedWordFrequency

input <- data.frame(table(c("One", "Two", "Three", "Four", "Five", "Six")))
input$Freq <- c(9, 9, 4, 4, 4, 1)
expected <- c(1, 0,33,  0.6666667, 0.4444444, 0.4444444,  0.1111111)

result <- CalculateWeightedWordFrequency(input)

AssertAreEqual(result$weighted.freq, expected)
