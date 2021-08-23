#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$plot_corr <- renderPlot({
        
        gabungan <- rbind(h_2015,h_2016,h_2017,h_2018, h_2019) %>%
            mutate(Corruption_Perception = as.numeric(Corruption_Perception)) %>%
            drop_na()
        
        ggcorr(gabungan %>% filter(Year == input$year) %>% select(-Country), geom = "blank", label = TRUE, hjust = 0.75) +
            geom_point(size = 10, aes(color = coefficient > 0, alpha = abs(coefficient) > 0.5)) +
            scale_alpha_manual(values = c("TRUE" = 0.25, "FALSE" = 0)) +
            guides(color = FALSE, alpha = FALSE)
        
        
        
    })
    
    output$plot_heat <- renderPlotly({
        
        gabungan <- rbind(h_2015,h_2016,h_2017,h_2018, h_2019) %>%
            mutate(Corruption_Perception = as.numeric(Corruption_Perception)) %>%
            drop_na()
        
        heat_map <- ggplot(gabungan %>% 
                               filter(Country == input$neg1|
                                          Country == input$neg2|
                                          Country == input$neg3 |
                                          Country == input$neg4), aes(Year, Country, fill= Score, text = glue("Score: {Score}"))) + 
            geom_tile()+
            scale_fill_viridis(discrete=FALSE)+theme_algoritma+
            labs(title = NULL,
                 x = NULL,
                 y = NULL) 
        
        ggplotly(heat_map, tooltip = "text")
        
        
    })
    
    output$plot_high <- renderPlotly({
        
        gabungan <- rbind(h_2015,h_2016,h_2017,h_2018, h_2019) %>%
            mutate(Corruption_Perception = as.numeric(Corruption_Perception)) %>%
            drop_na()
        
        plot_highest <- ggplot(data = gabungan %>% filter(Year == input$tahun) %>% arrange(desc(Score)) %>% head(input$rank),aes(x = Score,y = reorder(Country, Score), text = glue("Score: {Score}"))) +
            geom_col(aes(fill = Score), show.legend = F) +
            scale_fill_gradient(low = "#1f0101", high = "#fc0303") + 
            labs(y= NULL, x=NULL, 
                 title= "Highest Happiness Score", 
                 caption = NULL) + theme_algoritma
        
        ggplotly(plot_highest, tooltip = "text") %>% layout(showlegend = FALSE)
        
    })
    
    output$plot_gdp <- renderPlotly({
        
        gabungan <- rbind(h_2015,h_2016,h_2017,h_2018, h_2019) %>%
            mutate(Corruption_Perception = as.numeric(Corruption_Perception)) %>%
            drop_na()
        
        plot_gdp <- ggplot(data = gabungan %>% filter(Year == input$tahun) %>% arrange(desc(GDP)) %>% head(input$rank),aes(x = GDP,y = reorder(Country, GDP), text = glue("GDP: {GDP}"))) +
            geom_col(aes(fill = GDP), show.legend = F) +
            scale_fill_gradient(low = "#1f0101", high = "#fc0303") + 
            labs(y= NULL, x=NULL, 
                 title= "Highest GDP", 
                 caption = NULL) + theme_algoritma
        
        ggplotly(plot_gdp, tooltip = "text") %>% layout(showlegend = FALSE)
        
    })
    
    output$plot_sup <- renderPlotly({
        
        gabungan <- rbind(h_2015,h_2016,h_2017,h_2018, h_2019) %>%
            mutate(Corruption_Perception = as.numeric(Corruption_Perception)) %>%
            drop_na()
        
        plot_sup <- ggplot(data = gabungan %>% filter(Year == input$tahun) %>% arrange(desc(Support)) %>% head(input$rank),aes(x = Support,y = reorder(Country, Support), text = glue("Support: {Support}"))) +
            geom_col(aes(fill = Support), show.legend = F) +
            scale_fill_gradient(low = "#1f0101", high = "#fc0303") + 
            labs(y= NULL, x=NULL, 
                 title= "Highest Support Score", 
                 caption = NULL) + theme_algoritma
        
        ggplotly(plot_sup, tooltip = "text") %>% layout(showlegend = FALSE)
        
    })
    
    output$plot_life <- renderPlotly({
        
        gabungan <- rbind(h_2015,h_2016,h_2017,h_2018, h_2019) %>%
            mutate(Corruption_Perception = as.numeric(Corruption_Perception)) %>%
            drop_na()
        
        plot_life <- ggplot(data = gabungan %>% filter(Year == input$tahun) %>% arrange(desc(Healthy_Life_Expectancy)) %>% head(input$rank),aes(x = Healthy_Life_Expectancy,y = reorder(Country, Healthy_Life_Expectancy), text = glue("Healthy_Life_Expectancy: {Healthy_Life_Expectancy}"))) +
            geom_col(aes(fill = Healthy_Life_Expectancy), show.legend = F) +
            scale_fill_gradient(low = "#1f0101", high = "#fc0303") + 
            labs(y= NULL, x=NULL, 
                 title= "Highest Healthy Life Expectancy", 
                 caption = NULL) + theme_algoritma
        
        ggplotly(plot_life, tooltip = "text") %>% layout(showlegend = FALSE)
        
    })
    
    output$prediction <- renderValueBox({
        
        GDP <- input$gdp
        Support <- input$sup
        Healthy_Life_Expectancy <- input$health
        Freedom <- input$fre
        Corruption_Perception <- input$corupt
        Generosity <- input$gen
        
        
        
        test_set <- data.frame(GDP,Support,Healthy_Life_Expectancy,Freedom,Corruption_Perception,Generosity)
        
        rf_model <- randomForest(Score ~ GDP+Support+Healthy_Life_Expectancy+Freedom+Corruption_Perception+Generosity ,
                                 data = training_set,
                                 ntree= 500,
                                 mtry=3,
                                 keep.forest=TRUE,
                                 importance=TRUE)
        
        prediction <- predict(rf_model, test_set)

        
        valueBox(value = round(prediction,4),
                 subtitle = "Happiness Score",
                 color = "teal",
                 icon = icon("grin-alt"))
        
    })

})
