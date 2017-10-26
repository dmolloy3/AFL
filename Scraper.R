library(tidyverse)
library(rvest)
library(stringr)

#Import and Tidy all games
all.games <- read_table("All Games.txt", skip = 2, col_names = FALSE) %>%
  select(date = X2, round = X3, home.team = X4, home.score = X5, away.team = X6, away.score = X7, venue = X8)
all.games$date <- parse_date(all.games$date, "%d-%b-%Y")
all.games$home.team <- factor(all.games$home.team)
all.games$away.team <- factor(all.games$away.team)
all.games$venue <- factor(all.games$venue)

home.scores <- all.games$home.score %>% str_split("\\.", simplify = TRUE) %>% as_tibble() %>% select(home.goals = V1, home.behinds = V2, home.total = V3)
away.scores <- all.games$away.score %>% str_split("\\.", simplify = TRUE) %>% as_tibble() %>% select(away.goals = V1, away.behinds = V2, away.total = V3)
all.games <- bind_cols(all.games, home.scores)
all.games <- bind_cols(all.games, away.scores)
all.games <- all.games %>%
  select(date, round, home.team, home.goals, home.behinds, home.total, away.team, away.goals, away.behinds, away.total, venue) %>%
  mutate_at(vars(ends_with("goals")), funs(as.integer)) %>%
  mutate_at(vars(ends_with("behinds")), funs(as.integer)) %>%
  mutate_at(vars(ends_with("total")), funs(as.integer)) %>%
  mutate(home.win = if_else(home.total > away.total, 1, 0),
         home.win = if_else(home.total == away.total, .5, .5))
rm(list=setdiff(ls(), "all.games"))
