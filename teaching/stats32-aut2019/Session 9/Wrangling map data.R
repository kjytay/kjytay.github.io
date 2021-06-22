# `county.fips` is a dataset in the `maps` package which maps FIPS codes to 
# US county and state names. `county` is a dataset which has the outlines for
# US counties, but does not have FIPS data. This script adds FIPS data to 
# the `county` dataset.

library(dplyr)
library(ggplot2)
library(maps)

# Some counties in `county.fips` have more than one entry, so we have
# to amend the dataset to ensure they only have one entry
fips_county <- county.fips %>% 
    separate(polyname, into = c("State", "County"), sep=",") %>%
    filter(fips != 12091) %>%
    add_row(fips = 12091, State = "florida", County = "okaloosa") %>%
    filter(fips != 22099) %>%
    add_row(fips = 22099, State = "louisiana", County = "st martin") %>%
    filter(fips != 37053) %>%
    add_row(fips = 37053, State = "north carolina", County = "currituck") %>%
    filter(fips != 48167) %>%
    add_row(fips = 48167, State = "texas", County = "galveston") %>%
    filter(fips != 51001) %>%
    add_row(fips = 51001, State = "virginia", County = "accomack") %>%
    filter(fips != 53053) %>%
    add_row(fips = 53053, State = "washington", County = "pierce") %>%
    filter(fips != 53055) %>%
    add_row(fips = 53055, State = "washington", County = "san juan")

county <- map_data("county")

# join the 2 datasets
county_map_fips <- county %>% 
    left_join(fips_county, by = c("region" = "State", "subregion" = "County"))

# write out to RDS file. For more on RDS files, see
# http://www.fromthebottomoftheheap.net/2012/04/01/saving-and-loading-r-objects/
saveRDS(county_map_fips, "county_map_fips.rds")
