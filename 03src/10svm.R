
# svm

set.seed(1)

svm_model <- svm(quality~alcohol+volatile_acidity+citric_acid+
                   
                   density+pH+sulphates,train)

svm_result <- predict(svm_model, newdata = valid[,!colnames(valid) %in% c("quality")])



confusionMatrix(svm_result, valid$quality)