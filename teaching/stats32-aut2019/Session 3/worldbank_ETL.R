library(tidyverse)

df <- read.csv("worldbank_data_raw.csv", stringsAsFactors = FALSE)
names(df) <- c("cty_name", "cty_code", "series_name", "series_code",
      as.character(2009:2018))

# fill in NAs appropriately
df[df == ".."] <- NA

# make the data columns numeric
for (col in 2009:2018) {
    df[[as.character(col)]] <- as.numeric(df[[as.character(col)]])
}


# relabel series codes, make series codes the columns instead of years
df_tidy <- df %>% filter(df$series_code != "") %>%
    select(-series_name) %>%
    mutate(series_code = fct_recode(series_code,
                                    "compEduc" = "SE.COM.DURS",
                                    "govEducExp" = "SE.XPD.TOTL.GD.ZS",
                                    "elecAccess" = "EG.ELC.ACCS.ZS",
                                    "popYoung" = "SP.POP.0014.TO.ZS",
                                    "pop" = "SP.POP.TOTL",
                                    "gdpPerCap" = "NY.GDP.PCAP.PP.CD",
                                    "educPri" = "SE.PRM.CUAT.ZS",
                                    "educTer" = "SE.TER.CUAT.BA.ZS")) %>%
    gather(`2009`:`2018`, key = "year", value = "value") %>%
    spread(key = series_code, value = "value") %>%
    mutate(year = as.numeric(year))

# write out the new data frame to disk
write.csv(df_tidy, "worldbank_data_tidy.csv", row.names = FALSE)