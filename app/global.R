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
figure_time 

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
###Stephen Li begin=====================================================
##arrange the job by available
arrange_by_available<-job_data%>%arrange(desc(`num_positions`))
#first we figure out the top 10 job title arrange by job title
job_title_available<-arrange_by_available%>%select(num_positions,title)%>%mutate(num_positions=sum(num_positions))%>%group_by(title,add=T)%>%
  mutate(num_positions=sum(num_positions))%>%
  arrange(desc(num_positions))%>%distinct(num_positions)
job_title_available_10<-job_title_available[1:9,]%>%ungroup(title)%>%mutate(title=factor(title,levels=rev(title)))
#then we figure out the agency of top 10 avilable job
agency_availabe<-arrange_by_available%>%select(num_positions,Agency)%>%mutate(num_positions=sum(num_positions))%>%group_by(Agency,add=T)%>%
  mutate(num_positions=sum(num_positions))%>%
  arrange(desc(num_positions))%>%distinct(num_positions)
agency_availabe_10<-agency_availabe[1:9,]%>%ungroup(Agency)%>%mutate(Agency=factor(Agency,levels=rev(Agency)))
##arrange the job by salary
arrange_by_salary<-job_data%>%arrange(desc(`Salary Range To`))
#also first we figure out the top 10 job title with highest salary
job_title_salary<-arrange_by_salary%>%select(`Salary Range To`,title)%>%group_by(title)%>%arrange(desc(`Salary Range To`))%>%
  mutate(`Salary Range To`=max(`Salary Range To`))%>%distinct(`Salary Range To`)
job_title_salary_10<-job_title_salary[1:9,]%>%ungroup(title)%>%mutate(title=factor(title,levels=rev(title)))
#also figure out the agency of top 10 salary
agency_salary<-arrange_by_salary%>%select(`Salary Range To`,Agency)%>%group_by(Agency)%>%arrange(desc(`Salary Range To`))%>%
  mutate(`Salary Range To`=max(`Salary Range To`))%>%distinct(`Salary Range To`)
agency_salary_10<-agency_salary[1:9,]%>%ungroup(Agency)%>%mutate(Agency=factor(Agency,levels=rev(Agency)))
#then we plot the picture we need
#1
available_title<-ggplot(job_title_available_10,aes(x=title,y=num_positions,fill=title)) +
  geom_bar(stat='identity')+ scale_fill_brewer()+
  coord_flip()+ 
  geom_text(aes(label = num_positions, vjust = 0.5, hjust = -0.2))+ 
  theme(legend.position='none')+  
  ylim(0,2000000)+theme_light()+labs(title="Top's available Job Title",y="Title",x="Positions Number")  
#2
available_agency<-ggplot(agency_availabe_10,aes(x=Agency,y=num_positions,fill=Agency)) +
  geom_bar(stat='identity')+ scale_fill_brewer()+
  coord_flip()+ 
  geom_text(aes(label = num_positions, vjust = 0.5, hjust = -0.2))+ 
  theme(legend.position='none')+  
  ylim(0,4004145)+theme_light()+labs(title="Top's available Job Agency",y="Agency",x="Positions Number")  
#3
salary_title<-ggplot(job_title_salary_10,aes(x=title,y=`Salary Range To`,fill=title)) +
  geom_bar(stat='identity')+ scale_fill_brewer()+
  coord_flip()+ 
  geom_text(aes(label = `Salary Range To`, vjust = 0.5, hjust = -0.2))+ 
  theme(legend.position='none')+  
  ylim(0,300000)+theme_light()+labs(title="Top's Salary Job Title",y="Title",x="Salary")  
#4
salary_agency<-ggplot(agency_salary_10,aes(x=Agency,y=`Salary Range To`,fill=Agency)) +
  geom_bar(stat='identity')+ scale_fill_brewer()+
  coord_flip()+ 
  geom_text(aes(label = `Salary Range To`, vjust = 0.5, hjust = -0.2))+ 
  theme(legend.position='none')+  
  ylim(0,300000)+theme_light()+labs(title="Top's Salary Job Agency",y="Agency",x="Salary")  
###Stephen Li =====================================================

### Suzie plot begin =====================================================
data <- read.csv("../data/na_drop.csv")
#data = read.csv("na_drop.csv", header = TRUE)

data_FUll_Part = as.data.frame(table(data$Full.Part))
colnames(data_FUll_Part) = c("categories","amount") 

data_Career_Level = as.data.frame(table(data$Career.Level))
colnames(data_Career_Level) = c("categories","amount") 

data_category = as.data.frame(table(data$category))
colnames(data_category) = c("categories","amount") 

data_borough = as.data.frame(table(data$borough))
colnames(data_borough) = c("categories","amount") 

# p <- plot_ly() %>%
#   add_pie(data = data_FUll_Part , labels = ~categories, values = ~amount,
#           name = "Full_Part",
#           title = "Part time or Full time",
#           domain = list(row = 0, column = 0))%>%
#   
#   add_pie(data = data_Career_Level , labels = ~categories, values = ~amount,
#           name = "Caeer Level",
#           title = "Caeer Level",
#           domain = list(row = 0, column = 1))%>%
#   
#   add_pie(data = data_category , labels = ~categories, values = ~amount,
#           name = "Category",
#           title = "Category",
#           domain = list(row = 1, column = 0))%>%
#   
#   add_pie(data = data_borough , labels = ~categories, values = ~amount,
#           name = "borough",
#           title = "Borough",
#           domain = list(row = 1, column = 1))%>%
#   
#   layout(title = "Pie Chart Summary of NYC Job Data", showlegend = F,
#          grid=list(rows=2, columns=2),
#          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
#          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
#p

p <- plot_ly() %>%
  add_pie(data = data_FUll_Part , labels = ~categories, values = ~amount,
          name = "Full_Part",
          title = "Part time or Full time",
          domain = list(row = 0, column = 0))%>%
  
  add_pie(data = data_Career_Level , labels = ~categories, values = ~amount,
          name = "Caeer Level",
          title = "Caeer Level",
          domain = list(row = 0, column = 1))%>%
  
  add_pie(data = data_category , labels = ~categories, values = ~amount,
          name = "Category",
          title = "Category",
          domain = list(row = 1, column = 0))%>%
  
  add_pie(data = data_borough , labels = ~categories, values = ~amount,
          name = "borough",
          title = "Borough",
          domain = list(row = 1, column = 1))%>%
  
  layout(title = "Pie Charts Summary of NYC Job Data", showlegend = F,
         grid=list(rows=2, columns=2),
         paper_bgcolor='transparent',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
  )
p



#pie_chart

#donut_chart_begin

data_agency = aggregate(data$num_positions, by = list(Category = data$Agency), FUN=sum)
colnames(data_agency) = c("Agency","Amount")

q <- data_agency %>%
  group_by(Agency) %>%
  plot_ly(labels = ~Agency, values = ~Amount) %>%
  add_pie(hole = 0.7) %>%
  layout(title = "Number of positons by Agency",  showlegend = F,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

# q

### Suzie plot end ========================================================
























