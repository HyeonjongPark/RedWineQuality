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
  objective          = "multi:softmax",   # default = "reg:linear"
  eval_metric        = "merror",
  num_class          = 7,
  seed               = 1               # reproducability seed
  , tree_method = "hist"
  , grow_policy = "lossguide"
)



xgb_model <- xgb.train(parameters, data.train, nrounds = 100)


xgb_pred <- predict(xgb_model, data.valid)

confusionMatrix(as.factor(xgb_pred+2), valid$quality)


xgb.importance(colnames(train[, !colnames(valid) %in% c("quality")]), model = xgb_model) %>% kable()

xgb.imp <- xgb.importance(colnames(train[, !colnames(valid) %in% c("quality")]), model = xgb_model)

xgb.ggplot.importance(importance_matrix = xgb.imp)


rm(xgb_model, xgb_pred, data.train, data.valid, parameters)