library(DT)
library(plotly)
library(dplyr)
library(corrplot)
library(leaflet)

function(input, output, session) {
  # Base de données
  output$dataT <- renderDataTable(mydata)
  
  output$summary <- renderPrint({
    summary(mydata)
  })
  
  output$histplot <- renderPlotly({
    req(input$var1)  # Assurez-vous que var1 est sélectionné
    
    # Distribution
    p1 <- mydata %>% 
      plot_ly(x = ~get(input$var1)) %>% 
      add_histogram() %>% 
      layout(xaxis = list(title = input$var1))
    
    # Boxplot
    p2 <- mydata %>% 
      plot_ly(y = ~get(input$var1)) %>% 
      add_boxplot() %>% 
      layout(yaxis = list(showticklabels = FALSE))
    
    # Ensemble
    subplot(p1, p2, nrows = 2) %>% 
      hide_legend() %>% 
      layout(title = "Distribution: Histogramme et boxplot",
             yaxis = list(title = "Fréquence"))
  })
  
  output$cor <- renderPlot({
    req(input$var2, input$var3)  # Assurez-vous que les variables var2 et var3 sont sélectionnées
    
    selected_vars <- mydata %>% select(all_of(c(input$var2, input$var3)))
    
    cor_matrix <- cor(selected_vars, use = "complete.obs")
    
    # Afficher la matrice de corrélation avec les cases colorées, les valeurs de corrélation et un nom de variable en rouge
    corrplot(cor_matrix, method = "color", tl.cex = 0.8, tl.col = "black", tl.srt = 45, 
             col = colorRampPalette(c("blue", "white", "red"))(200), addCoef.col = "black", number.cex = 0.8)
  })
  
  output$map <- renderLeaflet({
    # Conversion des colonnes latitude et longitude en numérique
    
    req(mydata$latitude, mydata$longitude)
    
    pal <- colorNumeric(palette = c("blue", "red"), domain = mydata$prix)
    
    leaflet(mydata) %>% 
      addTiles() %>%
      setView(lng = -115.000000, lat = 55.000000, zoom = 5) %>%  # Centrer sur l'Inde
      addCircleMarkers(~longitude, ~latitude,
                       color = ~pal(prix),
                       radius = 3,
                       popup = ~paste("Prix:", prix))
  })
}
