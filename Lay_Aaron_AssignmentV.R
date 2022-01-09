

rm(list= ls())

library(httr)
library(devtools)
library(jsonlite)
library(dplyr)


wd = "C:/Users/aaron/Arbeitsplatz/Uni/M.Sc. Data Science/(1) WiSe_21_22/Data Science Project Management/Assignments"
setwd(wd)


source(paste(wd,"/TickMas_API.R",sep=""))

venues_grmny <- GET(url = "https://app.ticketmaster.com/discovery/v2/venues.json",
                    query = list(countryCode = "DE",
                                 apikey = key,
                                 numItems = 25))

venue_data <- jsonlite::fromJSON(content(venues_grmny,as = "text"))[["_embedded"]]$venues  #%>% select(name,city,postalCode,address,url,location)

venue_data[,2] <- venue_data[,2]
venue_data[,4] <- venue_data[,4]
venue_data[,6:7] <- venue_data[,6]

colnames(venue_data) <- c("name","city","postalCode","address","url","longitude","latitude")

glimpse(venue_data)




