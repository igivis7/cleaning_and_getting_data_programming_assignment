#===========================================================
#===========================================================
#===========================================================
# The script consists of a few steps:
# - Initializing and Loading data to Environment
#   - Output: variables: 
# 					'featuresList'
# 					'activityLabels'
# 					'testD_XFeatures' 
# 					'testD_Activity'  
# 					'testD_Subjects'  
# 					'trainD_XFeatures'
# 					'trainD_Activity' 
# 					'trainD_Subjects' 
# - PART I:   Merging the training and the test sets to create one and common data set: commD
#   - Output: the common data set 'commD'
# - PART II:  Extracting only the measurements on the Mean and Standard deviation for each measurement.
#   - Output: filtered common data set 'commD_MeanStdValues'
# - PART III: Renaming the activities in the data set using descriptive activity names.
#   - Output: renamed the activities in 'commD_MeanStdValues'
# - PART IV:  Labeling the data set with appropriate descriptive variable names.
#   - Output: descriptive variable names of the 'commD_MeanStdValues' data set
# - PART V:   Creating a second, independent tidy data set from Part IV 
#             with the average of each variable for each activity and each subject.
#   - Output: 'Data_Averaged' data set
#===========================================================
#===========================================================
#===========================================================


#-----------------------------------------------------------
####### Initializing and Loading data to Environment #######
#-----------------------------------------------------------
# clean environment
rm(list=ls())

# set working directory
setwd("/home/user_name/R/Getting_and_Cleaning_Data_Course_Project/")

# define relative path to the folder with data
data_Location = "./UCI HAR Dataset"

featuresList       <- read.table(file=paste(data_Location, "/features.txt",            sep=""), sep = "", header = FALSE)
activityLabels     <- read.table(file=paste(data_Location, "/activity_labels.txt",     sep=""), sep = "", header = FALSE)

# Loading test data set
testD_XFeatures    <- read.table(file=paste(data_Location, "/test/X_test.txt",         sep=""), sep = "", header = FALSE)
testD_Activity     <- read.table(file=paste(data_Location, "/test/y_test.txt",         sep=""), sep = "", header = FALSE)
testD_Subjects     <- read.table(file=paste(data_Location, "/test/subject_test.txt",   sep=""), sep = "", header = FALSE)

# Loading training data set
trainD_XFeatures   <- read.table(file=paste(data_Location, "/train/X_train.txt",       sep=""), sep = "", header = FALSE)
trainD_Activity    <- read.table(file=paste(data_Location, "/train/y_train.txt",       sep=""), sep = "", header = FALSE)
trainD_Subjects    <- read.table(file=paste(data_Location, "/train/subject_train.txt", sep=""), sep = "", header = FALSE)

#---------------------
####### PART I #######
#---------------------
# Merging the training and the test sets to create one and common data set: commD

# merging rows
commD_XFeatures <- rbind(testD_XFeatures, trainD_XFeatures)
commD_Activity  <- rbind(testD_Activity, trainD_Activity)
commD_Subjects  <- rbind(testD_Subjects, trainD_Subjects)

# merging columns
commD           <- cbind( activity=commD_Activity$V1 ,  subjectId=commD_Subjects$V1 , commD_XFeatures )
# commD is the common data set

#----------------------
####### PART II #######
#----------------------
# Extracting only the measurements on the Mean and Standard deviation for each measurement.

# Extracting indexes
indexMean    <- grep("mean\\(\\)",featuresList$V2)
indexStd     <- grep("std\\(\\)",featuresList$V2)
indexMeanStd <-sort(c(indexMean, indexStd))

# Filtering list of features according to the indexes
featuresList_MeanStdValues <- featuresList[indexMeanStd,]

# Filtering common data according to the indexes
commD_MeanStdValues <- commD[, c(1, 2, indexMeanStd+2)]

#-----------------------
####### PART III #######
#-----------------------
# Renaming the activities in the data set using descriptive activity names.

commD_MeanStdValues[,1] <- activityLabels[ commD_MeanStdValues[,1], 2 ]

#----------------------
####### PART IV #######
#----------------------
# Labeling the data set with appropriate descriptive variable names.

# Preparation list of features for using it as variables names by replacement unnecessary symbols and fixing names.
featuresList_MeanStdValues_Fixed     <- featuresList_MeanStdValues
featuresList_MeanStdValues_Fixed[,2] <- gsub(  "\\(\\)", "",     featuresList_MeanStdValues_Fixed[,2] )
featuresList_MeanStdValues_Fixed[,2] <- gsub(     "std", "Std",  featuresList_MeanStdValues_Fixed[,2] )
featuresList_MeanStdValues_Fixed[,2] <- gsub(    "mean", "Mean", featuresList_MeanStdValues_Fixed[,2] )
featuresList_MeanStdValues_Fixed[,2] <- gsub(       "-", "",     featuresList_MeanStdValues_Fixed[,2] )
featuresList_MeanStdValues_Fixed[,2] <- gsub("BodyBody", "Body", featuresList_MeanStdValues_Fixed[,2] )

# Obtaining existing / old variables names 
commD_MeanStd_Labels_old   <- names(commD_MeanStdValues)

# Extracting indexes of the variables names for correct names replacement
# To make comparison (and indexes extraction) the default variables names are converted to numbers by removing "V" letter
indexFeaturesCorrection    <- which( as.numeric(sub("V", "", names(commD_MeanStdValues)[-(1:2)])) == featuresList_MeanStdValues_Fixed[,1]   )

# Variables names replacement according to the obtained indexes
# The 1st two variable names must be untouched
names(commD_MeanStdValues) <- c(commD_MeanStd_Labels_old[1:2], featuresList_MeanStdValues_Fixed[indexFeaturesCorrection,2])

#---------------------
####### PART V #######
#---------------------
# Creating a second, independent tidy data set from Part IV 
# with the average of each variable for each activity and each subject.

# Common data set with averaged values of variables for each group by:
# - ddply splits the data set according to "activity" and "subjectId" variables and applies anonymous function on it
# - anonymous function (ddply paramenter .fun=) utilizes 'lapply' looping method with function 'mean' on each variable 
#   of the data set except of the "activity" because it consists of "char" values.
#   The variable "subjectId" is also averaged in order to crosscheck correctness of the code
Data_Averaged <- plyr::ddply(
	.data = commD_MeanStdValues, 
    .variables = c("activity", "subjectId"), 
    .fun = function(x){  as.data.frame(lapply(x[,-1], mean)) }
    )

#-----------------------------------------
# Writing data 'Data_Averaged' to a file
write.table(Data_Averaged, file="run_analysis_output.txt", row.name=FALSE)
