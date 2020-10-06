library(shiny)
library(bs4Dash)

ui <- dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    title = "Titulo",

    sidebarMenu(
      menuItem(
        "Dashboard",
        tabName = "dashboard"
      ),
      menuItem(
        "Mapa",
        tabName = "mapa"
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "dashboard",
        ""
      ),
      tabItem(
        tabName = "mapa",
        leaflet::leafletOutput("mapaAeroportos")
      )
    )

  )
)

server <- function(input, output) {


  output$mapaAeroportos <- leaflet::renderLeaflet({
    dados::aeroportos %>%
      leaflet::leaflet() %>%
      leaflet::addTiles() %>%
      leaflet::addMarkers(
        clusterOptions = leaflet::markerClusterOptions(),
        label = ~nome
      )
  })

}

shinyApp(ui, server)
