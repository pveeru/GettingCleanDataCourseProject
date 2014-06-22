##run_analysis.R is a script file that downloads the project's data zip file 
##and creates/writes a txt file of a Tidy Data set of the average of means & std of
##easch activity's features of each participant (identified as a subject id)

#Below are the two required libraries to run this code
require(plyr)
require(reshape2)

##Uncomment this section if a new download of the data is required. Else it is assumed that the 
##unzipped data is availabe in the working dir.
# fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl,"rawData.zip")
# unzip("rawData.zip",exdir=Data)
# rm(fileUrl)

##The test data & train data is read in variables in the section below
testFolder<-"Data/UCI HAR Dataset/test/"
x_test_data<-read.table(paste(testFolder,"X_test.txt",sep=""))
y_test_data<-read.table(paste(testFolder,"Y_test.txt",sep=""))
subject_test<-read.table(paste(testFolder,"subject_test.txt",sep=""))
rm(testFolder)

trainFolder<-"Data/UCI HAR Dataset/train/"
x_train_data<-read.table(paste(trainFolder,"X_train.txt",sep=""))
y_train_data<-read.table(paste(trainFolder,"y_train.txt",sep=""))
subject_train<-read.table(paste(trainFolder,"subject_train.txt",sep=""))
rm(trainFolder)
##End of data read

##The test data and train data is put together using rbind
x_data<-rbind(x_test_data,x_train_data)
y_data<-rbind(y_test_data,y_train_data)
subject<-rbind(subject_test,subject_train)
colnames(subject) <-c("SubjectId")
rm(x_test_data,y_test_data,subject_test,x_train_data,y_train_data,subject_train)
##End of putting the data sets together

##The feature names (i.e. the column names) are read in and put into the data variable
features<-read.table("Data/UCI HAR Dataset/features.txt")
colnames(x_data) <-features[,"V2"]
##End of putting col names 

##Only the mean and std related features are needed. The following gets a logical array 
##using the features to give this info. An intermediate good data is created containing these 
##relevant columns
getMeanStdOnly<-grepl('mean\\(\\)|std\\(\\)',features[,"V2"])
x_Gooddata<-x_data[,getMeanStdOnly]
rm(features,getMeanStdOnly)
##End of creating intermediate Good data.

##Activity labels are read in and matched up with the activity id array (y_data) using merge
##to create the data_Label array which contains the row by row desc. of each activity in 
##Good data. This is inturn pasted onto the Good data using cbind. This step fully creates the
##Good data for final use.
ActvityLabels<-read.table("Data/UCI HAR Dataset/activity_labels.txt")
data_Labels<-merge(y_data,ActvityLabels,by.y_data="V1",by.ActivityLabels="V2",all=TRUE)
colnames(data_Labels)<-c("Id","Activity")
rm(ActvityLabels,x_data,y_data)

x_Gooddata <- cbind(subject$SubjectId,data_Labels$Activity,x_Gooddata)
x_Gooddata <- rename(x_Gooddata,replace=(c("subject$SubjectId"="SubjectId","data_Labels$Activity"="Activity")))
rm(subject,data_Labels)
##End of Good data for final use.

##Tidy data is created by 1) using the melt function on Good data along relevant filtered features,
##and 2) using ddply for summarizing the average of each feature by Subject for each Activity. This 
##Variable is written out as a text file fnially.
features_subset<-colnames(x_Gooddata)
features_subset<-features_subset[3:length(features_subset)]
tmp<-melt(x_Gooddata,measure.vars=features_subset)
TidyData<-ddply(tmp,.(SubjectId,Activity,variable),summarize,mean(value))
TidyData <- rename(TidyData,replace=(c("variable"="Feature","..1"="AverageValue")))
rm(tmp,features_subset)

write.table(TidyData,file="Final/TidyData.txt",quote=FALSE,sep=",",eol="\r\n",na="NA", dec=".", row.names=FALSE,col.names=TRUE)
##End of run_analysis.R