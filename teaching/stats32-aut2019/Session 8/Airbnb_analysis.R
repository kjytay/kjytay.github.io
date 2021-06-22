# This script is a short data analysis of Airbnb listings in New York City in 
# 2019. The data was taken from 
# https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data/.

# load packages and dataset
# make sure that the dataset file is in the same folder as this script!
library(tidyverse)

df <- read_csv("airbnb_nyc_2019.csv", 
               col_types = cols(host_id = col_character(), 
                                id = col_character(), 
                                last_review = col_date(format = "%Y-%m-%d")))

# getting a feel for the data
dim(df)
head(df)
names(df)

# no duplicates in listing id
length(unique(df$id))

# if reviews_per_month is empty, it probably means zero reviews
df$reviews_per_month <- replace_na(df$reviews_per_month, 0)

#####
# NEIGHBORHOOD
#####
# ???
ggplot(df, aes(x = fct_infreq(neighbourhood_group))) +
    geom_bar() +
    labs(title = "No. of listings by borough",
         x = "Borough", y = "No. of listings")

# ???
ggplot(df, aes(x = fct_infreq(neighbourhood_group), fill = room_type)) +
    geom_bar() +
    labs(title = "No. of listings by borough",
         x = "Borough", y = "No. of listings") +
    theme(legend.position = "bottom")

# ???
df %>%
    group_by(neighbourhood) %>%
    summarize(num_listings = n(), 
              borough = unique(neighbourhood_group)) %>%
    top_n(n = 10, wt = num_listings) %>%
    ggplot(aes(x = fct_reorder(neighbourhood, num_listings), 
               y = num_listings, fill = borough)) +
    geom_col() +
    coord_flip() +
    theme(legend.position = "bottom") +
    labs(title = "Top 10 neighborhoods by no. of listings",
         x = "Neighborhood", y = "No. of listings")

#####
# ???
#####
# violin plot of price by room type
ggplot(df, aes(x = room_type, y = price)) +
    geom_violin()

# ??
ggplot(df, aes(x = room_type, y = price)) +
    geom_violin() +
    scale_y_log10()

# ??
df %>% filter(price == 0) %>%
    select(name, host_id, host_name, neighbourhood_group, room_type, minimum_nights)

#####
# RELATIONSHIP BETWEEN NO. OF LISTINGS AND MEDIAN PRICE BY NEIGHBORHOOD
#####
# ???
nhd_df <- df %>%
    group_by(neighbourhood) %>%
    summarize(num_listings = n(),
              median_price = median(price),
              long = median(longitude),
              lat = median(latitude),
              borough = unique(neighbourhood_group))

# ???
nhd_df %>%
    ggplot(aes(x = num_listings, y = median_price, col = borough)) +
    geom_point(alpha = 0.5) + geom_smooth(se = FALSE) +
    scale_x_log10() + scale_y_log10() +
    theme_minimal() +
    theme(legend.position = "bottom")


# # OPTIONAL SECTION: MAKING MAPS
# # If you have time, go ahead and uncomment the section below (highlight and press
# # Shift + Cmd + C or click on the menu Code > Comment/Uncomment Lines). You
# # will need to install the ggmap package for the code to work.
# #####
# # MAP
# #####
# # Don't worry about understanding the code in this section. Just run the lines
# # of code as is and see what the results are.
# # For this section to work, you will have to install the ggmap package with 
# # the following code:
# #   install.packages("ggmap")
# library(ggmap)
# 
# # get top 50 listings by price
# top_df <- df %>% top_n(n = 50, wt = price)
# 
# # get background map
# top_height <- max(top_df$latitude) - min(top_df$latitude)
# top_width <- max(top_df$longitude) - min(top_df$longitude)
# top_borders <- c(bottom  = min(top_df$latitude)  - 0.1 * top_height,
#                  top     = max(top_df$latitude)  + 0.1 * top_height,
#                  left    = min(top_df$longitude) - 0.1 * top_width,
#                  right   = max(top_df$longitude) + 0.1 * top_width)
# 
# top_map <- get_stamenmap(top_borders, zoom = 12, maptype = "toner-lite")
# 
# # map of top 50 most expensive
# ggmap(top_map) +
#     geom_point(data = top_df, mapping = aes(x = longitude, y = latitude,
#                                         col = price)) +
#     scale_color_gradient(low = "blue", high = "red")
# 
# # map of all listings: one point per neighborhood
# height <- max(df$latitude) - min(df$latitude)
# width <- max(df$longitude) - min(df$longitude)
# borders <- c(bottom  = min(df$latitude)  - 0.1 * height,
#              top     = max(df$latitude)  + 0.1 * height,
#              left    = min(df$longitude) - 0.1 * width,
#              right   = max(df$longitude) + 0.1 * width)
# 
# map <- get_stamenmap(borders, zoom = 11, maptype = "toner-lite")
# ggmap(map) +
#     geom_point(data = nhd_df, mapping = aes(x = long, y = lat,
#                                             col = median_price, size = num_listings)) +
#     scale_color_gradient(low = "blue", high = "red")
