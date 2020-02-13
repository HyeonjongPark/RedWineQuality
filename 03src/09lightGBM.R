

data.train <- lgb.Dataset(data = data.matrix(train[, !colnames(valid) %in% c("quality")]), label = train$quality %>% as.numeric() - 1)

params <- list(objective = "multiclass", metric = "multi_error", num_class = 6)



set.seed(1)

model <- lgb.train(params,
                   
                   data.train,
                   
                   100,
                   
                   min_data = 1
                   
                   , learning_rate = 0.06)



result <- predict(model, data.matrix(valid[,colnames(valid)!=c('quality')]))



list <- list()



for (i in 1:nrow(valid)){
  
  max = max(result[(i-1)*6+1], result[(i-1)*6+2], result[(i-1)*6+3], result[(i-1)*6+4], result[(i-1)*6+5], result[(i-1)*6+6])
  list[i] <- if_else(max == result[(i-1)*6+6], 6, 
                     if_else(max == result[(i-1)*6+5], 5,
                             if_else(max == result[(i-1)*6+4], 4,
                                     if_else(max == result[(i-1)*6+3], 3,
                                             if_else(max == result[(i-1)*6+2], 2, 1)))))
  
}



pred <- list %>% as.numeric() - 1



confusionMatrix(pred, valid$quality %>% as.numeric() - 1)
