# randomforest

set.seed(1)

rf_model <- randomForest(quality~alcohol+volatile_acidity+citric_acid+
                           density+pH+sulphates, train,
                         mtry = 1
                         )
?randomForest


rf_result <- predict(rf_model, newdata = valid[,!colnames(valid) %in% c("quality")])
rf_result_proba <- predict(rf_model, newdata = valid[,!colnames(valid) %in% c("quality")], type = "prob")

rf_result_proba

confusionMatrix(rf_result, valid$quality)

varImp(rf_model) %>% kable()
varImpPlot(rf_model)







### 최적 하이퍼 파라미터


## tuning 1.

fitControl = trainControl(method = "repeatedcv", number = 10, repeats = 5)
rf_fit = train(quality~alcohol+volatile_acidity+citric_acid+
                 density+pH+sulphates , data=train, method = "rf", trControl = fitControl, verbose = F )

rf_fit

rf_fit_result = predict(rf_fit, newdata = valid[,!colnames(valid) %in% c("quality")])
confusionMatrix(rf_fit_result, valid$quality)







## tuning 2.
x = train %>% select(-quality)
y = train[,"quality"]

control <- trainControl(method='repeatedcv', 
                        number=10, 
                        repeats=3)
#Metric compare model is Accuracy
metric <- "Accuracy"
set.seed(1)
#Number randomely variable selected is mtry
mtry <- sqrt(ncol(x))
tunegrid <- expand.grid(.mtry=mtry)
rf_default <- train(quality~alcohol+volatile_acidity+citric_acid+
                      density+pH+sulphates, 
                    data=train, 
                    method='rf', 
                    metric='Accuracy', 
                    tuneGrid=tunegrid, 
                    trControl=control)
print(rf_default)






## 병렬 컴퓨팅 parallel processing

library(doParallel)
cores <- 7
registerDoParallel(cores = cores)



#mtry: Number of random variables collected at each split. In normal equal square number columns.
mtry <- sqrt(ncol(x))
#ntree: Number of trees to grow.
ntree <- 3


control <- trainControl(method='repeatedcv', 
                        number=10, 
                        repeats=3,
                        search = 'random')

#Random generate 15 mtry values with tuneLength = 15
set.seed(1)
rf_random <- train(quality~alcohol+volatile_acidity+citric_acid+
                     density+pH+sulphates, 
                   data=train,
                   method = 'rf',
                   metric = 'Accuracy',
                   tuneLength  = 15, 
                   trControl = control)
print(rf_random)

plot(rf_random)





#Create control function for training with 10 folds and keep 3 folds for training. search method is grid.
control <- trainControl(method='repeatedcv', 
                        number=10, 
                        repeats=3, 
                        search='grid')
#create tunegrid with 15 values from 1:15 for mtry to tunning model. Our train function will change number of entry variable at each split according to tunegrid. 
tunegrid <- expand.grid(.mtry = (1:15)) 

rf_gridsearch <- train(quality~alcohol+volatile_acidity+citric_acid+
                         density+pH+sulphates, 
                       data=train,
                       method = 'rf',
                       metric = 'Accuracy',
                       tuneGrid = tunegrid)
print(rf_gridsearch)


plot(rf_gridsearch)




set.seed(1)
bestMtry <- tuneRF(x,y, stepFactor = 1.5, improve = 1e-5, ntree = 500)
tuneR




