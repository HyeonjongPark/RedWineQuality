
# svm

set.seed(1)

svm_model <- svm(quality~alcohol+volatile_acidity+citric_acid+
                   
                   density+pH+sulphates, train, gamma = 1, cost = 2)

?svm

svm_result <- predict(svm_model, newdata = valid[,!colnames(valid) %in% c("quality")])



confusionMatrix(svm_result, valid$quality)


# 최적 하이퍼 파라메터 값 찾기

obj <- tune.svm(quality~., data = train, gamma = 2^(-2:2), cost = 2^(1:5))

obj
summary(obj)
plot(obj)

