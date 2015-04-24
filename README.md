# GettingCleaning
This is an R Markdown document that covers the necessary information for interpreting run_analysis.R, which tidies a large dataset from wearable smartphone users. The dataset tidy_data is essentially an average of averages which reports the mean of the means/standard deviations in the original dataset for each activity for each subject.

How the code works:
After loading the appropriate libraries, we begin by reading in all of the data. Originally, the data was split into two sets, so we read in the subject, set, and labels for each set (dubbed "training" and "test"). We also read in a document called features.txt, which contains all of the labels for the measurements.

Once the files are read into R, we merge test and training into a single large dataset with a series of rbind commands.

We use grep to select only the mean and standard deviation (std) values from the dataset, then cbind those data with the subject and activity values.

Multiple gsub (mgsub) replaces the activity ID numbers with the appropriate names (although first the column must be converted from int to chr with as.character).

Finally, the tidy dataset is created by grouping by subject, followed by activity, and taking the mean for each subject/activity pair with summarise_each(funs(mean)). The result is exported to a txt file with write.table.
