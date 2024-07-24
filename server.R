library(DT)
library(plotly)
library(dplyr)
library(corrplot)
library(leaflet)
library(leaflet.extras)
library(tidyr)

function(input, output, session) {
  # Base de données
  setwd("C:/Users/HP/Desktop/Faical/Document de Faical/AS/AS 2/Semestre 4/Conception de Tableaux de bord/Projet de tableau de bord")
  mydata <- read.csv("House_price.csv", sep = ";")
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
  
  output$timeline <- renderPlotly({
    # Graphique de l'évolution des prix dans le temps
    p <- mydata %>%
      group_by(annee_construction) %>%
      summarize(moyenne_prix = mean(prix, na.rm = TRUE)) %>%
      plot_ly(x = ~annee_construction, y = ~moyenne_prix, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = 'Évolution des prix des maisons dans le temps',
             xaxis = list(title = 'Année de construction'),
             yaxis = list(title = 'Prix moyen'))
    p
  })
  
  output$prix_vs_sup <- renderPlotly({
    # Graphique du prix en fonction de la superficie
    p <- mydata %>%
      plot_ly(x = ~sup_maison, y = ~prix, type = 'scatter', mode = 'markers',
              marker = list(color = 'rgba(152, 0, 0, .8)', size = 10, line = list(color = 'rgba(152, 0, 0, .8)', width = 2))) %>%
      layout(title = 'Prix en fonction de la superficie',
             xaxis = list(title = 'Superficie (m²)'),
             yaxis = list(title = 'Prix'))
    p
  })
  
  output$heatmap <- renderLeaflet({
    mydata <- mydata %>%
      mutate(latitude = as.numeric(gsub(",", ".", latitude)),
             longitude = as.numeric(gsub(",", ".", longitude)))
    
    leaflet(mydata) %>%
      addTiles() %>%
      setView(lng = 78.9629, lat = 20.5937, zoom = 5) %>%
      addHeatmap(lng = ~longitude, lat = ~latitude, intensity = ~prix, blur = 20, max = 0.05, radius = 15)
  })
  
  output$influence_caracteristiques <- renderPlotly({
    caracteristiques <- c("chambres", "douches", "sup_totale", "etages")
    
    data <- mydata %>%
      select(prix, all_of(caracteristiques)) %>%
      pivot_longer(cols = -prix, names_to = "caracteristique", values_to = "valeur") %>%
      group_by(caracteristique) %>%
      summarize(prix_moyen = mean(prix, na.rm = TRUE), .groups = 'drop')
    
    plot_ly(data, x = ~caracteristique, y = ~prix_moyen, type = 'bar') %>%
      layout(title = "Influence des caractéristiques des maisons sur le prix",
             xaxis = list(title = "Caractéristique"),
             yaxis = list(title = "Prix moyen"))
  })
  

}
