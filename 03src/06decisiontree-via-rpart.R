# rpart

set.seed(1)

rpart_model <- rpart(quality~alcohol+volatile_acidity+citric_acid+
                       density+pH+sulphates, train)



rpart.plot(rpart_model)
visTree(rpart_model)


fancyRpartPlot(rpart_model)

rpart_result <- predict(rpart_model, newdata = valid[,!colnames(valid) %in% c("quality")], type='class')
rpart_result_proba <- predict(rpart_model, newdata = valid[,!colnames(valid) %in% c("quality")], type ="prob")

rpart_result_proba

confusionMatrix(rpart_result, valid$quality)  # 0.586

varImp(rpart_model) %>% kable()
