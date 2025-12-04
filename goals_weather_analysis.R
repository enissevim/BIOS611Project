library(tidyverse)

df <- read.csv("football_combined_cleaned.csv")

goals_weather_data <- df %>%
  mutate(
    Total_Goals = FTHG + FTAG,
    Goal_Diff = FTHG - FTAG,
    Rainy = precipitation > 0,
    Precip_Category = case_when(
      precipitation == 0 ~ "Dry (0mm)",
      precipitation <= 2 ~ "Light Rain (0-2mm)",
      precipitation <= 5 ~ "Moderate (2-5mm)",
      TRUE ~ "Heavy (>5mm)"
    )
  ) %>%
  select(Total_Goals, Goal_Diff, FTHG, FTAG, precipitation, Rainy, Precip_Category) %>%
  drop_na()

png("figures/goals_by_rain_normalized.png", width = 1000, height = 800)
ggplot(goals_weather_data, aes(Rainy, Total_Goals, fill = Rainy)) +
  geom_violin(alpha = 0.7, scale = "width") +
  geom_boxplot(width = 0.1, alpha = 0.8, outlier.shape = NA) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 5, fill = "white") +
  scale_fill_manual(values = c("FALSE" = "gold", "TRUE" = "skyblue")) +
  scale_x_discrete(labels = c("FALSE" = "Dry Matches", "TRUE" = "Rainy Matches")) +
  labs(title = "Goal Distribution: Rainy vs Dry Matches") +
  theme_minimal() +
  theme(legend.position = "none")
dev.off()

weather_bins <- goals_weather_data %>%
  group_by(Precip_Category) %>%
  summarise(
    Avg_Goals = mean(Total_Goals),
    SE_Goals = sd(Total_Goals)/sqrt(n()),
    Lower_CI = Avg_Goals - 1.96*SE_Goals,
    Upper_CI = Avg_Goals + 1.96*SE_Goals,
    Matches = n(),
    Proportion = n()/nrow(goals_weather_data),
    Home_Goals = mean(FTHG),
    Away_Goals = mean(FTAG),
    Goal_Diff_Avg = mean(Goal_Diff),
    Home_Win_Rate = mean(Goal_Diff > 0)
  )

weather_bins$Precip_Category <- factor(
  weather_bins$Precip_Category,
  levels = c(
    "Dry (0mm)",
    "Light Rain (0-2mm)",
    "Moderate (2-5mm)",
    "Heavy (>5mm)"
  )
)

write.csv(weather_bins, "goals_by_precipitation_bins.csv", row.names = FALSE)