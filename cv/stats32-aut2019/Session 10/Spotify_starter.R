# This is the starter script for the spotify analysis. Read through
# the comments and run the code. Make sure you understand what is going on.

# Make sure that the spotify data file is in the same folder as this script!

# import packages
library(tidyverse)

# import data
# We are going to change the data in the mode column, and we are going to
# select just the columns of interest to us.
# Details on the columns we are using are below. For details on the remainder 
# of the columns, see https://www.kaggle.com/nadintamer/top-tracks-of-2017.
# - `name`: Name of the song  
# - `artists`:  Artist(s) of the song
# - `loudness`: The overall loudness of a track in decibels (dB). Loudness 
#     values are averaged across the entire track and are useful for comparing 
#     relative loudness of tracks. Loudness is the quality of a sound that is 
#     the primary psychological correlate of physical strength (amplitude). 
#     Values typical range between -60 and 0 db. 
# - `mode`: Mode indicates the modality (major or minor) of a track, the type 
#     of scale from which its melodic content is derived.
# - `valence`: A measure from 0.0 to 1.0 describing the musical positiveness 
#     conveyed by a track. Tracks with high valence sound more positive (e.g. 
#     happy, cheerful, euphoric), while tracks with low valence sound more 
#     negative (e.g. sad, depressed, angry).  
# - `tempo`: The overall estimated tempo of a track in beats per minute (BPM).
#     In musical terminology, tempo is the speed or pace of a given piece and 
#     derives directly from the average beat duration.
df <- read_csv("spotify-2017.csv", 
               col_types = cols(mode = col_character()))
df <- df %>% mutate(mode = fct_recode(mode, 
                                      "Major" = "1.0",
                                      "Minor" = "0.0"))
df <- df %>% select(name, artists, loudness, mode, valence, tempo)

# look at the data
head(df)

## Differences in tempo between songs in major and minor keys

# histogram of tempo by mode
ggplot(data = df, mapping = aes(x = tempo)) +
    geom_histogram(aes(fill = mode)) +
    facet_wrap(~ mode)

# density plot instead
ggplot(data = df, mapping = aes(x = tempo)) +
    geom_density(aes(col = mode))

# mean tempo for each of the modes
df %>% group_by(mode) %>%
    summarize(mean_tempo = mean(tempo))
