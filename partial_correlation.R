library(tidyverse)

df <- read.csv("football_combined_cleaned.csv")

analysis_df <- df %>%
  select(
    FTHG,
    FTAG,
    HS,
    HST,
    HC,
    mean_temp,
    sunshine,
    precipitation,
    pressure
  ) %>%
  drop_na()

analysis_df$Goal_Diff <- analysis_df$FTHG - analysis_df$FTAG

base_model <- lm(
  Goal_Diff ~ HS + HST + HC,
  data = analysis_df
)

residual_perf <- residuals(base_model)

weather_vars <- c("mean_temp", "sunshine", "precipitation", "pressure")

results <- lapply(weather_vars, function(v) {
  cor(residual_perf, analysis_df[[v]], use = "complete.obs")
})

partial_corr_df <- data.frame(
  Weather_Variable = weather_vars,
  Partial_Correlation = unlist(results)
)

write.csv(partial_corr_df, "partial_correlation_results.csv", row.names = FALSE)