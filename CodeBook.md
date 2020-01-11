# Cleaning and Getting Data Course Programming Assignment Code Book



## Analysis process

The analysis script 'run_analysis.R' consists of a few parts and does following:
 * Initializing and Loading data to Environment: Reading the processed experiment data.  
 * PART I:   Merging the training and the test sets to create one and common data set.  
 * PART II:  Extracting only the measurements on the Mean and Standard deviation for each measurement.  
 * PART III: Renaming the activities in the data set using descriptive activity names.  
 * PART IV:  Labeling the data set with appropriate descriptive variable names.  
 * PART V:   Creating a second, independent tidy data set from Part IV with the average of each variable for each activity and each subject.  


Initially the data of features, activities and subjects training and test data are read into separate variables ('testD_XFeatures', 'testD_Activity', 'testD_Subjects', 'trainD_XFeatures', 'trainD_Activity', 'trainD_Subjects'). Later, in the part_I these variables are merged into common variable 'commD'.
Additionally, list of features names and activity labels are read and stored in 'featuresList', 'activityLabels'.

In the part II the 'commD' was filtered to keep only variables that consist 'mean()' and 'std()' character sequences. It was done by defining 'featuresList' indexes that correspond to the required conditions. The filtered data 'commD_MeanStdValues' was obtained by subsetting 'commD' by found indexes with shift of "2" because 1st and 2nd variables represent activity and subject id respectively. 

In the part III the 'activity' numeric data in the 'commD_MeanStdValues' was exchanged with activity descriptive names that are stored in the 'activityLabels' 1st and 2nd columns.

In the part IV descriptive names were applied for the feature variables (columns 3:end) of the data set 'commD_MeanStdValues'. The names were taken from 'featuresList_MeanStdValues' (the filtered feature names according to 'mean()'' and 'std()' names). Since the names consist of inappropriate symbols they were fixed by removing and exchanging these symbols.  
The variables names replacement was done according to the obtained indexes with correct names positions in the list of feature names.

In the part V was created second, independent tidy data set from Part IV 'Data_Averaged' with the average of each variable for each activity and each subject.
For this purpose the 'ddply' function from package 'plyr' was utilized.
'ddply' splited the data set according to 'activity' and 'subjectId' variables and applied anonymous function on it. Anonymous function ('ddply' paramenter .fun=) utilizes 'lapply' looping method with function 'mean' on each variable of the data set except of the 'activity' because it consists of 'char' values. The variable 'subjectId' is also averaged in order to crosscheck correctness of the code.

The data set from the PART V is saved to the 'run_analysis_output.txt' file.

For more information please see 'run_analysis.R' file

## Output data file description

The columns in the 'run_analysis_output.txt' file are listed below:  
1. activityLabels - The name of the activity of a measurements. Can be one of the following values: 'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'  
1. subjectId - The id of the experiment participant, is in the range from 1 to 30.  

The following list of variables represent the average value of measurements of the recorded data points for the given subject and activity, as it is described in the part V of the R-script.

3. tBodyAccMeanX  
3. tBodyAccMeanY  
3. tBodyAccMeanZ  
3. tBodyAccStdX  
3. tBodyAccStdY  
3. tBodyAccStdZ  
3. tGravityAccMeanX  
3. tGravityAccMeanY  
3. tGravityAccMeanZ  
3. tGravityAccStdX  
3. tGravityAccStdY  
3. tGravityAccStdZ  
3. tBodyAccJerkMeanX  
3. tBodyAccJerkMeanY  
3. tBodyAccJerkMeanZ  
3. tBodyAccJerkStdX  
3. tBodyAccJerkStdY  
3. tBodyAccJerkStdZ  
3. tBodyGyroMeanX  
3. tBodyGyroMeanY  
3. tBodyGyroMeanZ  
3. tBodyGyroStdX  
3. tBodyGyroStdY  
3. tBodyGyroStdZ  
3. tBodyGyroJerkMeanX  
3. tBodyGyroJerkMeanY  
3. tBodyGyroJerkMeanZ  
3. tBodyGyroJerkStdX  
3. tBodyGyroJerkStdY  
3. tBodyGyroJerkStdZ  
3. tBodyAccMagMean  
3. tBodyAccMagStd  
3. tGravityAccMagMean  
3. tGravityAccMagStd  
3. tBodyAccJerkMagMean  
3. tBodyAccJerkMagStd  
3. tBodyGyroMagMean  
3. tBodyGyroMagStd  
3. tBodyGyroJerkMagMean  
3. tBodyGyroJerkMagStd  
3. fBodyAccMeanX  
3. fBodyAccMeanY  
3. fBodyAccMeanZ  
3. fBodyAccStdX  
3. fBodyAccStdY  
3. fBodyAccStdZ  
3. fBodyAccJerkMeanX  
3. fBodyAccJerkMeanY  
3. fBodyAccJerkMeanZ  
3. fBodyAccJerkStdX  
3. fBodyAccJerkStdY  
3. fBodyAccJerkStdZ  
3. fBodyGyroMeanX  
3. fBodyGyroMeanY  
3. fBodyGyroMeanZ  
3. fBodyGyroStdX  
3. fBodyGyroStdY  
3. fBodyGyroStdZ  
3. fBodyAccMagMean  
3. fBodyAccMagStd  
3. fBodyAccJerkMagMean  
3. fBodyAccJerkMagStd  
3. fBodyGyroMagMean  
3. fBodyGyroMagStd  
3. fBodyGyroJerkMagMean  
3. fBodyGyroJerkMagStd  

In these names:
 * f / t - prefix 't' or 'f' for time domain or frequency domain signals
 * Body / Gravity - stays for body or gravity signals. The gravity signals obtained from raw singnals by using low pass Butterworth filter with a corner frequency of 0.3 Hz. The body signal obtained by subtracting the gravity from the raw signals. 
 * Gyro / Acc - stays for gyroscope or accelerometer 3-axial raw signals
 * X / Y / Z - stays for 3-axial signals in the X, Y and Z directions
 * Mean / Std - stays for average or root-mean-square values of the performed window measurements
 * Jerk / Mag / JerkMag - stays for jerk, magnitude and magnitude of jerk values of the performed window measurements

The values from gyroscope 'Gyro' are in radians/second units.  
The values from accelerometer 'Acc' are in standard gravity units 'g'.  
Features are normalized and bounded within [-1,1].  

The detailed description of the different measurement types can be found in the features_info.txt file included in the "UCI HAR Dataset".

    

## More information

Detailed information on the experiment and the data can be found in the README.txt and features_info.txt files included in the experiment "UCI HAR Dataset".