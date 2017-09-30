# DataScienceGettingAndCleaningDataWeek4ProgrammingAssignment
Data Science course no 4: GettingAndCleaningData - Final Programming Assignment

This repository represents final programming assignment connected to getting and cleaning data. It contains folllowing files:
1. script run_analysis.R - downloads data and creates tidy data set
2. averaged_data.txt - tidy data set created as a result of run_analysis.R script
3. code_book.md - summarizes all data processing and analysis that lead to creating tidy dataset

Script run_analysis.R performs operations in the following manner:
1. Downloads data if not present in the working directory
2. Loads datasets and merging training and tests sets to create one dataset
3. Subsets given dataset - extracts only the measurements on the mean and standard deviation
4. Renames activity names to descriptive names using activity_labels.txt
5. Tidying dataset + calculating averages of each variable for each activity and subject
6. Writes final dataset into a txt file: averaged_data.txt