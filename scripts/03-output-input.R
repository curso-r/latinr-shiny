library(shiny)

ui <- fluidPage(
  "Vários histogramas",
  selectInput(
    inputId = "variavel",
    label = "Selecione a variável",
    choices = names(mtcars)
  ),
  plotOutput("hist")
)

server <- function(input, output, session) {
  
  output$hist <- renderPlot({
    hist(mtcars[,input$variavel])
  })
  
}

shinyApp(ui, server)