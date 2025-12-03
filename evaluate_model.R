library(tidyverse)
library(caret)
library(xgboost)

df <- read.csv("football_combined_cleaned.csv")

df$Result <- factor(df$FTR, levels = c("H", "D", "A"))

model_data <- df %>%
  select(
    Result,
    FTHG, FTAG, HS, HST, HC, HF, HY,
    mean_temp, sunshine, precipitation, pressure
  )

model_data <- model_data[complete.cases(model_data), ]

set.seed(611)
idx <- createDataPartition(model_data$Result, p = 0.8, list = FALSE)

test <- model_data[-idx, ]

x_test <- model.matrix(Result ~ . - 1, test)
y_test <- as.numeric(test$Result) - 1

dtest <- xgb.DMatrix(x_test, label = y_test)

model <- readRDS("build_model.rds")

pred <- predict(model, dtest)

acc <- mean(pred == y_test)

writeLines(paste0("Test Accuracy: ", round(acc, 4)), "xgboost_acc.txt")