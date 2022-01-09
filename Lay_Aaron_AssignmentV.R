

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

venue_data <- jsonlite::fromJSON(content(venues_grmny,as = "text"))[["_embedded"]]$venues  %>% select(name,city,postalCode,address,url,location)

venue_data[,2] <- venue_data[,2]
venue_data[,4] <- venue_data[,4]
venue_data[,6:7] <- venue_data[,6]

colnames(venue_data) <- c("name","city","postalCode","address","url","longitude","latitude")

glimpse(venue_data)



# Task 4

size = 250

total_pages = content(GET(url = "https://app.ticketmaster.com/discovery/v2/venues?",
                          query = list(countryCode = "DE",
                                       locale = '*',
                                       apikey = key,
                                       size = 250)))$page$totalPages

#n = size * total_pages
n = content(GET(url = "https://app.ticketmaster.com/discovery/v2/venues?",
                query = list(countryCode = "DE",
                             locale = '*',
                             apikey = key,
                             size = 250)))$page$totalElements

venue_data_complete <- 
  data.frame(
    name = character(n),
    city = character(n),
    postalCode = character(n),
    adress = character(n),
    url = character(n),
    longitude = character(n),
    latitude = character(n),
    stringsAsFactors = FALSE)


for (i in 0:(total_pages-1)){
  
  venues_germany <- GET(url = "https://app.ticketmaster.com/discovery/v2/venues.json?", 
                        query = list(countryCode = "DE", 
                                     apikey = key, 
                                     locale = '*',
                                     size = size ,
                                     page = i))
  if (i < 50){
    
    json_raw = jsonlite::fromJSON(content(venues_germany ,as = "text"))[["_embedded"]]$venues  %>% select(name,city,postalCode,address,url,location)
    
    json_raw[,2] <- json_raw[,2]
    json_raw[,4] <- json_raw[,4]
    json_raw[,6:7] <- json_raw[,6]
    
    venue_data_complete[((i*size)+1):((i+1)*size),] <- json_raw
    
  } else {
    
    json_raw = jsonlite::fromJSON(content(venues_germany ,as = "text"))[["_embedded"]]$venues  %>% select(name,city,postalCode,address,url,location)
    
    json_raw[,2] <- json_raw[,2]
    json_raw[,4] <- json_raw[,4]
    json_raw[,6:7] <- json_raw[,6]
    
    venue_data_complete[((i*size)+1):n,] <- json_raw
    
  } 
  
  Sys.sleep(0.5)
  
}






