
set.seed(1)
wine
inTrain <- createDataPartition(wine$quality, p=.9, list = F)



train <- wine[inTrain,]

valid <- wine[-inTrain,]

rm(inTrain)
