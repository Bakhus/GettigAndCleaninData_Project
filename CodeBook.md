
This scripts processes Raw data and produces a tidy data set in a new file. 
The output of this script is a **tidy_data_set.txt** file containing 4 columns (variables):

1. subject -- The id of the performer.
2. activity-- Description of the activity being performed.
3. mean -- The mean of all measurement per performer per activity.
4. standard_deviation -- The standard deviation of all measurement per performer per activity.

The script utilizes the *plyr* library. 

```{r}
library(plyr)
```

First we read in the test and training files containing measurements.The files are namedX_test.txt and X_train.txt respectively. Then we combine these two datasets into one called combined_set

```{r}

test_set <- read.table("X_test.txt")
train_set<- read.table("X_train.txt")
combined_set<-rbind(test_set,train_set)
```

Each row of the data set is a 561-feature vector with time and frequency domain variables.
We take the mean and stadard deviation per row.

```{r}
mean_measurement<-rowMeans(combined_set)
sd_measurement<-apply(combined_set,1,sd)
```

Next we read in the type of activities performed (Coded as 1--6) both for test and training sets.
Then we combine both sets, and change the code to appropriate name of the activity.

```{r}
test_activity <- read.table("y_test.txt")
train_activity <- read.table("y_train.txt")

combined_activity<-rbind(test_activity,train_activity)
combined_activity<-as.factor(combined_activity[[1]])
combined_activity<-revalue(combined_activity,c("1"="Walking","2"="walking_upstairs","3"="walking_downstairs","4"="sitting","5"="standing", "6"="laying"))
```

Similarly, we read in the performer (subject) data. There were 30 volunteers in total. Performers are identified with id's (1--30). Again both test and training sets are combined.

```{r}
test_subject <- read.table("subject_test.txt")
train_subject <- read.table("subject_train.txt")
combined_subject<-rbind(test_subject[1],train_subject[1])
combined_subject<-combined_subject[[1]]
```

Using the *mean_measurement*, *sd_measurement*, *combined_activity* and *combined_subject*, we create a new data frame with those four variables.

```{r}
data<-data.frame(subject=combined_subject,activity=combined_activity,mean=mean_measurement,standard_deviation=sd_measurement)
```

Finally we take the average of each variable (mean and standard deviation) for each activity and each subject.  the final data set is saved in the **tidy_data_set.txt** file.

```{r}
tidy_data<-ddply(data, .(subject, activity), summarize, mean = round(mean(mean), 3), standard_deviation = round(sd(standard_deviation), 3))

write.table(tidy_data,"tidy_data_set.txt",row.names = FALSE)
```
