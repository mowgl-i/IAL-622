#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(reactable)

Titanic = read_csv('https://raw.githubusercontent.com/NotAyushXD/Titanic-dataset/master/train.csv')

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Titanic Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            plotOutput("distPlot_titanic"),
            radioButtons('class','Which passenger class would you like to view?',c('1','2','3')),
            plotOutput('Plot_by_class')

        ),

        # Show a plot of the generated distribution
        mainPanel(
            reactableOutput('dynamic_table')

        )
    )
)
# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot_titanic <- renderPlot({
        ggplot(Titanic,aes(x = Fare))+
            geom_histogram(bins = input$bins)+
            labs(title = 'Histogram of Fare')+
            xlab('Fare')})

    output$Plot_by_class <- renderPlot({
        Titanic %>% filter(Pclass == input$class) %>%
            ggplot(aes(x = Sex, y = Fare, color = Sex))+
            geom_boxplot()+
            labs(title = 'Plot of Fare by Sex', subtitle = 'This plot is seperated by passenger class')})


    output$dynamic_table <- renderReactable({reactable(Titanic)})

}

# Run the application
shinyApp(ui = ui, server = server)
