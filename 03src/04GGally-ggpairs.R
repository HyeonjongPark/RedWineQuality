
wine$quality %>% unique()


## GGally-ggparis

wine %>% 
  
  mutate(quality = as.factor(quality)) %>% 
  
  select(-c(residual_sugar, free_sulfur_dioxide, total_sulfur_dioxide, chlorides)) %>% 
  
  ggpairs(aes(color = quality, alpha=0.4),
          
          columns=1:7,
          
          lower=list(continuous="points"),
          
          upper=list(continuous="blank"),
          
          axisLabels="none", switch="both")



## ployly 3D Interactive graph

wine %>% 
  
  plot_ly(x=~alcohol,y=~volatile_acidity,z= ~sulphates, color=~quality, hoverinfo = 'text', colors = viridis(3),
          
          text = ~paste('Quality:', quality,
                        
                        '<br>Alcohol:', alcohol,
                        
                        '<br>Volatile Acidity:', volatile_acidity,
                        
                        '<br>sulphates:', sulphates)) %>% 
  
  add_markers(opacity = 0.8) %>%
  
  layout(title = "3D Wine Quality",
         
         annotations=list(yref='paper',xref="paper",y=1.05,x=1.1, text="quality",showarrow=F),
         
         scene = list(xaxis = list(title = 'Alcohol'),
                      
                      yaxis = list(title = 'Volatile Acidity'),
                      
                      zaxis = list(title = 'sulphates')))

