library(dplyr)
library(readxl)
library(plotly)
library(ggplot2)
library(ggtext)
library("corrplot")
library(lmtest)
library(car)
library(leaflet)


setwd(dir = "C:/Users/HP/Desktop/Faical/Document de Faical/AS/AS 2/Semestre 4/Conception de Tableaux de bord/Projet de tableau de bord")
mydata <- read.csv("House Price India.csv", sep = ";")
View(mydata)

names(mydata)

#Summary
mydata %>% 
  summary()


p1 <- mydata %>% 
  plot_ly() %>% 
  add_histogram(~chambres) %>% 
  layout(xaxis = list(title = "input$var1"))

# Menu 2 : Visualisation
# Distribution
p1=mydata %>% 
  plot_ly() %>% 
  add_histogram(~get(input$var1)) %>% 
  layout(xaxis = list(title = input$var1))

# Boxplot
p2=mydata %>% 
  plot_ly() %>% 
  add_boxplot(~get(input$var1)) %>% 
  layout(yaxis = list(showticklabels = F))

# Ensemble
subplot(p1, p2, nrows = 2) %>% 
  hide_legend() %>% 
  layout(title = "Distribution : Histogramme et boxplot",
         yaxis = list(title = "Fréquence"))


# Choix des variables quantitatives
data_quant <- mydata %>% 
  select(-bord_eau) %>% 
  select(-sousol) %>% 
  select(-Longitude) %>% 
  select(-Lattitude)

data_qual <- mydata %>% 
  select(bord_eau, sousol) 

nquant <- data_quant %>% 
  names()

nqual <- data_qual %>% 
  names()


# Corrélation
  
prix <- "prix"
mat <- mydata %>% 
  select(get(input$var2),get(input$var3))
cor_matrix <- cor(mat, use = "complete.obs")
# Créer un vecteur de couleurs pour les noms des variables
tl_colors <- rep("black", ncol(cor_matrix))
tl_colors[colnames(cor_matrix) == prix] <- "red"
# Afficher la matrice de corrélation avec les cases colorées, les valeurs de corrélation et un nom de variable en rouge
corrplot(cor_matrix, method = "color", tl.cex = 0.6, tl.col = tl_colors, tl.srt = 45, col = colorRampPalette(c("blue", "white", "red"))(200), addCoef.col = "black", number.cex = 0.6)


mydata <- mydata %>%
  mutate(latitude = as.numeric(gsub(",", ".", latitude)),
         longitude = as.numeric(gsub(",", ".", longitude)))

class(mydata$latitude)






