library(leaflet)
library(geojsonio)
library(lubridate)
library(rmapshaper)
library(ggplot2)
library(ggthemes)
library(RColorBrewer)
library(tidyverse)
library(plotly)
library(ggpubr)
library(gridExtra)
library(cowplot)
library(shinyWidgets)
library(htmlwidgets)
library(shinyjs)
library(shiny)
library(shinydashboard)

###Johnson Zhang begin====================================================
job_data <- read_csv("../data/na_drop.csv")
job_data$`Posting Date` <- as.Date(job_data$`Posting Date`, "%m/%d/%Y")
job_data_year <- job_data %>% mutate(year = year(`Posting Date`)) %>% group_by(year)  

job_data_full <- job_data %>% dplyr::filter(`Full/Part` == "F")


job_salary <- job_data_full %>% group_by(category) 

figure_salary_box <- ggplot(job_salary, aes(x = category, y = `Salary Range To`, fill = `Career Level`)) +
  geom_boxplot()
#figure_salary_box 

figure_salary_col <- ggplot(job_salary, aes(x = category, y = `Salary Range To`, color = `Career Level`)) +
  geom_point() + labs(y = "salary")
figure_salary_col


figure_time <- ggplot(job_data_year, aes(x = year, fill =`Full/Part` ))+ geom_bar() 
#figure_time 

job_salary_factor <- job_data_year %>% 
  dplyr::select(`Job ID`,`Full/Part`,`year`,`Career Level`,"salary" = `Salary Range To`) %>%
  mutate(salary_range = cut(salary, breaks = c(0,30000,50000,70000,100000,120000,150000,200000,300000))) %>%
  mutate(salary_range = fct_recode(salary_range, "below 3000" = "(0,3e+04]",
                                   "30000~50000" = "(3e+04,5e+04]",
                                   "50000~70000" = "(5e+04,7e+04]",
                                   "70000~100000" = "(7e+04,1e+05]",
                                   "100000~120000" = "(1e+05,1.2e+05]",
                                   "120000~150000" = "(1.2e+05,1.5e+05]",
                                   "150000~200000" = "(1.5e+05,2e+05]",
                                   "200000~300000" = "(2e+05,3e+05]"))
figure_salary_count <- ggplot(job_salary_factor, aes(x = year, fill = salary_range ))+
                                geom_bar()
figure_salary_count




###Johnson Zhang end======================================================
