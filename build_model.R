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

train <- model_data[idx, ]
test  <- model_data[-idx, ]

x_train <- model.matrix(Result ~ . - 1, train)
x_test  <- model.matrix(Result ~ . - 1, test)

y_train <- as.numeric(train$Result) - 1
y_test  <- as.numeric(test$Result) - 1

dtrain <- xgb.DMatrix(x_train, label = y_train)
dtest  <- xgb.DMatrix(x_test, label = y_test)

params <- list(
  objective = "multi:softmax",
  num_class  = 3,
  eval_metric = "mlogloss"
)

model <- xgb.train(params, dtrain, nrounds = 100)

saveRDS(model, "build_model.rds")