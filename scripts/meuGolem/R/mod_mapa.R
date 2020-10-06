#' mapa UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_mapa_ui <- function(id){
  ns <- NS(id)
  tagList(
    leaflet::leafletOutput(ns("mapa"), height = "1000px")
  )
}

#' mapa Server Function
#'
#' @noRd
mod_mapa_server <- function(input, output, session){
  ns <- session$ns

  output$mapa <- leaflet::renderLeaflet({

    dados::aeroportos %>%
      leaflet::leaflet() %>%
      leaflet::addTiles() %>%
      leaflet::addMarkers(
        clusterOptions = leaflet::markerClusterOptions(),
        label = ~nome
      )

  })

}

## To be copied in the UI
# mod_mapa_ui("mapa_ui_1")

## To be copied in the server
# callModule(mod_mapa_server, "mapa_ui_1")

