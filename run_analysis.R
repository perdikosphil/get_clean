# Load dependencies ----
library(tidyverse)

# Read Files ----
## Read label/feature info ----
feature_names <- read.table(file = "data/features.txt")
activity_names <- read.table(file = "data/activity_labels.txt")[,2]

## Read training data ----
subject_train <- read.table(file = "data/train/subject_train.txt")
activity_train <- read.table(file = "data/train/y_train.txt")
feature_train <- read.table(file = "data/train/X_train.txt")

## Read test data ----
subject_test <- read.table(file = "data/test/subject_test.txt")
activity_test <- read.table(file = "data/test/y_test.txt")
feature_test <- read.table(file = "data/test/X_test.txt")

# Organize Data Structure ----
## Assemble training dataset ----
train <- bind_cols(subject = subject_train, # bind train columns
                   activity = activity_train,
                   feature_train)
rm(subject_train, activity_train, feature_train) # rm file vectors

## Assemble test dataset ----
test <- bind_cols(subject_test, # bind test columns
                  activity_test,
                  feature_test)
rm(subject_test, activity_test, feature_test) # rm file vectors

## 1. Merge train and test sets ----
merged_data <- rbind(train, test)
names(merged_data)[1:3] <- c("subject", "activity", "V1")
rm(train, test)

# Cleaning Data ----
## Clean names/labels ----
# Removing punctuation with gsub() and regex
feature_names_clean <- gsub("-|\\(|\\)", "", feature_names$V2) %>%
    gsub(",", "_", .) %>%
    gsub("^t", "time", .) %>%
    gsub("^anglet", "angletime", .) %>%
    gsub("^anglef", "anglefreq", .) %>%
    gsub("^f", "freq", .)
rm(feature_names) # rm file vector

## 4. Descriptive variable names ----
names(merged_data)[3:563] <- feature_names_clean

## 2. Extract only mean and std entries for each measurement ----
# note regex phrasing to exclude instances of "meanFreq()"
mean_std <- merged_data %>%
    select(matches("subject|activity|mean$|mean[x-zX-Z]|std"))
# glimpse(mean_std)

## 3. Set clear/descriptive labels for activity factor ----
mean_std$activity <- factor(mean_std$activity, 
                            levels = c(1:6),
                            labels = activity_names)

## 5. Create separate tidy dataset with averages for each subject/activity ----
# I'm unclear as to whether "average of each variable" in the context of this question
# means "mean of each measurement" or "average of each column." The code below yields
# the latter, but uncommenting the select() call will exclude standard deviation cols.
grouped_avg <- mean_std %>%
    #select(!matches("std")) %>%
    group_by(subject, activity) %>%
    summarize(across(everything(), mean))
# glimpse(grouped_avg)

# Export ----
write.table(grouped_avg, "data/tidydata.txt", row.names = FALSE)
rm(grouped_avg, mean_std, merged_data, activity_names, feature_names_clean)
