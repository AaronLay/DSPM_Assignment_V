

rm(list= ls())

library(httr)
library(devtools)
library(jsonlite)
library(dplyr)
library(ggplot2)

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

venues_country <- function(countryCode,CountryName,min_long,max_long,min_lat,max_lat){

size = 250

total_pages = content(GET(url = "https://app.ticketmaster.com/discovery/v2/venues?",
                          query = list(countryCode = countryCode,
                                       locale = '*',
                                       apikey = key,
                                       size = 250)))$page$totalPages

n = content(GET(url = "https://app.ticketmaster.com/discovery/v2/venues?",
                query = list(countryCode = countryCode,
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
                        query = list(countryCode = countryCode, 
                                     apikey = key, 
                                     locale = '*',
                                     size = size ,
                                     page = i))
  if (i < (total_pages-1)){
    
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

#glimpse(venue_data_complete)

venue_data_complete$longitude <- as.numeric(venue_data_complete$longitude)
venue_data_complete$latitude <- as.numeric(venue_data_complete$latitude)


venue_data_complete$longitude <- ifelse(venue_data_complete$longitude < min_long,NA,venue_data_complete$longitude)
venue_data_complete$longitude <- ifelse(venue_data_complete$longitude > max_long,NA,venue_data_complete$longitude)

venue_data_complete$latitude <- ifelse(venue_data_complete$latitude < min_lat,NA,venue_data_complete$latitude)
venue_data_complete$latitude <- ifelse(venue_data_complete$latitude > max_lat,NA,venue_data_complete$latitude)


ggplot() +
  geom_polygon(aes(x = long, y = lat, group = group), data = map_data("world", region = CountryName),
                        fill = "grey90",color = "black") +
  geom_point(data=venue_data_complete, aes(x = longitude, y = latitude), alpha = 0.5, size = 0.5,colour = "blue") +
  theme_void() + coord_quickmap() +
  labs(title = paste("Event locations across ",CountryName), caption = "Source: ticketmaster.com") +
  theme(title = element_text(size=8, face='bold',hjust = 0.5),plot.caption = element_text(face = "italic"))
  
}  


# function(countryCode,CountryName,min_long,max_long,min_lat,max_lat)

  
venues_country("DE","Germany",5.866944,15.043611,47.271679,55.0846)


venues_country("FR","France",-4.783333,8.216667,42.333333,51.083333)


venues_country("NO","Norway",4.66269,30.94355,58.08878,80.49493)



