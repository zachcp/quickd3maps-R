library(rvest)
library(dplyr)
library(devtools)


getlat <- function(s) {
  latloncity <- strsplit(s, " / ")[[1]][[3]]
  latlon     <- strsplit(latloncity, "\\(")[[1]][[1]]
  as.numeric(strsplit(latlon,";")[[1]][[1]])
}

getlon <- function(s) {
  latloncity <- strsplit(s, " / ")[[1]][[3]]
  latlon     <- strsplit(latloncity, "\\(")[[1]][[1]]
  lon        <- strsplit(latlon,";")[[1]][[2]]
  as.numeric(substr(lon, 1, 7)) #weird character at position 10 creates NAs
}

getarea <- function(s) {
  km2 <- strsplit(s, "\n")[[1]][[2]]
  km2 <- gsub(",","",km2)
  strsplit(km2, "\\s")[[1]][[1]]
}

removebrackets <- function(s) {
  strsplit(s, "\\[")[[1]][[1]]
}


topcities <- read_html("https://en.wikipedia.org/wiki/List_of_United_States_cities_by_population")

topcities %>%
  html_node(".wikitable") %>%
  html_table() -> cities

cities %>%
  mutate(Rank = `2014 rank`,
         State = `State[5]`,
         Area = `2014 land area`,
         Population = `2014 estimate`) %>%
  select(City, State, Area, Location, Population) -> cities

cities$City      <- as.character(lapply(cities$City, removebrackets))
cities$Longitude <- as.numeric(lapply(cities$Location, getlon))
cities$Latitude  <- as.numeric(lapply(cities$Location, getlat))
cities$Area      <- as.numeric(lapply(cities$Area, getarea))
cities$Population <- as.numeric(gsub(",","",cities$Population))
cities           <- cities %>% select(-Location)
uscities         <- cities

#write.csv(cities,file =  "data-raw/topcities.csv" )
devtools::use_data(uscities, overwrite = T)
