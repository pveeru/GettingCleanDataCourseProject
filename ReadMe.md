##Intro to my run_analysis.R script

* run_analysis.R is a script file that downloads the project's data zip file 
  and creates/writes a txt file of a Tidy Data set of the average of means & std of
  each activity's features of each participant (identified as a subject id)

* The script requires the plyr and reshape2 libraries

* I assume that the data zip has been downloaded to the working dir already. But if needed
  please uncomment the file download section for doing this.

* Please save the unzipped data in a subfolder called "Data" in the working dir. Also please create a
  subfolder called "Final" in the working dir to house the run_analysis.r script and the Tiday data output

###The following sections details the workings of the run_analysis.R script file

1.The test data and train data is read using the read.table function.
2.The test data and train data are pasted togther next, using the rbind function
3.The features.txt is read in next, and is used to put n as the column names for the data.
4.The features related to mean() and std() are filtered out next, to give a prunned down 66 columns 
  (out of a total of 561). This is done using the grepl function on the features.
5.The activity labels are read in next and matched up to the activity Id in the data using the merge function.
6.An intermediate version of the Good data is created by cbinding the SubjectIds and activity labels and data
7.Tidy data is then created using the melt function and ddply, as described below:
8.Tidy data summarizes the avaerage of each feature per activity per subject, giving a total 2310 obs.
9.A text file TidyData.txt is written out.
