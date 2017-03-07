
#---

#install required packages

install.packages(c("tidyr", "dplyr", "titanic", "nnet", "caret"), dependencies = TRUE)

#---

#load our needed packages
library(tidyr) ## "objects masked"
library(dplyr)
library(titanic)
library(nnet)
library(caret)

#---

#save local copies of our datasets
train_data <- titanic_train
test_data <- titanic_test

#let's take a look at our data
View(train_data)
View(test_data)

#---

#convert Age to binary Child (1 = Yes, 0 = No)
train_data <- mutate(train_data, Child = ifelse(Age < 18, 1, 0))
test_data <- mutate(test_data, Child = ifelse(Age < 18, 1, 0))

#let's see the variable we just created
View(train_data)
View(test_data)

#---

#setting the seed allows us to have repeatable results
set.seed(2)

#create our neural net
nnet.fit <- nnet(Survived ~ factor(Pclass)+Sex+factor(Child),
                 data = train_data,
                 size = 3)

#---

#predict who survived from the test set using our model
predicted <- predict(nnet.fit, test_data)

#let's look at our answers
View(predicted)
 
#force our predictions to either 0 or 1
predicted <- mutate(as.data.frame(predicted), 
                    predicted = ifelse(V1 < 0.5, 0, 1))

#looking at our answers again
View(predicted)

#---

#save a local copy of the answers    (answers = actual results?)
test_data_survived <- titanic_gender_class_model 

#let's take a look at the answers
View(test_data_survived)

#joining the answers to the test data
test_data <- inner_join(test_data, test_data_survived, by = "PassengerId") 

#--- ## very briefly describe a join?

#let's look at how well our neural net performed
confusionMatrix(as.factor(predicted$predicted),
                test_data_survived$Survived,
                positive = "1",
                mode = "everything") ## survive = positive, is mode relevant?

#--- ## describe confusion matrix? what variables are we interested in? 

#try to increase accuracy by using continuous variables

#--- ##introduce scaling?

#join both sets of data together to feature scale across all data
joined_data <- bind_rows(train_data, test_data, .id = "data")

#feature scale continuous variables
joined_data$Age <- as.numeric(scale(joined_data$Age,
                                    center = min(joined_data$Age, na.rm = TRUE),
                                    scale = diff(range(joined_data$Age, na.rm = TRUE))))
joined_data$SibSp <- as.numeric(scale(joined_data$SibSp,
                                      center = min(joined_data$SibSp, na.rm = TRUE),
                                      scale = diff(range(joined_data$SibSp, na.rm = TRUE))))
joined_data$Parch <- as.numeric(scale(joined_data$Parch,
                                      center = min(joined_data$Parch, na.rm = TRUE),
                                      scale = diff(range(joined_data$Parch, na.rm = TRUE))))

#let's look at our joined data
View(joined_data)

#---

#split the data sets back into train and test ## when did we set data =...?
train_data <- filter(joined_data, data == 1)
test_data <- filter(joined_data, data == 2)

#---

#reset the seed
set.seed(2)

#create the neural net with Age instead of the Child binary
nnet.fit <- nnet(Survived ~ factor(Pclass)+Sex+Age,
                 data = train_data,
                 size = 3)

#predict who survived from the test set using our model
predicted <- predict(nnet.fit, test_data)

#force our predictions to either 0 or 1
predicted <- mutate(as.data.frame(predicted), 
                    predicted = ifelse(V1 < 0.5, 0, 1))

#let's look at how well this neural net performed
confusionMatrix(as.factor(predicted$predicted),
                test_data_survived$Survived,
                positive = "1",
                mode = "everything")

#---

#try to increase accuracy by adding variables to the model

#---

#reset the seed
set.seed(2)

#create the neural net with additional variables
nnet.fit <- nnet(Survived ~ factor(Pclass)+Sex+Age+SibSp+Parch+Embarked,
                 data = train_data,
                 size = 6)

#predict who survived from the test set using our model
predicted <- predict(nnet.fit, test_data)

#force our predictions to either 0 or 1
predicted <- mutate(as.data.frame(predicted), 
                    predicted = ifelse(V1 < 0.5, 0, 1))

#let's look at how well this neural net performed
confusionMatrix(as.factor(predicted$predicted),
                test_data_survived$Survived,
                positive = "1",
                mode = "everything")

#---

#try to increase accuracy by increasing size

#---

#reset the seed
set.seed(2)

#create our best performing neural net with a larger size
nnet.fit <- nnet(Survived ~ factor(Pclass)+Sex+Age,
                 data = train_data,
                 size = 150)

#predict who survived from the test set using our model
predicted <- predict(nnet.fit, test_data)

#force our predictions to either 0 or 1
predicted <- mutate(as.data.frame(predicted), 
                    predicted = ifelse(V1 < 0.5, 0, 1))

#let's look at how well this neural net performed
confusionMatrix(as.factor(predicted$predicted),
                test_data_survived$Survived,
                positive = "1",
                mode = "everything")

#--- 