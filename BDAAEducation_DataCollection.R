# Get tweets from Twitter API 

#install.packages("tm")
library(twitteR)
library(wordcloud)
library(tm)

# Access Tokens
consumer_key <- "JHQBq3XDkZUBy49fg7PWP3Zrx" #API Key
consumer_secret <- "IdyToDcxaP2IBok7bJ77J8HcLxXU43hN1YQeoZzlJsp9peAXce" 
access_token <- "784134368394706944-TENc5wyOXYlot1jY0jcZzk1iDRiYhpx"
access_secret <- "NX7cFWhYCDIOBqK0TsSEAKCDa4Dg7G9vY3KN6pU1KKba1"

#Setup OAuth
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#Get Tweets
search <- 'Valentines Day exclude:retweets+exclude:replies+exclude:links+exclude:images'
valentines <- searchTwitter(search, n=100, lang='en', since='2017-02-14', until='2017-02-15')

#Get DataFrame
#valentines_df <- twListToDF(valentines)
#Encoding(valentines_text)
#Encoding(valentines_text) <-"latin1"
valentines_text <- sapply(valentines, function(x) x$getText())
valentines_text <- sapply(valentines_text, function(row) iconv(row, "latin1", "ASCII", sub=""))

#Get Corpus
#valentines_corpus <- DataframeSource(valentines_df)
valentines_corpus <- Corpus(VectorSource(valentines_text))

#Clean with tm
valentines_clean <- tm_map(valentines_corpus, removePunctuation)
valentines_clean <- tm_map(valentines_clean, content_transformer(tolower))
valentines_clean <- tm_map(valentines_clean, removeWords, stopwords("english"))
valentines_clean <- tm_map(valentines_clean, removeNumbers)
valentines_clean <- tm_map(valentines_clean, stripWhitespace)
valentines_clean <- tm_map(valentines_clean,removeWords, c("valentines","day", "happy"))

#wordcloud 1
wordcloud(valentines_clean)

#wordcloud 2
wordcloud(valentines_clean, random.order = F)

#wordcloud 3
wordcloud(valentines_clean, random.order = F, scale=c(5, 1))

#wordcloud 3
wordcloud(valentines_clean, random.order = F, scale=c(5, 1), col=rainbow(30))

# BONUS:
wordcloud(valentines_more, random.order = F, scale=c(5, .5), max.word=100, colors=rainbow(50))

# ctrl + L to clear console 
# ctrl + 1 to Script
# ctrl + 2 to Console
# command left, right, shift  
# comman + shift + c comments

# search <- 'Super Bowl exclude:retweets+exclude:replies+exclude:links+exclude:images'
# super_bowl <- searchTwitter(search, n=10, lang="en", since='2017-02-05', until='2017-02-06', geocode='33.753746, -84.386330, 100mi')
# 
# super_bowl_df <- twListToDF(super_bowl_patriots)
# write.csv(super_bowl_df, file='/Users/Kalman/superbowl_data.csv', row.names = FALSE)
