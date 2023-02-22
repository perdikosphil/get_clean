# GetCleanData_PeerAssessment

Course project for "Getting and Cleaning Data," part of the Coursera/Johns Hopkins Data Science Specialization.

# run_analysis.R

If viewing in RStudio, I encourage you to refer to the outline to navigate the script. Note that the numbered sections do not appear in order, and are intended only as a reference to the assignment rubric.

The analysis script performs the following:
- Reads the training set, test set, and variable names from txt files.
- Binds the training and test measurements to their respective subjects/activities.
- Merges training and test data into one complete data set.
- Cleans up variable names to improve clarity and remove unwieldy characters.
- Correctly labels factor variable "activity" with descriptive levels.
- Selects only relevant mean/std measurements per assignment instructions.
- Groups by subject and activity to output a tidy dataframe with variable averages for each unique combination.

# Codebook

For detailed information on variables, levels, and feature names, see "CodeBook.md"