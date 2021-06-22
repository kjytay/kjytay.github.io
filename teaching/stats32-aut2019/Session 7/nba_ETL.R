library(tidyverse)

players_df <- read_csv("Players.csv", col_types = cols(X1 = col_skip()))
players_df2 <- players_df %>% filter(born >= 1975) %>%
    select(player = Player, height, weight, college = collage, 
           birth_year = born, birth_state)
players_df2$player <- str_replace(players_df2$player, "\\*", "")

season_df <- read.csv("Seasons_Stats.csv", stringsAsFactors = FALSE)
season_df2 <- season_df %>% filter(Year == 2017) %>%
    select(player = Player, team = Tm, G, GS, MP,
           FG, FGA, `3P` = X3P, `3PA` = X3PA,
           FT, FTA, ORB, DRB, AST, STL, BLK, TOV, PF, PTS)

# some players played with more than one team in the season
# we simply assign the player to the team which he played more/most games for
season_df3 <- season_df2 %>% arrange(player, desc(G)) %>%
    mutate(team_temp = lead(team, n = 1)) %>%
    group_by(player) %>%
    top_n(n = 1, wt = G) %>%
    ungroup() %>%
    mutate(team = ifelse(team == "TOT", team_temp, team)) %>%
    select(-team_temp)

# join the datasets together
joined_df <- season_df3 %>% left_join(players_df2, by = "player")

# write out the new data frame to disk
write.csv(joined_df, "nba_tidy.csv", row.names = FALSE)
