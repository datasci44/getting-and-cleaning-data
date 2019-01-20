# run_analysis.R
# JHU Data Science Specialization
# Programming Assignment: Course 3 Week 4
# Getting and Cleaning Data


# Setup working environment ----------------

library(tidyverse)
setwd("/cloud/project")


# Load activity labels & features -----------------

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


# Index columns with wanted features: mean() and std() ----------

features_wanted <- grep("(mean|std)\\(\\)", 
                        features$feature_name)


# Load training data set ---------------

train <- read_table(file = "raw_files/UCI HAR Dataset/train/X_train.txt", col_names = FALSE)

colnames(train) <- features$feature_name  # add columns names from features.txt

train <- train[, features_wanted] %>%  # filter columns to wanted features
  janitor::clean_names(case = "snake")  # clean column names

train_labels <- read_table(file = "raw_files/UCI HAR Dataset/train/y_train.txt", col_names = FALSE) %>%
  rename(label = X1)  

train_subjects <- read_table(file = "raw_files/UCI HAR Dataset/train/subject_train.txt", col_names = FALSE) %>%
  rename(subject = X1)

train <- bind_cols(train, train_labels, train_subjects)  # merge 3 training data sources

rm(train_labels)  # remove stale files
rm(train_subjects)


# Load testing data set ---------------

test <- read_table(file = "raw_files/UCI HAR Dataset/test/X_test.txt", col_names = FALSE)

colnames(test) <- features$feature_name  # add columns names from features.txt

test <- test[, features_wanted] %>%  # filter columns to wanted features
  janitor::clean_names(case = "snake")  # clean column names

test_labels <- read_table(file = "raw_files/UCI HAR Dataset/test/y_test.txt", col_names = FALSE) %>%
  rename(label = X1)  

test_subjects <- read_table(file = "raw_files/UCI HAR Dataset/test/subject_test.txt", col_names = FALSE) %>%
  rename(subject = X1)

test <- bind_cols(test, test_labels, test_subjects)  # merge 3 test data sources

rm(test_labels)  # remove stale files
rm(test_subjects)
rm(features)
rm(features_wanted)


# Merge Training and Test Datasets ---------------

train_test <- bind_rows(train, test)

rm(train)  # remove stale files
rm(test)


# Add activity name associated with label ----------------

train_test <- left_join(train_test, activity_labels, by = c("label" = "class_label")) %>%
  select(-label)

rm(activity_labels)  # remove stale file

# glimpse(train_test)

# write_csv(train_test, "train_test_tidy.csv")  # option to write full train & test data to csv


# Question 5: Average of each variable for each activity and each subject ----------------

means <- train_test %>%
  group_by(activity_name, subject) %>%
  summarize_all(mean)

# View(means)

write.table(means, "train_test_averages.txt", row.names = FALSE)  # write means to text file as specified in assignment instructions

# write_csv(means, "train_test_averages_tidy.csv")  # tidyverse version of csv write