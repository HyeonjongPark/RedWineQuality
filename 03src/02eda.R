

## skim would give you the outlook of the dataset, number of observations, number of columns, the range of the variables, number of missing/ unique values, the histogram, etc.

wine = read.csv("./01original-data/winequality-red.csv",header = T)
wine %>% head
wine %>% skim() %>% kable()



## Corrplot would give you a overview of the correlation between all the variables. It is better to know the relationship in the very beginning of your analysis.

wine %>% cor() %>% 
  corrplot.mixed(upper = "ellipse", tl.cex=.8, tl.pos = 'lt', number.cex = .8)



# First of all, I learned the technique from this kernel, Intro to Regression and Classification in R.
# Corrgram seems like to be an alternative way to do corrplot.

wine %>% corrgram(lower.panel=panel.shade, upper.panel=panel.ellipse)







