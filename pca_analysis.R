library(tidyverse)
library(factoextra)

df <- read.csv("football_combined_cleaned.csv")

pca_data <- df %>%
  select(
    FTR,
    HS, AS, HST, AST, HC, AC, HF, AF, HY, AY,
    FTHG, FTAG,
    mean_temp,
    sunshine,
    precipitation,
    pressure
  ) %>%
  drop_na()

pca_vars <- pca_data %>%
  select(-FTR)

pca <- prcomp(pca_vars, center = TRUE, scale. = TRUE)

pca_df <- as.data.frame(pca$x)
pca_df$Result <- factor(pca_data$FTR, levels = c("H", "D", "A"), labels = c("Home Win", "Draw", "Away Win"))

pc1_loadings <- pca$rotation[,1]
pc2_loadings <- pca$rotation[,2]

pc1_label <- "Match Dominance (Home vs Away)"
pc2_label <- "Weather Conditions"

if(mean(pc1_loadings[c("HS", "HST", "HC", "FTHG")]) < 0) {
  pc1_label <- "Match Dominance (Away vs Home)"
}

png("figures/pca_by_result.png", width = 1000, height = 800)

ggplot(pca_df, aes(PC1, PC2, color = Result)) +
  geom_point(alpha = 0.7, size = 2) +
  scale_color_manual(values = c("Home Win" = "darkgreen", "Draw" = "gold", "Away Win" = "red")) +
  labs(
    title = "PCA: Match Outcomes by Performance & Weather",
    x = paste("PC1: ", pc1_label, " (", round(summary(pca)$importance[2,1]*100, 1), "% variance)"),
    y = paste("PC2: ", pc2_label, " (", round(summary(pca)$importance[2,2]*100, 1), "% variance)"),
    color = "Match Result"
  ) +
  theme_minimal()

dev.off()

png("figures/pca_plot.png", width = 1000, height = 800)

fviz_pca_biplot(
  pca,
  geom.ind = "point",
  pointsize = 1.5,
  label = "var",
  repel = TRUE,
  col.var = "blue"
) +
  labs(
    title = "PCA Biplot: All Match & Weather Variables",
    x = paste("PC1: ", pc1_label, " (", round(summary(pca)$importance[2,1] * 100, 1), "%)"),
    y = paste("PC2: ", pc2_label, " (", round(summary(pca)$importance[2,2] * 100, 1), "%)")
  ) +
  theme_minimal()

dev.off()