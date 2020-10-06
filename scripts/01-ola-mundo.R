library(shiny)

ui <- fluidPage(
  "Olá, mundo"
)

server <- function(input, output, session) {

}

shinyApp(ui, server)


# library(shiny)
#
# ui <- fluidPage("Olá, mundo!")
#
# server <- function(input, output, session) {
#   # O nosso código em R será colocado aqui.
# }
#
# shinyApp(ui, server)
