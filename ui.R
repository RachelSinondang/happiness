#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

header <- dashboardHeader(title = "Happiness Score Prediction")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem(text = "Plot", 
                 tabName = "graph", 
                 icon = icon("chart-line")),
        menuItem(text = "Prediction", 
                 tabName = "predict", 
                 icon = icon("laugh"))
        
    )
)

body <- dashboardBody(tabItems(
    tabItem(tabName = "graph",
            fluidRow(
                box(title = "Plot Correlation per Year",
                    background = "teal",
                    height = "550px",
                    width = 12,
                    fluidRow(column(3,
                                    selectInput(inputId = "year", 
                                                label = "Year",
                                                choices = unique(gabungan$Year),
                                                selected = "2015"))),
                    fluidRow(column(width = 12,plotOutput(outputId = "plot_corr"))
                    )
                )
            ),
            fluidRow(
                box(title = "Happiness Score Rate per Country",
                    background = "teal",
                    height = "550px",
                    width = 12,
                    fluidRow(column(3,
                                    selectInput(inputId = "neg1", 
                                                label = "Country 1",
                                                choices = unique(gabungan$Country),
                                                selected = "Switzerland")),
                             column(3,
                                    selectInput(inputId = "neg2", 
                                                label = "Country 2",
                                                choices = unique(gabungan$Country),
                                                selected = "Norway")),
                             column(3,
                                    selectInput(inputId = "neg3", 
                                                label = "Country 3",
                                                choices = unique(gabungan$Country),
                                                selected = "Indonesia")),
                             column(3,
                                    selectInput(inputId = "neg4", 
                                                label = "Country 4",
                                                choices = unique(gabungan$Country),
                                                selected = "China"))),
                    fluidRow(column(width = 12,plotlyOutput(outputId = "plot_heat"))
                    )
                )
            ),
            fluidRow(
                box(title = "Countries with Highest Happiness Score",
                    background = "teal",
                    height = "950px",
                    width = 12,
                    fluidRow(column(4,numericInput("rank", 
                                                   label = "Total Rank", 
                                                   value = 10,
                                                   min = 7,
                                                   step = 1)),
                             column(4,
                                    selectInput(inputId = "tahun", 
                                                label = "Year",
                                                choices = unique(gabungan$Year),
                                                selected = "2015"))),
                    fluidRow(column(width = 6,plotlyOutput(outputId = "plot_high")),
                             column(width = 6,plotlyOutput(outputId = "plot_gdp"))
                    ),
                    fluidRow(column(width = 6,plotlyOutput(outputId = "plot_sup")),
                             column(width = 6,plotlyOutput(outputId = "plot_life"))
                    )
                
            )
    )
),
tabItem(tabName = "predict", 
        fluidRow(column(4,numericInput(inputId = "gdp", 
                                       label = "GDP", 
                                       value = 1.0005,
                                       min = 0, 
                                       max = 2, 
                                       step = 0.000001)),
                 column(4, numericInput(inputId = "sup", 
                                        label = "Support", 
                                        value = 1.34,
                                        min = 0, 
                                        max = 2, 
                                        step = 0.000001)),
                 column(4, numericInput(inputId = "health", 
                                        label = "Healthy Life Expectancy", 
                                        value = 0.95,
                                        min = 0, 
                                        max = 1.5, 
                                        step = 0.000001))),
        fluidRow(column(4,numericInput(inputId = "fre", 
                                       label = "Freedom", 
                                       value = 0.75,
                                       min = 0, 
                                       max = 1, 
                                       step = 0.000001)),
                 column(4, numericInput(inputId = "corupt", 
                                        label = "Corruption Perception", 
                                        value = 0.5,
                                        min = 0, 
                                        max = 1, 
                                        step = 0.000001)),
                 column(4, numericInput(inputId = "gen", 
                                        label = "Generosity", 
                                        value = 0.7,
                                        min = 0, 
                                        max = 1, 
                                        step = 0.000001))),
        fluidRow(column(width = 12,valueBoxOutput("prediction"))
        )
)

    ))





dashboardPage(
    header = header,
    body = body,
    sidebar = sidebar, 
    skin = "green"
)
