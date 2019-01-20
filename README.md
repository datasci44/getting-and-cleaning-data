# getting-and-cleaning-data
JHU Data Science Specialization. Course 3, Week 4. Programming Assignment.

The script in [run_analysis.R](run_analysis.R) takes raw Samsung Galaxy S II accelerometer data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and does the following:

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement.

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

[Raw Files](raw_files) referenced in the script have been cloned to the github repo.

The script generates a single output file, [train_test_averages.txt](train_test_averages.txt), with the tidy data set specified in step #5.

See repo file [CodeBook.md](CodeBook.md) for a code book that describes the data, the variables, and work performed to clean up the data.
