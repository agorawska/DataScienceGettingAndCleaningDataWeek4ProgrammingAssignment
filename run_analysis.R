library(reshape2)

####################################################################################
#STEP 1 - loading datasets and merging training and tests sets to create one dataset
####################################################################################

fileName <- "getdata_dataset.zip"

## checks if datasets are available in the current working directory
if (!file.exists(fileName)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, fileName, method="auto")
}  
#checks if datasets were unzipped - generally if we can access it 
if (!file.exists("UCI HAR Dataset")) { 
  unzip(fileName) 
}

#loading training dataset  
trainSet <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivityLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

#creating one data set for the training dataset
trainData <- cbind(trainSubjects,trainActivityLabels,trainSet)

#loading test dataset
testSet <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivityLabels <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

#creating one data set from the test dataset
testData <- cbind(testSubjects,testActivityLabels, testSet)

#merging training and test datasets in one dataset
data <- rbind(trainData,testData)

####################################################################################
#STEP 2 - extracts only the measurements on the mean and standard deviation
####################################################################################

features <- read.table("UCI HAR Dataset/features.txt")

#renaming columns in the data using features.txt file
#in the features consecutive rows represent name of the measurement presented in
#test and training data where there is no heading pointing to those names
#that is why the column names in data are V1,V2 etc
colnames(features)<-c("id","name")

#renaming column names for more representative
#in both cases, train and test data, I have started with subject, followed by
#activity label (Y dataset) and the rest of data (x dataset) so the renaming vector
#is constructed the same way which is fact step4
#STEP 4 - approprietly labels the dataset with descriptive names 
colnames(data)<-c("subjectId","activityLabel",as.character(features[,"name"]))

#selecting features connected to mean or standard deviation (std) calculation
featuresSelected <- grep(".*mean.*|.*std.*",colnames(data))

#subsetting data - extracting mean and std related columns + subject and activityLabel
data <-data[,c(1,2,featuresSelected)]

####################################################################################
#STEP 3 - renaming activity names to descriptive names using activity_labels.txt
####################################################################################

activityLabels <-read.table("UCI HAR Dataset/activity_labels.txt")

#activityLabel in data matches the first column in the activityLabels data.frame
#because the number of possible activities is 'limited' it is resonable to change
#activityLabel into a factor - which in parallel will match names of activities with 
#their id's in data 
data$activityLabel <- factor(data$activityLabel, levels = activityLabels[,1], labels = activityLabels[,2])

####################################################################################
#STEP 5 - TIDYING DATASET + calculating averages of each variable for each activity and subject
####################################################################################

#creating factor from subject id
data$subjectId <- as.factor(data$subjectId)

avgData<-melt(data,id=c("subjectId","activityLabel"))
avgData<-dcast(avgData,subjectId + activityLabel ~ variable, mean)

#writing final dataset into a txt file
write.table(avgData,"averaged_data.txt",row.name = FALSE)
