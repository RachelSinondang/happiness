library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(glue)
library(viridis)
library(tidyverse)
library(GGally)

theme_algoritma <- theme(legend.key = element_rect(fill="black"),
                         legend.background = element_rect(color="white", fill="#263238"),
                         plot.subtitle = element_text(size=6, color="white"),
                         panel.background = element_rect(fill="#dddddd"),
                         panel.border = element_rect(fill=NA),
                         panel.grid.minor.x = element_blank(),
                         panel.grid.major.x = element_blank(),
                         panel.grid.major.y = element_line(color="darkgrey", linetype=2),
                         panel.grid.minor.y = element_blank(),
                         plot.background = element_rect(fill="#263238"),
                         text = element_text(color="white"),
                         axis.text = element_text(color="white")
                         
)

happy_2015 <- read.csv("2015.csv")
happy_2016 <- read.csv("2016.csv")
happy_2017 <- read.csv("2017.csv")
happy_2018 <- read.csv("2018.csv")
happy_2019 <- read.csv("2019.csv")
happy_2020 <- read.csv("2020.csv")

happy_2015 <- happy_2015 %>%
  select(-c(Region, Happiness.Rank, Standard.Error, Dystopia.Residual)) %>%
  rename(Score = Happiness.Score,
         GDP = Economy..GDP.per.Capita.,
         Support = Family,
         Healthy_Life_Expectancy = Health..Life.Expectancy.,
         Corruption_Perception = Trust..Government.Corruption.)

happy_2016 <- happy_2016 %>% 
  select(-c(Region, Happiness.Rank,Dystopia.Residual,Lower.Confidence.Interval,Upper.Confidence.Interval)) %>%
  rename(Score = Happiness.Score,
         GDP = Economy..GDP.per.Capita.,
         Support = Family,
         Healthy_Life_Expectancy = Health..Life.Expectancy.,
         Corruption_Perception = Trust..Government.Corruption.)

happy_2017 <- happy_2017 %>%
  select(-c(Happiness.Rank,Whisker.high,Whisker.low,Dystopia.Residual)) %>%
  rename(Score = Happiness.Score,
         GDP = Economy..GDP.per.Capita.,
         Support = Family,
         Healthy_Life_Expectancy = Health..Life.Expectancy.,
         Corruption_Perception = Trust..Government.Corruption.)

happy_2018 <- happy_2018 %>%
  select(-Overall.rank) %>%
  rename(GDP = GDP.per.capita,
         Support = Social.support,
         Healthy_Life_Expectancy = Healthy.life.expectancy,
         Corruption_Perception = Perceptions.of.corruption,
         Freedom = Freedom.to.make.life.choices,
         Country = Country.or.region)

happy_2019 <- happy_2019 %>%
  select(-Overall.rank) %>%
  rename(GDP = GDP.per.capita,
         Country = Country.or.region,
         Support = Social.support,
         Healthy_Life_Expectancy = Healthy.life.expectancy,
         Corruption_Perception = Perceptions.of.corruption,
         Freedom = Freedom.to.make.life.choices)

happy_2020 <- happy_2020 %>%
  select(c(Country.name,Ladder.score,Social.support,Healthy.life.expectancy,Perceptions.of.corruption,Freedom.to.make.life.choices,Generosity,Logged.GDP.per.capita)) %>%
  rename(Score = Ladder.score,
         GDP = Logged.GDP.per.capita,
         Support = Social.support,
         Healthy_Life_Expectancy = Healthy.life.expectancy,
         Corruption_Perception = Perceptions.of.corruption,
         Freedom = Freedom.to.make.life.choices,
         Country = Country.name)

h_2015 <- cbind(data.frame(Year = "2015"), happy_2015)
h_2016 <- cbind(data.frame(Year = "2016"), happy_2016)
h_2017 <- cbind(data.frame(Year = "2017"), happy_2017)
h_2018 <- cbind(data.frame(Year = "2018"), happy_2018)
h_2019 <- cbind(data.frame(Year = "2019"), happy_2019)
h_2020 <- cbind(data.frame(Year = "2020"), happy_2020)

gabungan <- rbind(h_2015,h_2016,h_2017,h_2018, h_2019) %>%
  mutate(Corruption_Perception = as.numeric(Corruption_Perception)) %>%
  drop_na()