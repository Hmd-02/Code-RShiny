library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(
  dashboardHeader(title = "Prix des maisons en Inde",
                  titleWidth = 300,
                  tags$li(class = "dropdown", tags$a(href = "", icon("github"), "Code source", target = "_blank"))),
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",
      menuItem("Base de données", tabName = "data", icon = icon("database")),
      menuItem("Visualisation", tabName = "visu", icon = icon("chart-line")),
      menuItem("Répartition", tabName = "rep", icon = icon("map"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "data",
              tabBox(id = "t1", width = 12,
                     tabPanel("A propos", icon = icon("address-card"),
                              fluidRow(
                                column(width = 8,
                                       tags$img(src = "house.jpg", width = 600, height = 300),
                                       tags$br()
                                ),
                                column(width = 4,
                                       tags$br(),
                                       tags$p("Ce jeu de données contient des informations détaillées sur les prix des maisons en Inde. Il inclut des détails tels que le nombre de chambres et de salles de bain, la taille de la surface habitable et du terrain, ainsi que le nombre d'étages. Il précise également si la maison est proche de l'eau, l'état et la qualité de la maison, les années de construction et de rénovation, et les coordonnées géographiques. De plus, la base comporte des informations supplémentaires, comme le nombre d'écoles à proximité, la distance de l'aéroport et le prix de la propriété. Elle est idéale pour analyser le marché immobilier et faire des prédictions sur les prix des maisons dans différentes régions de l'Inde.")
                                )
                              )
                     ),
                     tabPanel("Données", icon = icon("calculator"), dataTableOutput("dataT")),
                     tabPanel("Statistiques descriptives", icon = icon("chart-pie"), verbatimTextOutput("summary"))
              )
      ),
      tabItem(tabName = "visu",
              tabBox(id = "t2", width = 12,
                     tabPanel("Distribution",
                              fluidRow(
                                column(4,
                                       conditionalPanel(
                                         condition = "input.t2 === 'Distribution'",
                                         selectInput(inputId = "var1", label = "Choisissez une variable", choices = names(mydata), selected = names(mydata)[1])
                                       )
                                ),
                                column(8,
                                       plotlyOutput("histplot")
                                )
                              )
                     ),
                     tabPanel("Corrélation entre les variables", 
                              fluidRow(
                                column(2,
                                       conditionalPanel(
                                         condition = "input.t2 === 'Corrélation entre les variables'",
                                         selectInput(inputId = "var2", label = "Choisissez la première variable", choices = names(mydata), selected = names(mydata)[1]),
                                         selectInput(inputId = "var3", label = "Choisissez la deuxième variable", choices = names(mydata), selected = names(mydata)[2])
                                       )
                                ),
                                column(8,
                                       plotOutput("cor")
                                ),
                                column(width = 2,
                                       tags$br(),
                                       tags$p("Cette matrice présente les coefficients de corrélation qui existent entre les variables de la base de données. Les couleurs rouge foncées indiquent une forte corrélation positive entre les deux variables croisées et une couleur bleue foncée indique une corrélation négative entre les variables croisées. Lorsque la couleur est claire ou blanche, il n'y a pas de corrélation entre les variables croisées.")
                              ))
                     ),
                     tabPanel("Graphique 3", h4("Content for Graph 3")),
                     tabPanel("Graphique 4", h4("Content for Graph 4"))
              )
      ),
      tabItem(tabName = "rep",
              box(width = 12, 
                  h1("Visualisation de la répartition"),
                  leafletOutput("map")
              )
      )
    )
  )
)
