# This script contains the ETL code for the 2016 US presidential elections
# data.

# load packages and data
library(tidyverse)
df <- read_csv("2016_US_County_Level_Presidential_Results.csv")

# `diff` and `per_point_diff` columns are always positive.
# Since we are interested in whether a given county had more Republican or 
# Democrat votes, we have to recompute these columns. 
# Columns are positive if there are more Republican votes than Democrat votes.
df <- df %>% mutate(diff = votes_gop - votes_dem,
                    per_point_diff = diff / total_votes * 100)

# select the columns we want (renaming some of them) and save it in a
# new CSV file
df %>% 
    select(fips = combined_fips, percent_diff = per_point_diff, 
           state = state_abbr, county = county_name, 
           votes_dem, votes_gop, total_votes) %>%
    write_csv("2016_US_Presdential_Results_for_class.csv")
