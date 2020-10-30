# Getting-Cleaning-Data

This repository contains multiple files used for complition of a course project in the Data Science Specialization offered by Johns Hopkins University in the Coursera platform. 

The [data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) used and other files such as: 

* `CodeBook.md`: A code book decsribing the code in the `run_analysis.R`file.

* `run_analysis.R`: This file containes the code used to create a tidy data set from the data contained in the given [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). For such purpose, the 5 steps, suggested in the course, were followed.

  1. Merges the training and the test sets to create one data set.
  
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
  
  3. Uses descriptive activity names to name the activities in the data set
  
  4. Appropriately labels the data set with descriptive variable names.
  
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

* `run_analysis.txt`: This file contains the exported tidy data set after following all the steps. 