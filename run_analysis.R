# merge all data
# join train and test dataset of x
data = read.table('~/dataAnalysis/UCI HAR Dataset/train/X_train.txt', header = F)
data = rbind(data, read.table('~/dataAnalysis/UCI HAR Dataset/test/X_test.txt', header = F))
# join to data subject variable
pom = read.table('~/dataAnalysis/UCI HAR Dataset/train/subject_train.txt', header = F)
pom = rbind(pom, read.table('~/dataAnalysis/UCI HAR Dataset/test/subject_test.txt', header = F))
data$subject = pom
# join to data activity variable
pom = read.table('~/dataAnalysis/UCI HAR Dataset/train/y_train.txt', header = F)
pom = rbind(pom, read.table('~/dataAnalysis/UCI HAR Dataset/test/y_test.txt', header = F))
data$activity = pom

# rename activities
data[data$activity == 1, 'activity'] = 'WALKING'
data[data$activity == 2, 'activity'] = 'WALKING_UPSTAIRS'
data[data$activity == 3, 'activity'] = 'WALKING_DOWNSTAIRS'
data[data$activity == 4, 'activity'] = 'SITTING'
data[data$activity == 5, 'activity'] = 'STANDING'
data[data$activity == 6, 'activity'] = 'LAYING'

# create colnames
nam = read.table('~/dataAnalysis/UCI HAR Dataset/features.txt')
nam = make.names(names = nam$V2, unique = T)
nam = gsub(pattern = '...',replacement = '',x = nam,fixed = T)
nam = gsub(pattern = '..',replacement = '',x = nam,fixed = T)
colnames(data) = nam

# select columns only where are stds and means
data = data[ ,c(which(grepl('std',nam)), which(grepl('mean',nam)), 562, 563)]
colnames(data)[80]  = 'subject'
colnames(data)[81]  = 'activity'

# create tiny dataset - means for every subject and activity
library(data.table)
DT = data.table(data)
pom = DT[, lapply(.SD, sum, na.rm=T), by=c('subject','activity')]
write.table(pom, file = '~/dataAnalysis/tidy.txt', row.names = F)
