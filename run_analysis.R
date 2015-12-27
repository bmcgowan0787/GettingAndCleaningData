
## Create "activity labels" data based on .txt file

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]



## Create data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]


## Extract only the measurements on the mean and standard deviation for each measurement.

extract_features <- grepl("mean|std", features)


## Create tables from X_test, y_test, and subject_test data.

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Assign fields from features data
names(X_test) = features


## Extract only the mean and standard deviation for each measurement.

X_test = X_test[,extract_features]

## Load activity labels

y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

## Bind data

test_data <- cbind(as.data.table(subject_test), y_test, X_test)

## Create tables for X_train, y_train, and subject_train data.

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

##Assign column names to training data
names(X_train) = features


## Extract only mean and standard deviation for each measurement.

X_train = X_train[,extract_features]

## Load activity data

y_train[,2] = activity_labels[y_train[,1]]

## Assign column names/labels

names(y_train) = c("Activity_ID", "Activity_Label")

names(subject_train) = "subject"

## Bind data by column types

train_data <- cbind(as.data.table(subject_train), y_train, x_train)


## Merge test and train data by rows

data = rbind(test_data, train_data)

## Assign field names/labels

labels  = c("subject", "Activity_ID", "Activity_Label")

data_labels = setdiff(colnames(data), labels)

melt_data = melt(data, id = labels, measure.vars = data_labels)


# Apply mean function to dataset using dcast function

tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)


write.table(tidy_data, file = "./tidy_data.txt")
