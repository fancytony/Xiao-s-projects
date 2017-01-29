# Xiao-s-projects
My data science projects
## Machine learning is EASY! 


As I said in [Becoming a data hacker](http://will-stanton.com/becoming-an-effective-data-hacker/), R is an awesome programming language for data analysts, especially for people just getting started. In this post, I will give you a super quick, very practical, theory-free, hands-on intro to writing a simple classification model in R, using the *caret* package.

## The caret package

One of the biggest barriers to learning for budding data scientists is that there are so many different R packages for machine learning. Each package has different functions for training the model, different functions for getting predictions out of the model and different parameters in those functions. So in the past, trying out a new algorithm was often a huge ordeal. The [caret package](http://caret.r-forge.r-project.org/) solves this problem in an elegant and easy-to-use way. Caret contains wrapper functions that allow you to use the exact same functions for training and predicting with dozens of different algorithms. On top of that, it includes sophisticated built-in methods for evaluating the effectiveness of the predictions you get from the model. I recommend that you do all of your machine-learning work in caret, at least as long as the algorithm you need is supported. There's a nice little intro paper to caret [here](http://www.jstatsoft.org/v28/i05).

## The Titanic dataset

Most of you have heard of a movie called Titanic. What you may not know is that the movie is based on a real event, and Leonardo DiCaprio was not actually there. The folks at [Kaggle](http://www.kaggle.com) put together a dataset containing data on who survived and who died on the Titanic. The challenge is to build a model that can look at characteristics of an individual who was on the Titanic and predict the likelihood that they would have survived. There are several useful variables that they include in the [dataset](https://www.kaggle.com/c/titanic-gettingStarted) for each person: 
- pclass: passenger class (1st, 2nd, or 3rd)
- sex
- age
- sibsp: number of Siblings/Spouses Aboard
- parch: number of Parents/Children Aboard
- fare: how much the passenger paid
- embarked: where they got on the boat (C = Cherbourg; Q = Queenstown; S = Southampton)

## So what is a classification model anyway?

For our purposes, *machine learning* is just using a computer to "learn" from data. What do I mean by "learn?" Well, there are two main different possible types of learning:
- supervised learning: Think of this as pattern recognition. You give the algorithm a collection of labeled examples (a *training set*), and the algorithm then attempts to predict labels for new data points. The Titanic Kaggle challenge is an example of supervised learning, in particular *classification*. 
- unsupervised learning: Unsupervised learning occurs when there is no training set. A common type of unsupervised learning is *clustering*, where the computer automatically groups a bunch of data points into different "clusters" based on the data. 

## Installing R and RStudio

In order to follow this tutorial, you will need to have R set up on your computer. Here's a link to a download page: [Inside R Download Page](http://www.inside-r.org/download). I also recommend RStudio, which provides a simple interface for writing and executing R code: download it [here](http://www.rstudio.com/products/RStudio/#Desk). Both R and RStudio are totally free and easy to install. 

## Installing the required R packages

Go ahead and open up RStudio (or just R, if you don't want to use RStudio). For this tutorial, you need to install the *caret* package and the *randomForest* package (you only need to do this part once, even if you repeat the tutorial later).

```{r, eval = FALSE}
install.packages("caret", dependencies = TRUE)
install.packages("randomForest")
```

## Loading the required R packages

Now we have to load the packages into the working environment (unlike installing the packages, this step has to be done every time you restart your R session).

```{r, warning = FALSE, message = FALSE}
library(caret)
library(randomForest)
