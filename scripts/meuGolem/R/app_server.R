#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {


  callModule(mod_mapa_server, "mapa_ui_1")

  callModule(
    esquisse::esquisserServer,
    "esquisse",
    data = list(data = dados::aeroportos, name = "aeroportos")
  )

}
