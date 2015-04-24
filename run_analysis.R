# Load the required libraries
library (XML)
library(httr)
library(gdata)
library(qdap)
library (dplyr)

# read in the training files
training_subjects <- read.table("train/subject_train.txt")
training_set <- read.table("train/X_train.txt")
training_labels <- read.table("train/y_train.txt")

# Read in the test files
test_subjects <- read.table("test/subject_test.txt")
test_set <- read.table("test/X_test.txt")
test_labels <- read.table("test/y_test.txt")

# read in features to get variable names
features <- read.table("features.txt")
varnames <- as.character(features[,2])

# Merge the test and training data sets
merged_subjects <- rbind(training_subjects, test_subjects)
merged_set <- rbind(training_set, test_set)
merged_labels <- rbind(training_labels, test_labels)

# rename variables from features and make them all lowercase (couldn't figure out how to get rid of pesky parentheses)
names(merged_set) <- tolower(varnames)

# Extract only the mean and standard deviation for each measurement
mean_std <- merged_set[,grep("[Mm]ean|[Ss]td",names(merged_set))]

# Tack on subject and activity to beginning of mean/std data frame
merged_all <- cbind(merged_subjects, merged_labels, mean_std)
colnames(merged_all) [1] <- "subject"
colnames(merged_all) [2] <- "activity"

# Replace activity numbers with names with a mutiple gsub
merged_all$activity <- as.character(merged_all$activity)
merged_all$activity <- mgsub(c("1", "2", "3", "4", "5", "6"), c("walking", "walking upstairs","walking downstairs", "sitting", "standing" , "laying"), fixed = FALSE, merged_all$activity)

# Create a tidy data set with the average of each variable for each activity and each subject
# 30 subjects*6 activities = 180 rows; 88 cols
tidy_data <- merged_all %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# Export tidy_data to a txt file
write.table(tidy_data, file = "tidy_data.txt", sep = " ", row.names = FALSE)
