library(tidyverse)
library(lubridate)

season_years <- 2000:2020

data_list <- list()

for (year in season_years) {
  start_year <- year
  end_year_short <- substr(year + 1, 3, 4)
  
  if (year == 2020) {
    filename <- "2020-2021.csv"
  } else {
    filename <- paste0(start_year, "-", end_year_short, ".csv")
  }
  
  if (file.exists(filename)) {
    df_season <- read.csv(filename)
    df_season$Season <- paste0(start_year, "-", start_year + 1)
    data_list[[as.character(year)]] <- df_season
  }
}

combined <- bind_rows(data_list)

weather <- read.csv("london_weather.csv")

london_teams_by_season <- list(
  `2000-2001` = c("Arsenal", "Chelsea", "Tottenham", "West Ham", "Charlton", "Fulham"),
  `2001-2002` = c("Arsenal", "Chelsea", "Tottenham", "West Ham", "Fulham"),
  `2002-2003` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2003-2004` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2004-2005` = c("Arsenal", "Chelsea", "Tottenham", "West Ham", "Crystal Palace"),
  `2005-2006` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2006-2007` = c("Arsenal", "Chelsea", "Tottenham", "West Ham", "Charlton"),
  `2007-2008` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2008-2009` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2009-2010` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2010-2011` = c("Arsenal", "Chelsea", "Tottenham", "West Ham", "Fulham", "QPR"),
  `2011-2012` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2012-2013` = c("Arsenal", "Chelsea", "Tottenham", "QPR", "Crystal Palace"),
  `2013-2014` = c("Arsenal", "Chelsea", "Tottenham", "Fulham", "QPR"),
  `2014-2015` = c("Arsenal", "Chelsea", "Tottenham", "QPR"),
  `2015-2016` = c("Arsenal", "Chelsea", "Tottenham", "West Ham"),
  `2016-2017` = c("Arsenal", "Chelsea", "Tottenham"),
  `2017-2018` = c("Arsenal", "Chelsea", "Tottenham", "Fulham"),
  `2018-2019` = c("Arsenal", "Chelsea", "Tottenham", "Fulham"),
  `2019-2020` = c("Arsenal", "Chelsea", "Tottenham", "Fulham"),
  `2020-2021` = c("Arsenal", "Chelsea", "Tottenham", "West Ham", "Fulham")
)

filtered_list <- list()

for (season in names(london_teams_by_season)) {
  season_data <- combined %>% filter(Season == season)
  
  if (nrow(season_data) > 0) {
    teams <- london_teams_by_season[[season]]
    available_teams <- unique(season_data$HomeTeam)
    
    matching_teams <- teams[tolower(teams) %in% tolower(available_teams)]
    
    if (length(matching_teams) < length(teams)) {
      # Common variations
      variations <- list(
        "Tottenham" = c("Tottenham", "Spurs", "Tottenham Hotspur"),
        "West Ham" = c("West Ham", "West Ham United"),
        "QPR" = c("QPR", "Queens Park Rangers"),
        "Charlton" = c("Charlton", "Charlton Athletic")
      )
      
      for (team in teams) {
        if (!any(tolower(team) == tolower(available_teams))) {
          if (team %in% names(variations)) {
            for (variant in variations[[team]]) {
              if (any(tolower(variant) == tolower(available_teams))) {
                matching_teams <- c(matching_teams, variant)
                break
              }
            }
          }
        }
      }
    }
    
    season_filtered <- season_data %>%
      filter(HomeTeam %in% matching_teams) %>%
      select(Season, Date, HomeTeam, AwayTeam, FTR, FTHG, FTAG, 
             HS, AS, HST, AST, HC, AC, HF, AF, HY, AY)
    
    filtered_list[[season]] <- season_filtered
  }
}

df <- bind_rows(filtered_list)

df$Date <- dmy(df$Date)
weather$date <- ymd(weather$date)

merged <- df %>%
  left_join(weather, by = c("Date" = "date"))

write.csv(merged, "football_combined_cleaned.csv", row.names = FALSE)