library(plyr)

test_set <- read.table("X_test.txt")
train_set<- read.table("X_train.txt")

combined_set<-rbind(test_set,train_set)

mean_measurement<-rowMeans(combined_set)
sd_measurement<-apply(combined_set,1,sd)
  
test_activity <- read.table("y_test.txt")
train_activity <- read.table("y_train.txt")

combined_activity<-rbind(test_activity,train_activity)
combined_activity<-as.factor(combined_activity[[1]])
combined_activity<-revalue(combined_activity,c("1"="Walking","2"="walking_upstairs","3"="walking_downstairs","4"="sitting","5"="standing", "6"="laying"))

test_subject <- read.table("subject_test.txt")
train_subject <- read.table("subject_train.txt")
combined_subject<-rbind(test_subject[1],train_subject[1])
combined_subject<-combined_subject[[1]]


data<-data.frame(subject=combined_subject,activity=combined_activity,mean=mean_measurement,standard_deviation=sd_measurement)

tidy_data<-ddply(data, .(subject, activity), summarize, mean = round(mean(mean), 3), standard_deviation = round(sd(standard_deviation), 3))

write.table(tidy_data,"tidy_data_set.txt",row.names = FALSE)