#DATA is reused from the DSCI430 Class I took . We cleaned and made this file on that class.

require(shiny)
library(ggplot2)
library(gganimate)
library(dplyr)

Lake <- read.csv("Lake_plus_parcel_summary_for_parcels_within_305_meters.csv", header=TRUE)
Lake<-na.omit(Lake)

ui <- fluidPage(tags$head(
                    tags$style(
                         HTML("
@import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
     
      
      h1 {
        font-family: 'Lobster', cursive;
        font-weight: 500;
        line-height: 2.1;
        color: #48ca3b;
      }

    "))),headerPanel("Watershed Quality in Minnesota"),
                          
                          
                       
               
  
  sidebarLayout(
    sidebarPanel(
     sliderInput("Year",label = "Quality for Year",min = min(Lake$Year),max = max(Lake$Year),value = c(2004,2014)),
      radioButtons("typeInput", "MAJOR_WATERSHED",
                   choices =  unique(Lake$MAJOR_WATERSHED),
                   selected = "Mississippi River - Twin Cities")
    
    ),
    mainPanel(
      
     
      plotOutput("coolplot"),
      br(), br(),
      br(), br(),
     
      
      tableOutput("results")
    
    )
  ))


server <- function(input, output) {
    
  filtered <- reactive({
    if (is.null(input$typeInput)) {
      return(NULL)
    }    
    
    Lake %>%
      filter(Year>=input$Year[1],
             Year<=input$Year[2],
             MAJOR_WATERSHED == input$typeInput
           
      )
  })
  
  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    ggplot(filtered(), aes(Mean.log_phosphorus. ,Mean.Secchi_Depth_RESULT.) ) + geom_point(aes(size = Number.Properties,colour = seasonal.grade)) +
      geom_density_2d(aes(colour = seasonal.grade,fill = stat(level), geom = "polygon") ) +  scale_fill_viridis_c()
    
    
     
   
   
  })
  
  
}

shinyApp(ui = ui, server = server)