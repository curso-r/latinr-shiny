library(shiny)

ui <- fluidPage(
  "Um histograma",
  plotOutput("hist")
)

server <- function(input, output, session) {
  
  output$hist <- renderPlot({
    hist(mtcars$mpg)
  })
  
}

shinyApp(ui, server)