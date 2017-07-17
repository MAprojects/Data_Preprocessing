             ###############################################
             #  ***RUN_ANALYSIS script for course PROJECT***
             ###############################################

# Creating the object filename for kee`p the ziped fil.

filename <- "getdata_dataset.zip"

# Downloading the file if not exist yet.

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}

# Unziping the file 

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
# Load datasets 
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Merge all data wich contains the file 
Data <- rbind(train, test)
# Extract only the measurements on the mean and standard deviation for each ones

features <- read.table("UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
Data <- Data[, mean_and_std_features]

# correct the column names
names(Data) <- features[mean_and_std_features, 2]

# Use descriptive activity names to name the activities in the data set


activities <- read.table("UCI HAR Dataset\activity_labels.txt")

# update values with correct activity names
Data[, 1] <- activities[Data[, 1], 2]

# correct column name
names(Data) <- "activity"

# Appropriately label the data set with descriptive variable names

# correct column name
names(Data) <- "subject"
# install package plyr

install.packages("plyr")
library(plyr)

# Column means for all but the subject and activity columns

limitedColMeans <- function(Data) { colMeans(Data[,-c(1,2)]) }
tidyMeans <- ddply(tidy, .(Subject, Activity), limitedColMeans)
names(tidyMeans)[-c(1,2)] <- paste0("Mean", names(tidyMeans)[-c(1,2)])

# Write file

write.table(tidyMeans, "tidyMeans.txt", row.names = FALSE)
#################################################################################