## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("C:/Users/SANDHEEP/Documents/Cousera/cleaning/project/")

# Load: activity labels and data columns
actlab <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
feat <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract measurements on the mean and SD
ext <- grepl("mean|std", features)

# Load and process X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
topic_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extract only the measurements on the mean , SD and load act labels
X_test = X_test[,ext]
y_test[,2] = actlab[y_test[,1]]
names(y_test) = c("ID", "actlab")
names(subject_test) = "topic"

# Bind data and process
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = feat

# Extract only the measurements on the mean and SD
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = actlab[y_train[,1]]
names(y_train) = c("ID", "actlab")
names(subject_train) = "topic"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("topic", "ID", "actlab")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, topic + actlab ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")