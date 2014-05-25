                    #Question 1
#download files
#X_test
if(!file.exists("./data")){dir.create("./data")}
urlXtestfile<-"https://github.com/hctri/Get-CleanData/blob/master/test/X_test.txt"
download.file(urlXtestfile, destfile="./data/X_test.txt",method="curl")

#X_train
urlXtrainfile<-"https://github.com/hctri/Get-CleanData/blob/master/train/X_train.txt"
download.file(urlXtrainfile, destfile="./data/X_train.txt",method="curl")

#y_test
urly_testfile<-"https://github.com/hctri/Get-CleanData/blob/master/test/y_test.txt"
download.file(urly_testfile, destfile="./data/y_test.txt",method="curl")

#y_train
urly_trainfile<-"https://github.com/hctri/Get-CleanData/blob/master/train/y_train.txt"
download.file(urly_trainfile, destfile="./data/y_train.txt",method="curl")

#subject_test
urlsubject_testfile<-"https://github.com/hctri/Get-CleanData/blob/master/test/subject_test.txt"
download.file(urlsubject_testfile, destfile="./data/subject_test.txt",method="curl")

#subject_train
urlsubject_trainfile<-"https://github.com/hctri/Get-CleanData/blob/master/train/subject_train.txt"
download.file(urlsubject_trainfile, destfile="./data/subject_train.txt",method="curl")

#feature
urlfeaturefile<-"https://github.com/hctri/Get-CleanData/blob/master/features.txt"
download.file(urlfeaturefile, destfile="./data/feature.txt",method="curl")


#read data
X_test<-read.table("./data/X_test.txt")
X_train<-read.table("./data/X_train.txt")

#combine training and testing sets
fulldata1<-rbind(X_test,X_train)

                    #Question 2
#Extracts only the measurements on the mean and standard deviation for each measurement
#read feature data
features<-read.table("./data/feature.txt")
colname<-features[,2]
names(fulldata1)<-colname

#extract only rows have strings "name" or "std" in them
meanandstd<-features[grepl("mean",features$V2)|grepl("std",features$V2),]

#subset fulldata by meanandstd variable
subset<-fulldata1[,meanandstd$V1]

#Add "activity" and "subject" to subset
y_test<-read.table("./data/y_test.txt")
names(y_test)<-"activity"
y_train<-read.table("./data/y_train.txt")
names(y_train)<-"activity"
subject_test<-read.table("./data/subject_test.txt")
names(subject_test)<-"subject"
subject_train<-read.table("./data/subject_train.txt")
names(subject_train)<-"subject"

#add variables activity and subject to subset
fullactivity<-rbind(y_test,y_train)
fullsubject<-rbind(subject_test,subject_train)
subset2<-cbind(subset,fullactivity,fullsubject)
    

                    #Question 3
#Apply descriptive activity names to name the activities in the data set
library(plyr)

#Convert numeric values in column activity to factor
subset2$activity<-as.factor(subset2$activity)

#Change "1", "2"...to actual names
subset2$activity<-revalue(subset2$activity,c("1"="WALKING","2"="WALKING_UPSTAIRS",
          "3"="WALKING_DOWNSTAIRS","4"="SITTING","5"="STANDING","6"="LAYING"))

                    #Question 4
#Reshaping variable names
#lowercase letters
names(subset2)<-tolower(names(subset2))
#remove "-"
names(subset2)<-gsub("-","",names(subset2))

                    #Question 5
#Create a tidy data set with the average of each variable by activity and subject
library(reshape2)

#convert data to long-format
melt<-melt(subset2,id.vars=c("activity","subject"))

#extract mean values by activity and subject in a wide-format
tidydata<-dcast(melt,activity+subject~variable,fun.aggregate=mean,na.rm=TRUE)

#export data
write.table(tidydata,"./data/tidydata.txt",sep="\t")

