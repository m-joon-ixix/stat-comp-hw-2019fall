library(readr)
library(dplyr)
library(RSQLite)
con <- dbConnect(SQLite(), "project.sqlite")

library(tidyverse)


# 1-2

airlines <- read_csv("data/airlines.csv")
airplanes <- read_csv("data/airplanes.csv")
airports <- read_csv("data/airports.csv", col_names = c("number", "name", "city", "country", "IATA", "ICAO", "lat", "long",
                                                   "elevation", "timezone", "letter", "continent/city", "airport", "OurAirports"))

dbWriteTable(con, "airlines", airlines, overwrite = TRUE)
dbWriteTable(con, "airplanes", airplanes, overwrite = TRUE)
dbWriteTable(con, "airports", airports, overwrite = TRUE)


# 1-3

for(y in 2001:2018){
  for(m in 1:12){
    if(m >= 10){
      fname = str_c("data/", y, m, ".zip")
    } else {
      fname = str_c("data/", y, "0", m, ".zip")
    }
    # for each file, read_csv and WriteTable with append option
    month_tbl <- read_csv(fname)
    dbWriteTable(con, "flights", month_tbl, overwrite = FALSE, append = TRUE, row.names = FALSE)
  }
}


# 1-4

# making indices on "flights"

colname <- str_c(colnames(tbl(con, "flights")), collapse = ", ")

idx_str_sql <- str_c("CREATE INDEX idx_flights ON flights(", colname, ")")

dbSendQuery(con, idx_str_sql)


#######

dbDisconnect(con)

# completed Part 1