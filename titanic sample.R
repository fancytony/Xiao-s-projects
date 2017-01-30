library(caret)
library(fields)
#set the directary

setwd("/Users/xiaoyin/Dropbox/data\ science\ job/my\ R\ projects")
titanic<-read.table("titanic_train.csv",sep=",",header=TRUE)
head(titanic)

#remove the null 
sum(is.na(titanic))

titanic<-na.omit(titanic)
set.seed(123)

#split the dataset as trainning and testing by 75percent and 25percent
Intrain<-createDataPartition(y=titanic[,1],p=0.75,list=FALSE)
dim(titanic)


dim(titanic)
trainning<-titanic[Intrain,]
testing<-titanic[-Intrain,]
dim(trainning)
str(titanic)

#check near zero variance predictors
nzv <- nearZeroVar(trainning)

#check high correlation factors
titanicTemp<-cbind(trainning$Pclass, trainning$Age, trainning$SibSp, trainning$Parch, trainning$Fare)
titanicTempCor<-cor(titanicTemp)
titanicTempCor
highCorr <- sum(abs(titanicTempCor[upper.tri(titanicTempCor)]) > .8)

#explore the dataset relationship between predictors.
bplot.xy(titanic$Survived, titanic$Fare)


#check how many levels under each predictor
z<-cbind.data.frame(Var=names(trainning), Total_Class=sapply(trainning,function(x){as.numeric(length(levels(x)))}))
print(z)

#Important! change Survived to Factor, use classification instead of regression.
trainning$Survived <- factor(trainning$Survived)

#start modeling process. first set the train control method as repeated CV

ctrl <- trainControl(method = "repeatedcv", repeats = 3)
rfFit<-train(Survived~Pclass + Sex + SibSp + Embarked + Parch + Fare,data=trainning,method="rf",trControl=ctrl,tuneLength=5,preProc=c("center", "scale"))
rfFit
plot(rfFit)
#ue model to predict the testing set result
rfClasses <- predict(rfFit, newdata = testing)

confusionMatrix(data=rfClasses,testing$Survived)
#plot the importance diagram
> plot(varImp(rfFit),main="Random Forest - Variable Importance Plot")

#use another method--LDA to model the same dataset and compare
ldaFit<-train(Survived~Pclass + Sex + SibSp + Embarked + Parch + Fare,data=trainning,method="lda",trControl=ctrl,tuneLength=5,preProc=c("center", "scale"))

ldaFit
ldaClasses <- predict(ldaFit, newdata = testing)

confusionMatrix(data=ldaClasses,testing$Survived)
resamps <- resamples(list(rf = rfFit, lda = ldaFit))
summary(resamps)
xyplot(resamps, what = "BlandAltman") 
diffs <- diff(resamps)
summary(diffs)




