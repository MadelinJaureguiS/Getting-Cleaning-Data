library(dplyr)

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

x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subtest, subtrain)
data <- cbind(x, y, subject)

tidy <- data %>% select(subject, code, contains("mean"), contains("std"))
tidy$code <- activities[tidy$code, 2]
