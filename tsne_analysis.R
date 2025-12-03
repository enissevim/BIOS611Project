library(tidyverse)
library(Rtsne)

df <- read.csv("football_combined_cleaned.csv")

tsne_full <- df %>%
  select(
    FTR,
    FTHG, FTAG,
    HS, HST, HC, HF, HY,
    precipitation, sunshine, mean_temp
  ) %>%
  drop_na()

tsne_input <- tsne_full %>%
  select(
    FTHG, FTAG,
    HS, HST, HC, HF, HY,
    precipitation, sunshine, mean_temp
  ) %>%
  scale()

tsne_result <- Rtsne(
  tsne_input,
  dims = 2,
  perplexity = min(30, nrow(tsne_input) / 4),
  verbose = TRUE,
  max_iter = 1000,
  check_duplicates = FALSE
)

tsne_df <- data.frame(
  tSNE1 = tsne_result$Y[,1],
  tSNE2 = tsne_result$Y[,2],
  Result = tsne_full$FTR,
  HadRain = tsne_full$precipitation > 0,
  Precipitation = tsne_full$precipitation,
  TotalGoals = tsne_full$FTHG + tsne_full$FTAG
)

write.csv(tsne_df, "tsne_results.csv", row.names = FALSE)

tsne_df$ResultLabel <- factor(
  tsne_df$Result,
  levels = c("H", "D", "A"),
  labels = c("Home Win", "Draw", "Away Win")
)

png("figures/tsne_results.png", width = 900, height = 650)
print(
  ggplot(tsne_df, aes(x = tSNE1, y = tSNE2, color = ResultLabel)) +
    geom_point(alpha = 0.7, size = 2) +
    labs(
      title = "t-SNE Visualization of Match Profiles by Result",
      x = "t-SNE Dimension 1",
      y = "t-SNE Dimension 2",
      color = "Match Result"
    ) +
    scale_color_manual(
      values = c(
        "Home Win" = "darkgreen",
        "Draw" = "gold",
        "Away Win" = "red"
      )
    ) +
    theme_minimal()
)
dev.off()

tsne_df$RainLabel <- ifelse(tsne_df$HadRain, "Rain", "No Rain")

png("figures/tsne_weather.png", width = 900, height = 650)
print(
  ggplot(tsne_df, aes(x = tSNE1, y = tSNE2, color = RainLabel)) +
    geom_point(alpha = 0.7, size = 2) +
    labs(
      title = "t-SNE Visualization: Rain vs No Rain Matches",
      x = "t-SNE Dimension 1",
      y = "t-SNE Dimension 2",
      color = "Weather"
    ) +
    scale_color_manual(values = c("Rain" = "skyblue", "No Rain" = "gold")) +
    theme_minimal()
)
dev.off()