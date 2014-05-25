#Question 1
#read data
X_test<-read.table("E:\\Coursera\\Getting and Cleaning Data\\Project\\UCI HAR Dataset\\P2\\test\\X_test.txt")
X_train<-read.table("E:\\Coursera\\Getting and Cleaning Data\\Project\\UCI HAR Dataset\\P2\\train\\X_train.txt")
y_test<-read.table("E:\\Coursera\\Getting and Cleaning Data\\Project\\UCI HAR Dataset\\P2\\test\\y_test.txt")
names(y_test)<-"activity"
y_train<-read.table("E:\\Coursera\\Getting and Cleaning Data\\Project\\UCI HAR Dataset\\P2\\train\\y_train.txt")
names(y_train)<-"activity"
subject_test<-read.table("E:\\Coursera\\Getting and Cleaning Data\\Project\\UCI HAR Dataset\\P2\\test\\subject_test.txt")
names(subject_test)<-"subject"
subject_train<-read.table("E:\\Coursera\\Getting and Cleaning Data\\Project\\UCI HAR Dataset\\P2\\train\\subject_train.txt")
names(subject_train)<-"subject"

#add variables
testset<-cbind(X_test,y_test,subject_test)
trainset<-cbind(X_train,y_train,subject_train)

#combine training and testing sets
fulldata<-rbind(testset,trainset)

#Question 2
#Extract mean and standard deviation followed by activity and subject
library(reshape2)

#convert data to long-format
melt<-melt(fulldata,id.vars=c("activity","subject"))

#extract mean values by activity and subject in a wide-format
dcast<-dcast(melt,activity+subject~variable,fun.aggregate=mean,na.rm=TRUE)

#extract standard deviation values by activity and subject in a wide-format
dcast2<-dcast(melt,activity+subject~variable,fun.aggregate=sd,na.rm=TRUE)


