library(shiny)

ui <- fluidPage(
  "Um histograma",
  plotOutput(outputId = "grafico")
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({

    dados <- mtcars$mpg

    hist(dados)

  })

}

shinyApp(ui, server)










# library(shiny)
#
# ui <- fluidPage(
#   "Um histograma",
#   plotOutput("hist")
# )
#
# server <- function(input, output, session) {
#
#   output$hist <- renderPlot({
#     hist(mtcars$mpg)
#   })
#
# }
#
# shinyApp(ui, server)
