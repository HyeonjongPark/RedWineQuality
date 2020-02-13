# xgboost

data.train <- xgb.DMatrix(data = data.matrix(train[, !colnames(valid) %in% c("quality")]), label = train$quality)
data.valid <- xgb.DMatrix(data = data.matrix(valid[, !colnames(valid) %in% c("quality")]))



parameters <- list(
  
  # General Parameters
  booster            = "gbtree",      
  silent             = 0,           
  
  # Booster Parameters
  eta                = 0.08,              
  gamma              = 0.7,                 
  max_depth          = 8,                
  min_child_weight   = 2,            
  subsample          = .9,                 
  colsample_bytree   = .5,                
  colsample_bylevel  = 1,          
  lambda             = 1,    
  alpha              = 0,       
  
  # Task Parameters
  objective          = "multi:softmax",   # default = "reg:linear" , "softmax", softprob
  eval_metric        = "merror",          # merror , logloss
  num_class          = 7,
  seed               = 1,                 # reproducability seed
  tree_method        = "hist",
  grow_policy        = "lossguide"
)



xgb_model <- xgb.train(parameters, data.train, nrounds = 100)


xgb_pred <- predict(xgb_model, data.valid)
xgb_pred

# softpob으로 설정하고 matrix 아래 코드를 실행해주면 클래스별로 prob을 확인할 수 있다.
matrix(xgb_pred, ncol = 7, byrow = T)


confusionMatrix(as.factor(xgb_pred+2), valid$quality)


xgb.importance(colnames(train[, !colnames(valid) %in% c("quality")]), model = xgb_model) %>% kable()

xgb.imp <- xgb.importance(colnames(train[, !colnames(valid) %in% c("quality")]), model = xgb_model)

xgb.ggplot.importance(importance_matrix = xgb.imp)








# 그리드 서치 - 하이퍼 파라미터 찾기

searchGridSubCol <- expand.grid(subsample = c(0.5, 0.6, 0.7), 
                                colsample_bytree = c(0.5, 0.6, 0.7),
                                max_depth = c(3, 4, 5, 6, 7, 8),
                                min_child = seq(1), 
                                eta = c(0.1, 0.09, 0.08)
)

ntrees <- 100

system.time(
  rmseErrorsHyperparameters <- apply(searchGridSubCol, 1, function(parameterList){
    
    #Extract Parameters to test
    currentSubsampleRate <- parameterList[["subsample"]]
    currentColsampleRate <- parameterList[["colsample_bytree"]]
    currentDepth <- parameterList[["max_depth"]]
    currentEta <- parameterList[["eta"]]
    currentMinChild <- parameterList[["min_child"]]
    xgboostModelCV <- xgb.cv(data =  data.train, nrounds = ntrees, nfold = 5, showsd = TRUE, 
                             metrics = "rmse", verbose = TRUE, "eval_metric" = "rmse",
                             "objective" = "reg:linear", "max.depth" = currentDepth, "eta" = currentEta,                               
                             "subsample" = currentSubsampleRate, "colsample_bytree" = currentColsampleRate
                             , print_every_n = 10, "min_child_weight" = currentMinChild, booster = "gbtree",
                             early_stopping_rounds = 10)
    
    xvalidationScores <- as.data.frame(xgboostModelCV$evaluation_log)
    rmse <- tail(xvalidationScores$test_rmse_mean, 1)
    trmse <- tail(xvalidationScores$train_rmse_mean,1)
    output <- return(c(rmse, trmse, currentSubsampleRate, currentColsampleRate, currentDepth, currentEta, currentMinChild))}))

rmseErrorsHyperparameters

output <- as.data.frame(t(rmseErrorsHyperparameters))
varnames <- c("TestRMSE", "TrainRMSE", "SubSampRate", "ColSampRate", "Depth", "eta", "currentMinChild")
names(output) <- varnames
output
