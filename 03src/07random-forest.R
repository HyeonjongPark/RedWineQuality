# randomforest

set.seed(1)

rf_model <- randomForest(quality~alcohol+volatile_acidity+citric_acid+
                           
                           density+pH+sulphates,train)

rf_result <- predict(rf_model, newdata = valid[,!colnames(valid) %in% c("quality")])



confusionMatrix(rf_result, valid$quality)

varImp(rf_model) %>% kable()
varImpPlot(rf_model)

rm(rf_model, rf_result)
