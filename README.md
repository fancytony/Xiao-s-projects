
#Naive Project Titanic!

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

```{r cars}
1+1
summary(cars)
```



```
setwd("/Users/xiaoyin/Dropbox/data\ science\ job/my\ R\ projects")
titanic<-read.table("titanic_train.csv",sep=",",header=TRUE)
head(titanic)
```
## Cleanning the dataset

The first thing I want to do is to observe whether there are missing data. This can be achieved by 
```
sum(is.na(titanic)
```
Seeing it has 172 NA values, for simplicity here I omit these missing vaues by
```
titanic<-na.omit(titanic)
```
## Splitting the dataset

The next thing I want to do, is to split the dataset as a trainning set and testing set. The goal is to train the model with trainning set and test the model with the testing set. Here I use 75% of the data my trainning set and 25% left as my testing set.

```
Intrain<-createDataPartition(y=titanic[,1],p=0.75,list=FALSE)
trainning<-titanic[Intrain,]
testing<-titanic[-Intrain,]
```

## Preprocessing and exploring the dataset

First I want to check the structure of the dataset, by which I use the following command:
```
str(titanic)
```
Now I see the names of the variables, as well as their structure ( for example the Survived is an integer variable). This is important for future modelling session.

Also I want to preprocess the data by checking whether there are near zero variance situations, which is usually harmful for modelling. To do that, I can
```
nzv <- nearZeroVar(trainning)
nzv
```
Since this dataset is very simple, there is no such near zero variance cases occuring. 

Another common issue is the dataset may contain collinerity, which is the case where two or more predictors are closely related such that including one of them is enough; while including all of them deteriorate our model. To check the  high correlation factors, I use the following commands:
```
titanicTemp<-cbind(trainning$Pclass, trainning$Age, trainning$SibSp, trainning$Parch, trainning$Fare)
titanicTempCor<-cor(titanicTemp)
titanicTempCor
highCorr <- sum(abs(titanicTempCor[upper.tri(titanicTempCor)]) > .8)
```
Still, since this is a very simple dataset, there is no such issue here as well.

Besides the summary function, I can also use the following function to see further the structure of the dataset, which tells me how many levels there are for each predictor (like 2 for Sex, male and female)
```
z<-cbind.data.frame(Var=names(trainning), Total_Class=sapply(trainning,function(x){as.numeric(length(levels(x)))}))
print(z)
```
R provides rich functions to explore the data. I can use some of them to further identify the relationship between the various predictors.
```
bplot.xy(titanic$Survived, titanic$Fare)
hist(titanic$Fare)
```

## Modelling the dataset

Now that we have preprocessed and explored the dataset, we now come to the modeling section.

The first thing I do is to decide whether this is a regression problem or classification problem. Clearly, our goal is to predict whether a passenger survived or not base on his/her characteristics like Fare/Sex/Embarked place…So it is obvious this is a classification problem. Nevertheless, from my earlier exploration, we see that the Survived predictor is recorded as integer, which means it will automatically select a regression model if I don’t change the variable type. To use the classification model (which is clearly more suitable in this case), I type the following command 
```
trainning$Survived <- factor(trainning$Survived)
```
which tells the system that Survived is actually a 0/1 two-class status (factor).

Now I can start the modeling process using classification scheme. 
```
ctrl <- trainControl(method = "repeatedcv", repeats = 3)
rfFit<-train(Survived~Pclass + Sex + SibSp + Embarked + Parch + Fare,data=trainning,method="rf",trControl=ctrl,tuneLength=5,preProc=c("center", "scale"))
rfFit
```
Here I first set the train control option in the caret library to use the repeated Cross-Validation approach. I then select the method of training to be “random forest” (rf), and the relevant predictors to be “Class, Sex, SibSp, Embarked, Parch, and Fare. The tuning promoter of this method, “mtry”, can have 5 possible values to choose from. The results are shown in Figs., which plot the accuarcy vs the running parameter and the variable importance for all the predictors used in the model.

```
plot(varImp(rfFit),main="Random Forest - Variable Importance Plot")
```



Having obtained the model, I can use it to predict the testing dataset to see how well our model behaves. 
```
rfClasses <- predict(rfFit, newdata = testing)

confusionMatrix(data=rfClasses,testing$Survived)
```
We see that this simple random forest method achieves an 80.68% accuracy, which is pretty impressive.


## Choosing a different model

The 80% accuracy seems to be good, although for sure it can be further improved, via for example, selecting the predictors more carefully, trying transforming the predictor in a clever way .etc. Here I want to try another different method, and compare them to see which is better. I use linear discrimant analysis (lda), a very common algorithm for classification problems, to contrast it with random forest.

```
ldaFit<-train(Survived~Pclass + Sex + SibSp + Embarked + Parch + Fare,data=trainning,method="lda",trControl=ctrl,tuneLength=5,preProc=c("center", "scale"))
ldaFit
ldaClasses <- predict(ldaFit, newdata = testing)
confusionMatrix(data=ldaClasses,testing$Survived)
```
We see the accuracy is 78.41%, slightly inferior to random forest. To compare them in further details, I use
```
resamps <- resamples(list(rf = rfFit, lda = ldaFit))
summary(resamps)
xyplot(resamps, what = "BlandAltman") 
diffs <- diff(resamps)
summary(diffs)
```
we see with the metric of accuracy, rf is slightly better than lda (around 2% higher accuracy), with a p-value of 0.2.




















