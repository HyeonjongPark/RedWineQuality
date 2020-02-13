
## Correct column names and Turn quality variable into factor

colnames(wine) <- wine %>% colnames() %>% str_replace_all(" ","_")

wine$quality <- as.factor(wine$quality)

wine %>% head




