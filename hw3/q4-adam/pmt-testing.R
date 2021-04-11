library(tidyverse)
library(tree)
library(caret)



rm(list = ls(all = TRUE))


pmt <- function(B, n, i) {
  vn <- (1 + i)^(-n)
  B * i / (1 - vn)
}



loans_raw <- readr::read_csv('data/Loan_approval.csv')

loans480 <- loans_raw %>% 
  na.omit() %>% 
  select(-Loan_ID) %>% 
  mutate_if(is.character, factor) %>% 
  mutate(
    AnnualIncome = (ApplicantIncome + CoapplicantIncome) * 12,
    HasCoapplicant = ifelse(coalesce(CoapplicantIncome, 0) > 0, 1, 0),
    Monthly_PI_05 = pmt(LoanAmount * 1000, Loan_Amount_Term, 0.05/12),
    Monthly_PI_10 = pmt(LoanAmount * 1000, Loan_Amount_Term, 0.10/12),
    Pmt2Income_05 = Monthly_PI_05 * 12 / AnnualIncome,
    Pmt2Income_10 = Monthly_PI_10 * 12 / AnnualIncome,
    LoanType = cut(
      Loan_Amount_Term, c(0, 84, 360, Inf), c('Auto', 'Mortgage', '40 Year')
    )) %>% 
  select(-ApplicantIncome, -CoapplicantIncome) %>% 
  mutate(
    HasCoapplicant = factor(HasCoapplicant),
    Credit_History = factor(Credit_History)) %>% 
  mutate(
    LoanAmount_log = log(LoanAmount),
    Loan_Amount_Term_log = log(Loan_Amount_Term),
    AnnualIncome_log = log(AnnualIncome),
    Pmt2Income_05_log = log(Pmt2Income_05),
    Pmt2Income_10_log = log(Pmt2Income_10)
  )

set.seed(590)
L <- sample(c(TRUE, FALSE), 480, prob = c(.7, .3), replace = TRUE)

train <- loans480[L, ]
test <- loans480[!L, ]

  
t1 <- tree(
  Loan_Status ~ ., 
  data = train)

t1p <- predict(t1, type = 'class')
actual <- train$Loan_Status[as.integer(names(t1$y))]

caret::confusionMatrix(t1p, actual)



t1p_test <- predict(t1, type = 'class', newdata = test)
actual_test <- test$Loan_Status

caret::confusionMatrix(t1p_test, actual_test)




rf <- randomForest(
  Loan_Status ~ ., 
  data = loans480,
  importance = TRUE,
  mtry = 3,
  trees = 1000)


varImpPlot(rf)
