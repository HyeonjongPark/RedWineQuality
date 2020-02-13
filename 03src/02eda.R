# 
# For more information, read [Cortez et al., 2009].
# Input variables (based on physicochemical tests):
# 1 - fixed acidity         : 고정산 - 와인의 산도를 제어
# 2 - volatile acidity      : 휘발성산 - 와인의 향과 연관
# 3 - citric acid           : 구연산 - 와인의 신선함을 올림
# 4 - residual sugar        : 잔여당분 - 와인의 단 맛 올림
# 5 - chlorides             : 염화물 - 와인의 짠 맛의 원인
# 6 - free sulfur dioxide   : 황 화합물 - 와인을 오래 보관하게 함
# 7 - total sulfur dioxide  : 황 화합물 - 와인을 오래 보관하게 함
# 8 - density               : 밀도 - 와인의 무게감을 나타냄
# 9 - pH                    : 산성도 - 와인의 신 맛의 정도
# 10 - sulphates            : 황 화합물 - 와인을 오래 보관하게 함
# 11 - alcohol              : 알코올 - 와인의 단 맛과 무게감에 영향
# Output variable (based on sensory data):
# 12 - quality (score between 0 and 10) : 와인의 질


## skim would give you the outlook of the dataset, number of observations, number of columns, the range of the variables, number of missing/ unique values, the histogram, etc.

wine = read_csv("./01original-data/winequality-red.csv")

wine %>% head
wine %>% skim() %>% kable()

library(data.table)
wine2 = fread("./01original-data/winequality-red.csv")
wine2 = as.tibble(wine)
wine2 %>% skim() %>% kable()

## Corrplot would give you a overview of the correlation between all the variables. It is better to know the relationship in the very beginning of your analysis.

wine %>% cor() %>% 
  corrplot.mixed(upper = "ellipse", tl.cex=.8, tl.pos = 'lt', number.cex = .8)



## First of all, I learned the technique from this kernel, Intro to Regression and Classification in R.
## Corrgram seems like to be an alternative way to do corrplot.

wine %>% corrgram(lower.panel=panel.shade, upper.panel=panel.ellipse)







