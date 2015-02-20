## Getting and Cleaning Data

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. There is required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.   
  
One of the most exciting areas in all of data science right now is wearable computing - see for example this article. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:  
  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
  
Here are the data for the project:  

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

There is R script called run_analysis.R that does the following.  

#### 1. Merges the training and the test sets to create one data set.
```{r eval=FALSE}
data = read.table('~/dataAnalysis/UCI HAR Dataset/train/X_train.txt', header = F)
data = rbind(data, read.table('~/dataAnalysis/UCI HAR Dataset/test/X_test.txt', header = F))
pom = read.table('~/dataAnalysis/UCI HAR Dataset/train/subject_train.txt', header = F)
pom = rbind(pom, read.table('~/dataAnalysis/UCI HAR Dataset/test/subject_test.txt', header = F))
data$subject = pom
pom = read.table('~/dataAnalysis/UCI HAR Dataset/train/y_train.txt', header = F)
pom = rbind(pom, read.table('~/dataAnalysis/UCI HAR Dataset/test/y_test.txt', header = F))
data$activity = pom
```
#### 2. Uses descriptive activity names to name the activities in the data set
```{r eval=FALSE}
data[data$activity == 1, 'activity'] = 'WALKING'
data[data$activity == 2, 'activity'] = 'WALKING_UPSTAIRS'
data[data$activity == 3, 'activity'] = 'WALKING_DOWNSTAIRS'
data[data$activity == 4, 'activity'] = 'SITTING'
data[data$activity == 5, 'activity'] = 'STANDING'
data[data$activity == 6, 'activity'] = 'LAYING'
```
#### 3. Appropriately labels the data set with descriptive variable names.
```{r eval=FALSE}
nam = read.table('~/dataAnalysis/UCI HAR Dataset/features.txt')
nam = make.names(names = nam$V2, unique = T)
nam = gsub(pattern = '...',replacement = '',x = nam,fixed = T)
nam = gsub(pattern = '..',replacement = '',x = nam,fixed = T)
colnames(data) = nam
```
#### 4. Extracts only the measurements on the mean and standard deviation for each measurement. 
```{r eval=FALSE}
data = data[ ,c(which(grepl('std',nam)), which(grepl('mean',nam)), 562, 563)]
colnames(data)[80]  = 'subject'
colnames(data)[81]  = 'activity'
```
#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```{r eval=FALSE}
library(data.table)
DT = data.table(data)
pom = DT[, lapply(.SD, sum, na.rm=T), by=c('subject','activity')]
write.table(pom, file = '~/dataAnalysis/tidy.txt', row.names = F)
```