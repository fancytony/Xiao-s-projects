# Xiao-s-projects
My data science projects
## Naive Project Titanic!

This is a test for my naive project Titanic. This will be the start of much more incoming projects.


## The Titanic dataset

The dataset is from [Kaggle](http://www.kaggle.com). The challenge is to build a model that can look at characteristics of an individual who was on the Titanic and predict the likelihood that they would have survived. There are several useful variables that they include in the [dataset](https://www.kaggle.com/c/titanic-gettingStarted) for each person: 
- pclass: passenger class (1st, 2nd, or 3rd)
- sex
- age
- sibsp: number of Siblings/Spouses Aboard
- parch: number of Parents/Children Aboard
- fare: how much the passenger paid
- embarked: where they got on the boat (C = Cherbourg; Q = Queenstown; S = Southampton)


## Loading the required R packages

Now we have to load the packages into the working environment (unlike installing the packages, this step has to be done every time you restart your R session).

```{r, warning = FALSE, message = FALSE}
library(caret)
library(randomForest)
```
## Loading the dataset

To load the dataset, I first set the path to the folder where my files are saved. And then I use "read.table" to load the Titanic dataset with headers.

```
setwd("/Users/xiaoyin/Dropbox/data\ science\ job/my\ R\ projects")
titanic<-read.table("titanic_train.csv",sep=",",header=TRUE)
head(titanic)
```
## Cleanning the dataset

The first thing I want to do is to observe whether there are missing data. This can be achieved by 
```sum(is.na(titanic)
```
Seeing it has 172 NA values, for simplicity here I omit these missing vaues by
```titanic<-na.omit(titanic)
```
## Splitting the dataset

The next thing I want to do, is to split the dataset as a trainning set and testing set. The goal is to train the model with trainning set and test the model with the testing set. Here I use 75% of the data my trainning set and 25% left as my testing set.

```
Intrain<-createDataPartition(y=titanic[,1],p=0.75,list=FALSE)
trainning<-titanic[Intrain,]
testing<-titanic[-Intrain,]
```

## Exploring the dataset


















