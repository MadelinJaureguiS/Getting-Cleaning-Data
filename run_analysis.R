library(dplyr)

file <- 'getdata_projectfiles_UCI HAR Dataset.zip'

if(!file.exists(file)) {
  fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(fileURL, file, method = 'curl')
}

if(!file.exists('UCI HAR Dataset')) {
  unzip(file)
}

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


data2 <- tidy %>% group_by(subject, activity) %>% summarise_all(funs(mean))

write.table(data2, 'run_analysis.txt', row.names = F)

data2


