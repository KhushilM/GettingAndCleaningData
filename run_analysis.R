R version 3.1.1 (2014-07-10) -- "Sock it to Me"
Copyright (C) 2014 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> setwd('/Users/Khushil/Documents/UCI HAR Dataset/');
> ###Merges the training and the test sets to create one data set.
> features     = read.table('./features.txt',header=FALSE); #imports features.txt
> activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
> subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
> xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
> yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt
> colnames(activityType)  = c('activityId','activityType');
> colnames(subjectTrain)  = "subjectId";
> colnames(xTrain)        = features[,2]; 
> colnames(yTrain)        = "activityId";
> trainingData = cbind(yTrain,subjectTrain,xTrain);
> subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
> xTest       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
> yTest       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt
> colnames(subjectTest) = "subjectId";
> colnames(xTest)       = features[,2]; 
> colnames(yTest)       = "activityId";
> testData = cbind(yTest,subjectTest,xTest);
> finalData = rbind(trainingData,testData);
> colNames  = colnames(finalData); 
> ###Extracts only the measurements on the mean and standard deviation for each measurement. 
> logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));
> finalData = finalData[logicalVector==TRUE];
> ###Uses descriptive activity names to name the activities in the data set
> finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);
> colNames  = colnames(finalData); 
> ###Appropriately labels the data set with descriptive variable names. 
> for (i in 1:length(colNames)) 
+ {
+     colNames[i] = gsub("\\()","",colNames[i])
+     colNames[i] = gsub("-std$","StdDev",colNames[i])
+     colNames[i] = gsub("-mean","Mean",colNames[i])
+     colNames[i] = gsub("^(t)","time",colNames[i])
+     colNames[i] = gsub("^(f)","freq",colNames[i])
+     colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
+     colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
+     colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
+     colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
+     colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
+     colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
+     colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
+ };
> 
> colnames(finalData) = colNames;
> ###From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> finalDataNoActivityType  = finalData[,names(finalData) != 'activityType'];
> tidyData    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);
> tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);
> write.table(tidyData, './Task1.txt',row.names=TRUE,sep='\t');
