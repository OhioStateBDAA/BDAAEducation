#install.packages( c("tm","dplyr","tidyr") )

#Load Packages
library(tm)
require(dplyr)
library(lubridate)
library(ggplot2)
#library(tidyr), good for handling nulls / incomplete data, shape wide to long, joins, spread/gather key pairs etc.


# #Get Tweets from existing twitter list 
# library(twitteR)
# valentines_df <- twListToDF(valentines)
# write.csv(valentines_df, file='/Users/Kalman/Documents/SENIOR/valentines.csv', row.names = FALSE)

#Get Tweets from csv download 
valentines_df <- read.csv('/Users/Kalman/Documents/BDAA/valentines.csv', header = TRUE) 

#Drop unwanted columns
  # AKA "subsetting", use filter() for rows 
  #select from dplyr NOTE: ONLY takes listed columns, 
valentines_df <- select(valentines_df, text, favoriteCount, created, statusSource, retweetCount)
#OR valentines_df <- select(valentines_df, -favorited, -replyToSN, -truncated, -replyToSID, -id, -replyToUID, -screenName, -isRetweet, -retweeted, -longitude, -latitude)

#Get source device from statusSource and rename column
  #mutate, if_else from dyplr
  #grepl = boolean 
valentines_df <- mutate(valentines_df, statusSource = if_else(grepl("iPhone", valentines_df$statusSource), "iPhone",
                                                          if_else(grepl("Android", valentines_df$statusSource), "Android",
                                                              if_else(grepl("Tablets", valentines_df$statusSource), "Tablets", "Other"))))
#Rename columns
  #rename from dyplr
  #"cousin" of select except it keeps all columns unless specified
valentines_df <- rename(valentines_df, Device = statusSource, Retweets = retweetCount, Favorites = favoriteCount, Tweet = text)

#Manipulate dates away from UTC (5 hours ahead)
  #with_tz, ymd_hms from lubridate
valentines_df <- mutate(valentines_df, created = with_tz(ymd_hms(valentines_df$created), "EST"))
valentines_df <- rename(valentines_df, Date = created)

#Pipe Operator  (dplyr)
  #passes left side as first argument 
  #makes your code prettier 
#x %>% f(y) is the same as f(x, y)
valentines_df %>% group_by(Device) %>% summarise(mean(Favorites), mean(Retweets))

#This is equivalent to above!
summarise(group_by(valentines_df, Device), mean(Favorites), mean(Retweets))

#Some plots!

#Copy df
valentines_fav <- valentines_df
valentines_rt <- valentines_df 

#First Favorites Graph
ggplot(valentines_fav, aes(Date, Favorites)) + geom_line(aes(group=Device, color=Device), size=1)

#Second Favorites Graph - Filter high outlier
valentines_fav <- valentines_fav %>% filter(Favorites<20)
ggplot(valentines_fav, aes(Date, Favorites)) + geom_line(aes(group=Device, color=Device), size=1)

#Third Favorites Graph - Filter zeros
valentines_fav <- valentines_fav %>% filter(Favorites>0)
ggplot(valentines_fav, aes(Date, Favorites)) + geom_line(aes(group=Device, color=Device), size=1)

#Similar for Retweets?
ggplot(valentines_df, aes(Date, Retweets)) + geom_line(aes(group=Device, color=Device), size=1)
valentines_rt <- valentines_rt %>% filter(Retweets<5)
ggplot(valentines_rt, aes(Date, Retweets)) + geom_line(aes(group=Device, color=Device), size=1)
valentines_rt <- valentines_rt %>% filter(Retweets>0)
ggplot(valentines_rt, aes(Date, Retweets)) + geom_line(aes(group=Device, color=Device), size=1)
