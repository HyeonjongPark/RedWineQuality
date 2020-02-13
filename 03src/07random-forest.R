# randomforest

set.seed(1)

rf_model <- randomForest(quality~alcohol+volatile_acidity+citric_acid+
                           
                           density+pH+sulphates,train)

rf_result <- predict(rf_model, newdata = valid[,!colnames(valid) %in% c("quality")])
rf_result_proba <- predict(rf_model, newdata = valid[,!colnames(valid) %in% c("quality")], type = "prob")

rf_result_proba

confusionMatrix(rf_result, valid$quality)

varImp(rf_model) %>% kable()
varImpPlot(rf_model)




## tuning

fitControl = trainControl(method = "repeatedcv", number = 10, repeats = 5)
rf_fit = train(quality~alcohol+volatile_acidity+citric_acid+
                 density+pH+sulphates , data=train, method = "rf", trControl = fitControl, verbose = F )

rf_fit

rf_fit_result = predict(rf_fit, newdata = valid[,!colnames(valid) %in% c("quality")])
confusionMatrix(rf_fit_result, valid$quality)

