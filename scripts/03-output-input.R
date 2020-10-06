library(shiny)

ui <- fluidPage(
  "Vários histogramas",
  selectInput(
    inputId = "variavel",
    label = "Selecione a variável",
    choices = names(mtcars)
  ),
  selectInput(
    inputId = "variavel_outro_hist",
    label = "Selecione a variável do outro histograma",
    choices = names(mtcars)
  ),
  plotOutput("hist"),
  plotOutput("outro_hist")
)

server <- function(input, output, session) {

  output$hist <- renderPlot({

    coluna <- input$variavel

    dados <- mtcars[[coluna]]

    hist(dados)

  })

  output$outro_hist <- renderPlot({

    coluna <- input$variavel_outro_hist

    dados <- mtcars[[coluna]]

    hist(dados)

  })

}

shinyApp(ui, server)
