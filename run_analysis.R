# run_analysis.R
# JHU Data Science Specialization
# Programming Assignment: Course 3 Week 4
# Getting and Cleaning Data

library(tidyverse)

setwd("/cloud/project")

# Load activity labels & features

activity_labels <- readr::read_delim(file = "raw_files/UCI HAR Dataset/activity_labels.txt",
                                     delim = " ", 
                                     col_names = FALSE) %>%
  rename(class_label = X1,
         activity_name = X2)

features <- readr::read_delim(file = "raw_files/UCI HAR Dataset/features.txt",
                              delim = " ",
                              col_names = FALSE) %>%
  rename(index = X1,
         feature_name = X2)

# Index columns with features wanted: mean() and std()

features_wanted <- grep("(mean|std)\\(\\)", 
                        features$feature_name)

# Load training data set

train <- read_table(file = "raw_files/UCI HAR Dataset/train/X_train.txt", col_names = FALSE)

colnames(train) <- features$feature_name

train <- train[, features_wanted] %>%
  janitor::clean_names(case = "snake")

train_labels <- read_table(file = "raw_files/UCI HAR Dataset/train/y_train.txt", col_names = FALSE) %>%
  rename(label = X1)  

train_subjects <- read_table(file = "raw_files/UCI HAR Dataset/train/subject_train.txt", col_names = FALSE) %>%
  rename(subject = X1)

train <- bind_cols(train, train_labels, train_subjects)

rm(train_labels)
rm(train_subjects)


# Load testing data set

test <- read_table(file = "raw_files/UCI HAR Dataset/test/X_test.txt", col_names = FALSE)

colnames(test) <- features$feature_name

test <- test[, features_wanted] %>%
  janitor::clean_names(case = "snake")

test_labels <- read_table(file = "raw_files/UCI HAR Dataset/test/y_test.txt", col_names = FALSE) %>%
  rename(label = X1)  

test_subjects <- read_table(file = "raw_files/UCI HAR Dataset/test/subject_test.txt", col_names = FALSE) %>%
  rename(subject = X1)

test <- bind_cols(test, test_labels, test_subjects)

rm(test_labels)
rm(test_subjects)
rm(features)
rm(features_wanted)

# Merge Training and Test Datasets

train_test <- bind_rows(train, test)

rm(train)
rm(test)

# Add activity name associated with label

train_test <- left_join(train_test, activity_labels, by = c("label" = "class_label")) %>%
  select(-label)

rm(activity_labels)

#glimpse(train_test)

#write_csv(train_test, "train_test_tidy.csv")


# Average of each variable for each activity and each subject

means <- train_test %>%
  group_by(activity_name, subject) %>%
  summarize_all(mean)

# View(means)

# write_csv(means, "train_test_averages_tidy.csv")
