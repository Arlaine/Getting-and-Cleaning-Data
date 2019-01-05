> setwd("~/R/Getting and Cleaning Data/UCI HAR Dataset")
> library(plyr)
> library(data.table)


> #1 Merges the training and the test sets to create one data set

> Train = read.table('./train/subject_train.txt',header=FALSE)
> xTrain = read.table('./train/x_train.txt',header=FALSE)
> yTrain = read.table('./train/y_train.txt',header=FALSE)
> Test = read.table('./test/subject_test.txt',header=FALSE)
> xTest = read.table('./test/x_test.txt',header=FALSE)
> yTest = read.table('./test/y_test.txt',header=FALSE)
> xDataSet <- rbind(xTrain, xTest)
> yDataSet <- rbind(yTrain, yTest)
> DataSet <- rbind(Train, Test)


> #2 Extracts only the measurements on the mean and standard deviation for each measurement

> xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
> names(xDataSet_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2]
> View(xDataSet_mean_std)


> #3 Uses descriptive activity names to name the activities in the data set

> yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
> names(yDataSet) <- "Activities"
> View(yDataSet)


> #4 Appropriately labels the data set with descriptive variable names
  
> names(DataSet) <- "Label"
> summary(DataSet)
> combineActivity <- cbind(xDataSet_mean_std, yDataSet, DataSet)

> names(combineActivity) <- make.names(names(combineActivity))
> names(combineActivity) <- gsub('Gyro', "Gyroscope", names(combineActivity))
> names(combineActivity) <- gsub('Acc', "Accelaration", names(combineActivity))
> names(combineActivity) <- gsub('Mag', "Magnitude", names(combineActivity))
> names(combineActivity) <- gsub('Freq', "Frequency", names(combineActivity))
> names(combineActivity) <- gsub('mean', "Average", names(combineActivity))
> names(combineActivity) <- gsub('std', "StandardDeviation", names(combineActivity))
> names(combineActivity) <- gsub('^t', "TimeDomain", names(combineActivity))
> names(combineActivity) <- gsub('^f', "FrequencyDomain", names(combineActivity))
> View(combineActivity)
  

> #5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
  
> SecondData<-aggregate(. ~Activities + Label, combineActivity, mean)
> SecondData<-SecondData[order(SecondData$Activities, SecondData$Label),]
> write.table(SecondData, file="tidydata.text", row.names=FALSE)
> 
  
