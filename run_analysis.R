#Load the requier packages
  library(dplyr)
  library(tibble)

#Dowload the file, checking if was download previously
  Data.1 <- "HRA_Data.zip"
  #Check if the file already exits
  if (!file.exists(Data.1)) {
      URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(URL,Data.1,method = "curl")    
  }
  #Check if folder exists
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(Data.1) 
  }
  
#Reading the different information
  features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
  activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity type"))
  #Test Folder
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
  xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
  ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
  #Train Folder
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
  xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
  ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")
  
  
#Merge the test and training data by rows then by columns
  xData <- rbind(xtrain,xtest)
  yData <- rbind(ytrain,ytest)
  subject_Data <- rbind(subject_train, subject_test)
  Main.Data <- cbind(xData,yData,subject_Data)

#Selecting the columns that containt mean and standard desviation
  Main.Data <- Main.Data %>% select(subject, code, contains(c("mean","std")))
#Set the activities names on the data  
  Main.Data$code <- activities[Main.Data$code,2] 
#Label the other columns
  names(Main.Data)[2] = "activity"
  names(Main.Data)[2] = "activity"
  names(Main.Data)<-gsub("Acc", "Accelerometer", names(Main.Data))
  names(Main.Data)<-gsub("Gyro", "Gyroscope", names(Main.Data))
  names(Main.Data)<-gsub("BodyBody", "Body", names(Main.Data))
  names(Main.Data)<-gsub("Mag", "Magnitude", names(Main.Data))
  names(Main.Data)<-gsub("^t", "Time", names(Main.Data))
  names(Main.Data)<-gsub("^f", "Frequency", names(Main.Data))
  names(Main.Data)<-gsub("tBody", "TimeBody", names(Main.Data))
  names(Main.Data)<-gsub("-mean()", "Mean", names(Main.Data), ignore.case = TRUE)
  names(Main.Data)<-gsub("-std()", "STD", names(Main.Data), ignore.case = TRUE)
  names(Main.Data)<-gsub("-freq()", "Frequency", names(Main.Data), ignore.case = TRUE)
  names(Main.Data)<-gsub("angle", "Angle", names(Main.Data))
  names(Main.Data)<-gsub("gravity", "Gravity", names(Main.Data))
  
  FinalDB<- Main.Data %>%
    group_by(subject, activity) %>%
    summarise_all(lst(mean))
  write.table(FinalDB, "TidyDB.txt", row.name=TRUE,sep = ",")
  

  