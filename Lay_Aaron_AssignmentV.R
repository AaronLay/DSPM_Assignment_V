

rm(list= ls())

library(httr)
library(devtools)
library(jsonlite)
library(dplyr)


wd = "C:/Users/aaron/Arbeitsplatz/Uni/M.Sc. Data Science/(1) WiSe_21_22/Data Science Project Management/Assignments"
setwd(wd)


source(paste(wd,"/TickMas_API.R",sep=""))

# Task 3


venues_grmny <- GET(url = "https://app.ticketmaster.com/discovery/v2/venues?",
                    query = list(countryCode = "DE",
                                 locale = '*',
                                 apikey = key))

total_pages = content(venues_grmny)$page$totalPages


venue_data <- jsonlite::fromJSON(content(venues_grmny,as = "text"))[["_embedded"]]$venues  %>% select(name,city,postalCode,address,url,location)

venue_data[,2] <- venue_data[,2]
venue_data[,4] <- venue_data[,4]
venue_data[,6:7] <- venue_data[,6]

colnames(venue_data) <- c("name","city","postalCode","address","url","longitude","latitude")

glimpse(venue_data)


"
# Task 4

test <-content(venues_grmny)

n = 5950

venue_data_complete <- 
  data.frame(
    name = character(n),
    city = character(n),
    postalCode = character(n),
    adress = character(n),
    url = character(n),
    longitude = character(n),
    latitude = character(n))


for (i in 1:238){
  
  venues_grmny <- GET(url = "https://app.ticketmaster.com/discovery/v2/venues.json?", 
                      query = list(countryCode = "DE", 
                                   apikey = key, 
                                   size = 20 ,
                                   page = i))
                      
                      
  venue_data_complete[((i-1)*20+1):(i*20),] <- jsonlite::fromJSON(content(venues_grmny,as = "text"))[["_embedded"]]$venues  %>% select(name,city,postalCode,address,url,location)
                      
                      
  Sys.sleep(0.5)
  
  
}

"


