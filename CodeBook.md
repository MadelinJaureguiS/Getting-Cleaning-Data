---
title: "CodeBook.md"
author: "MadelinJ"
date: "10/30/2020"
output: html_document
---

## Getting and Cleaning Data Course Project

The `run_analysis.R` file creates a tidy data set from the data contained in the given [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). For such purpose, the 5 steps, suggested in the course, were followed.

* **Download**: Data was downloaded, unziped, and stored localy. 

```{r}
library(dplyr)

file <- 'getdata_projectfiles_UCI HAR Dataset.zip'

if(!file.exists(file)) {
  fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(fileURL, file, method = 'curl')
}

if(!file.exists('UCI HAR Dataset')) {
  unzip(file)
}
```


* **Variables**: Each data file contained in the folder was assigned to a variable in the R environment. 

  1. The `feature` object (561 rows, 2 columns) corresponds to the data file containing the features selected for this database.
  
  2. The `activities` object (6 rows, 2 columns) stores the list of activities and their codes. 
  
  3. The `subtest`object (2947 rows, 1 column) contains data from test subjects.
  
  4. The `x_test` object (2947 rows, 561 columns) corresponds to the test set. 
  
  5. The `y_test`object (2947 rows, 1 columns) contains the test labels. 
  
  6. The `subtrain`object (7352 rows, 1 column) stores data from subjects being observed. 
  
  7. The `x_train` object (7352 rows, 561 columns) corresponds to the training set.
  
  8. The `y_train` object (7352 rows, 1 columns) corresponds to the training labels.

```{r}
features <- read.table('UCI HAR Dataset/features.txt', 
                       col.names = c('number', 'feature'))
activities <- read.table('UCI HAR Dataset/activity_labels.txt', 
                         col.names = c('code', 'activity'))

subtest <- read.table('UCI HAR Dataset/test/subject_test.txt', 
                      col.names = 'subject')
x_test <- read.table('UCI HAR Dataset/test/x_test.txt', 
                     col.names = features$feature)
y_test <- read.table('UCI HAR Dataset/test/y_test.txt', 
                     col.names = 'code')

subtrain <- read.table('UCI HAR Dataset/train/subject_train.txt', 
                      col.names = 'subject')
x_train <- read.table('UCI HAR Dataset/train/x_train.txt', 
                     col.names = features$feature)
y_train <- read.table('UCI HAR Dataset/train/y_train.txt', 
                     col.names = 'code')
```

* **Merges the training and the test sets to create one data set**

  1. The `x`object (10299 rows, 561 columns) was created by merging the `x_test` and the `x_train` objects.
  
  2. The `y`object (10299 rows, 1 column) was created by merging the `y_test` and the `y_train` objects.
  
  3. The `subject`object (10299 rows, 1 column) was created by binding the rows in the `subtest` and `subtrain` objects. 
  
  4. The `data`object (10299 rows, 563 column) was created by binding the columns from the `x`, `y` and `subject`objects. 

```{r}
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subtest, subtrain)
data <- cbind(x, y, subject)
```

* **Extracts only the measurements on the mean and standard deviation for each measurement**

`tidy` (10299 rows, 88 columns) was created by selecting the `subject` and `code` columns from the `data`object, as well as the `mean`and `std`for each measurement.

```{r}
tidy <- data %>% select(subject, code, contains("mean"), contains("std"))
```


* **Uses descriptive activity names to name the activities in the data set**

The `code`column, which contained the activity code, from `tidy` was replaced with the activity names taken from the second column in the `activities` object. 

```{r}
tidy$code <- activities[tidy$code, 2]
```


* **Appropriately labels the data set with descriptive variable names**

The variables were labeled with descriptive names. Therefore, the `code`variable in the `tidy` data set was renaimed into `activities`. Likewise, the `Acc`variables was renaimed into `accelerometer`, the `Gyro`variable was named into `gyroscope`and so on. 

```{r}
names(tidy)[2] <- 'activity'
names(tidy) <- gsub('Acc', 'accelerometer', names(tidy), ignore.case = T)
names(tidy) <- gsub('Gyro', 'gyroscope', names(tidy), ignore.case = T)
names(tidy) <- gsub('BodyBody', 'Body', names(tidy), ignore.case = T)
names(tidy) <- gsub('Mag', 'Magnitude', names(tidy), ignore.case = T)
names(tidy) <- gsub('^t', 'time', names(tidy), ignore.case = T)
names(tidy) <- gsub('^f', 'frequency', names(tidy), ignore.case = T)
names(tidy) <- gsub('tBody', 'time body', names(tidy), ignore.case = T)
names(tidy) <- gsub('-mean()', 'mean', names(tidy), ignore.case = T)
names(tidy) <- gsub('-std()', 'SD', names(tidy), ignore.case = T)
names(tidy) <- gsub('-freq()', 'frequency', names(tidy), ignore.case = T)
names(tidy) <- gsub('angle', 'angle', names(tidy), ignore.case = T)
names(tidy) <- gsub('gravity', 'gravity', names(tidy), ignore.case = T)
```


* **From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject**

The `tidy` data set was grouped by `subject`and `activity`. Then, the `data2`object (180 rows, 88 columns) was created by taking the means of each variable for each activity and each subject. Finally, the new `data2` was exported into a file named run_analysis.txt. 

```{r}
data2 <- tidy %>% group_by(subject, activity) %>% summarise_all(funs(mean))

write.table(data2, 'run_analysis.txt', row.names = F)

data2
```



